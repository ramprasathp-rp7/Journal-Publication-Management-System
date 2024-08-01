--@ "C:\rohith\college\sem4\dbms\project\database.sql"

-- Drop existing tables with cascade constraints
DROP TABLE Keyword CASCADE CONSTRAINTS;
DROP TABLE Organizer CASCADE CONSTRAINTS;
DROP TABLE Sponsor CASCADE CONSTRAINTS;
DROP TABLE Event_Details CASCADE CONSTRAINTS;
DROP TABLE Event_Sponsor CASCADE CONSTRAINTS;
DROP TABLE Track CASCADE CONSTRAINTS;
DROP TABLE Task CASCADE CONSTRAINTS;
DROP TABLE Task_SubTask CASCADE CONSTRAINTS;
DROP TABLE SubTask CASCADE CONSTRAINTS;
DROP TABLE Task_Resource CASCADE CONSTRAINTS;
DROP TABLE Participant CASCADE CONSTRAINTS;
DROP TABLE Author CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
DROP TABLE Proceeding CASCADE CONSTRAINTS;
DROP TABLE Sponsor_Type CASCADE CONSTRAINTS;
DROP TABLE Paper CASCADE CONSTRAINTS;
DROP TRIGGER UpdateTotalScore;

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

-- Create Keyword table
CREATE TABLE Keyword (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100)
);

-- Create Organizer table
CREATE TABLE Organizer (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Email VARCHAR2(100),
    Type VARCHAR2(50)
);

-- Create Sponsor table
CREATE TABLE Sponsor (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Email VARCHAR2(100)
);

-- Create Event table
CREATE TABLE Event_Details (
    ID NUMBER PRIMARY KEY,
    Type VARCHAR2(50),
    Title VARCHAR2(200),
    Event_Date DATE,
    Location VARCHAR2(200),
    OrganizerID NUMBER,
    FOREIGN KEY (OrganizerID) REFERENCES Organizer(ID)
);

-- Create Event-Sponsor relationship table
CREATE TABLE Event_Sponsor (
    EventID NUMBER,
    SponsorID NUMBER,
    PRIMARY KEY (EventID, SponsorID),
    FOREIGN KEY (EventID) REFERENCES Event_Details(ID),
    FOREIGN KEY (SponsorID) REFERENCES Sponsor(ID)
);

-- Create Track table
CREATE TABLE Track (
    ID NUMBER PRIMARY KEY,
    Title VARCHAR2(200),
    Description VARCHAR2(500),
    EventID NUMBER,
    FOREIGN KEY (EventID) REFERENCES Event_Details(ID)
);

-- Create Task table
CREATE TABLE Task (
    ID NUMBER PRIMARY KEY,
    Title VARCHAR2(200),
    Deadline DATE,
    TrackID NUMBER,
    FOREIGN KEY (TrackID) REFERENCES Track(ID)
);

-- Create Paper table with TotalScore column
CREATE TABLE Paper (
    ID NUMBER PRIMARY KEY,
    Title VARCHAR2(200),
    Abstract VARCHAR2(1000),
    TaskID NUMBER,
    TotalScore NUMBER DEFAULT 0,
    FOREIGN KEY (TaskID) REFERENCES Task(ID)
);

-- Create Sub-Task table
CREATE TABLE SubTask (
    ID NUMBER PRIMARY KEY,
    Title VARCHAR2(200),
    Description VARCHAR2(500),
    ResourcePath VARCHAR2(300)
);

-- Create Task-SubTask relationship table
CREATE TABLE Task_SubTask (
    TaskID NUMBER,
    SubTaskID NUMBER,
    PRIMARY KEY (TaskID, SubTaskID),
    FOREIGN KEY (TaskID) REFERENCES Task(ID),
    FOREIGN KEY (SubTaskID) REFERENCES SubTask(ID)
);

-- Create Resource table
CREATE TABLE Task_Resource (
    ID NUMBER PRIMARY KEY,
    Description VARCHAR2(500),
    Path VARCHAR2(300)
);

-- Create Participant table
CREATE TABLE Participant (
    ID NUMBER PRIMARY KEY,
    Affiliation VARCHAR2(20),
    Name VARCHAR2(20),
    Email VARCHAR2(20),
    Type VARCHAR2(20)
);

-- Create Author table
CREATE TABLE Author (
    PaperID NUMBER,
    AuthorID NUMBER,
    PRIMARY KEY (PaperID, AuthorID),
    FOREIGN KEY (PaperID) REFERENCES Paper(ID),
    FOREIGN KEY (AuthorID) REFERENCES Participant(ID)
);

-- Create Review table
CREATE TABLE Review (
    ReviewID NUMBER,
    PaperID NUMBER,
    ParticipantID NUMBER,
    Comments VARCHAR2(20),
    Score NUMBER,
    PRIMARY KEY (PaperID, ParticipantID),
    FOREIGN KEY (PaperID) REFERENCES Paper(ID),
    FOREIGN KEY (ParticipantID) REFERENCES Participant(ID)
);

