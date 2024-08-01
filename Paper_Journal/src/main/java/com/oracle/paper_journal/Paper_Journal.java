/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.oracle.paper_journal;

import java.util.*;
/**
 *
 * @author rohit
 */
public class Paper_Journal {

    public static void main(String[] args) {
        paper paper = new paper();
        review review = new review();
        participant participant = new participant();
        
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter the table to be viewed: ");
        System.out.println("1. Participant");
        System.out.println("2. Review");
        System.out.println("3. Paper");
        int choice = scanner.nextInt();
        
        if (choice == 1){
            participant.show();
        }
        else if (choice == 2){
            review.show();
        }
        else if (choice == 3){
            paper.show();
        }
        else{
            System.out.println("Invalid Input");
        }
        
    }
}