-- Create Proceeding table
CREATE TABLE Proceeding (
    ID NUMBER PRIMARY KEY,
    Title VARCHAR2(200),
    FilePath VARCHAR2(300),
    IssueDate DATE,
    EventID NUMBER,
    FOREIGN KEY (EventID) REFERENCES Event_Details(ID)
);

-- Create Type table
CREATE TABLE Sponsor_Type (
    ID NUMBER PRIMARY KEY,
    TypeName VARCHAR2(100),
    Perks VARCHAR2(200),
    Price NUMBER
);

-- Create trigger to update TotalScore in Paper table
CREATE OR REPLACE TRIGGER UpdateTotalScore
BEFORE INSERT OR UPDATE OR DELETE ON Review
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Update TotalScore when a new review is added
        UPDATE Paper
        SET TotalScore = TotalScore + :NEW.Score
        WHERE ID = :NEW.PaperID;
        
    ELSIF UPDATING THEN
        -- Adjust TotalScore when an existing review is updated
        UPDATE Paper
        SET TotalScore = TotalScore - :OLD.Score + :NEW.Score
        WHERE ID = :NEW.PaperID;
        
    ELSIF DELETING THEN
        -- Update TotalScore when a review is deleted
        UPDATE Paper
        SET TotalScore = TotalScore - :OLD.Score
        WHERE ID = :OLD.PaperID;
    END IF;
END;
/

-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

-- Insert values into Keyword table
INSERT INTO Keyword (ID, Name) VALUES (1, 'Artificial Intelligence');
INSERT INTO Keyword (ID, Name) VALUES (2, 'Machine Learning');
INSERT INTO Keyword (ID, Name) VALUES (3, 'Data Science');

-- Insert values into Organizer table
INSERT INTO Organizer (ID, Name, Email, Type) VALUES (1, 'John Doe', 'john.doe@example.com', 'Individual');
INSERT INTO Organizer (ID, Name, Email, Type) VALUES (2, 'Tech Org', 'info@techorg.com', 'Organization');
INSERT INTO Organizer (ID, Name, Email, Type) VALUES (3, 'Event Planner', 'planner@example.com', 'Individual');

-- Insert values into Sponsor table
INSERT INTO Sponsor (ID, Name, Email) VALUES (1, 'Company A', 'contact@companya.com');
INSERT INTO Sponsor (ID, Name, Email) VALUES (2, 'Company B', 'contact@companyb.com');
INSERT INTO Sponsor (ID, Name, Email) VALUES (3, 'Company C', 'contact@companyc.com');

-- Insert values into Event_Details table
INSERT INTO Event_Details (ID, Type, Title, Event_Date, Location, OrganizerID) 
VALUES (1, 'Conference', 'Tech Conference 2024', TO_DATE('2024-09-01', 'YYYY-MM-DD'), 'New York', 1);
INSERT INTO Event_Details (ID, Type, Title, Event_Date, Location, OrganizerID) 
VALUES (2, 'Workshop', 'AI Workshop', TO_DATE('2024-10-10', 'YYYY-MM-DD'), 'San Francisco', 2);
INSERT INTO Event_Details (ID, Type, Title, Event_Date, Location, OrganizerID) 
VALUES (3, 'Seminar', 'Data Science Seminar', TO_DATE('2024-11-15', 'YYYY-MM-DD'), 'Los Angeles', 3);

-- Insert values into Event_Sponsor table
INSERT INTO Event_Sponsor (EventID, SponsorID) VALUES (1, 1);
INSERT INTO Event_Sponsor (EventID, SponsorID) VALUES (2, 2);
INSERT INTO Event_Sponsor (EventID, SponsorID) VALUES (3, 3);

-- Insert values into Track table
INSERT INTO Track (ID, Title, Description, EventID) 
VALUES (1, 'AI Track', 'All about Artificial Intelligence', 1);
INSERT INTO Track (ID, Title, Description, EventID) 
VALUES (2, 'ML Track', 'Deep dive into Machine Learning', 2);
INSERT INTO Track (ID, Title, Description, EventID) 
VALUES (3, 'DS Track', 'Exploring Data Science', 3);

-- Insert values into Task table
INSERT INTO Task (ID, Title, Deadline, TrackID) 
VALUES (1, 'Task 1', TO_DATE('2024-08-15', 'YYYY-MM-DD'), 1);
INSERT INTO Task (ID, Title, Deadline, TrackID) 
VALUES (2, 'Task 2', TO_DATE('2024-09-25', 'YYYY-MM-DD'), 2);
INSERT INTO Task (ID, Title, Deadline, TrackID) 
VALUES (3, 'Task 3', TO_DATE('2024-10-30', 'YYYY-MM-DD'), 3);

-- Insert values into Paper table
INSERT INTO Paper (ID, Title, Abstract, TaskID, TotalScore) 
VALUES (1, 'Paper 1', 'Abstract of Paper 1', 1, 0);
INSERT INTO Paper (ID, Title, Abstract, TaskID, TotalScore) 
VALUES (2, 'Paper 2', 'Abstract of Paper 2', 2, 0);
INSERT INTO Paper (ID, Title, Abstract, TaskID, TotalScore) 
VALUES (3, 'Paper 3', 'Abstract of Paper 3', 3, 0);

-- Insert values into SubTask table
INSERT INTO SubTask (ID, Title, Description, ResourcePath) 
VALUES (1, 'SubTask 1', 'Description of SubTask 1', '/path/to/resource1');
INSERT INTO SubTask (ID, Title, Description, ResourcePath) 
VALUES (2, 'SubTask 2', 'Description of SubTask 2', '/path/to/resource2');
INSERT INTO SubTask (ID, Title, Description, ResourcePath) 
VALUES (3, 'SubTask 3', 'Description of SubTask 3', '/path/to/resource3');

-- Insert values into Task_SubTask table
INSERT INTO Task_SubTask (TaskID, SubTaskID) VALUES (1, 1);
INSERT INTO Task_SubTask (TaskID, SubTaskID) VALUES (2, 2);
INSERT INTO Task_SubTask (TaskID, SubTaskID) VALUES (3, 3);

-- Insert values into Task_Resource table
INSERT INTO Task_Resource (ID, Description, Path) 
VALUES (1, 'Resource 1 Description', '/path/to/resource1');
INSERT INTO Task_Resource (ID, Description, Path) 
VALUES (2, 'Resource 2 Description', '/path/to/resource2');
INSERT INTO Task_Resource (ID, Description, Path) 
VALUES (3, 'Resource 3 Description', '/path/to/resource3');

-- Insert values into Participant table
INSERT INTO Participant (ID, Affiliation, Name, Email, Type) 
VALUES (1, 'Univ A', 'Alice', 'alice@ex.com', 'Author');
INSERT INTO Participant (ID, Affiliation, Name, Email, Type) 
VALUES (2, 'Univ B', 'Bob', 'bob@ex.com', 'Reviewer');
INSERT INTO Participant (ID, Affiliation, Name, Email, Type) 
VALUES (3, 'Univ C', 'Charlie', 'charlie@ex.com', 'Attendee');

-- Insert values into Author table
INSERT INTO Author (PaperID, AuthorID) VALUES (1, 1);
INSERT INTO Author (PaperID, AuthorID) VALUES (2, 1);
INSERT INTO Author (PaperID, AuthorID) VALUES (3, 1);

-- Insert values into Review table
INSERT INTO Review (ReviewID, PaperID, ParticipantID, Comments, Score) 
VALUES (1, 1, 2, 'Excellent.', 9);
INSERT INTO Review (ReviewID, PaperID, ParticipantID, Comments, Score) 
VALUES (2, 2, 3, 'Good.', 8);
INSERT INTO Review (ReviewID, PaperID, ParticipantID, Comments, Score) 
VALUES (3, 3, 1, 'Splendid.', 7);
INSERT INTO Review (ReviewID, PaperID, ParticipantID, Comments, Score) 
VALUES (4, 1, 3, 'Insightful.', 8);
INSERT INTO Review (ReviewID, PaperID, ParticipantID, Comments, Score) 
VALUES (5, 2, 1, 'Great.', 6);


-- Insert values into Proceeding table
INSERT INTO Proceeding (ID, Title, FilePath, IssueDate, EventID) 
VALUES (1, 'Proceeding 1', '/path/to/proceeding1', TO_DATE('2024-09-02', 'YYYY-MM-DD'), 1);
INSERT INTO Proceeding (ID, Title, FilePath, IssueDate, EventID) 
VALUES (2, 'Proceeding 2', '/path/to/proceeding2', TO_DATE('2024-10-11', 'YYYY-MM-DD'), 2);
INSERT INTO Proceeding (ID, Title, FilePath, IssueDate, EventID) 
VALUES (3, 'Proceeding 3', '/path/to/proceeding3', TO_DATE('2024-11-16', 'YYYY-MM-DD'), 3);

-- Insert values into Sponsor_Type table
INSERT INTO Sponsor_Type (ID, TypeName, Perks, Price) 
VALUES (1, 'Platinum', 'All-access pass, Logo on materials', 10000);
INSERT INTO Sponsor_Type (ID, TypeName, Perks, Price) 
VALUES (2, 'Gold', 'All-access pass', 5000);
INSERT INTO Sponsor_Type (ID, TypeName, Perks, Price) 
VALUES (3, 'Silver', 'Logo on materials', 2500);

commit;


