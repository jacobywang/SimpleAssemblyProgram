//
//  UI.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 5/30/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation

class UI{
    
    func interFace(){
        var running = true
        var path = ""
        var assemblers: [String : Assembler] = [:]
        
        print("Welcome to SAP!\n\nSAP Help:\nasm <program name> - assemble the specified program\nrun <program name> - run the specified program\npath <path specification> - set the path for the SAP program directory include final / but not name of file. SAP file must have an extension of .txt\nprintlst <program name> - print listing file for the specified program\nprintbin <program name> - print binary file for the specified program\nprintsym <program name> - print symbol table for the specified program\nquit  - terminate SAP program\nhelp  - print help table\n")
        
        while running{
            print("Enter option...")
            let input = splitStringintoParts(expression: getInput())
            switch input[0]{
            case "asm":
                if input.count == 2{
                    if let _ = readTextFile("\(path)\(input[1]).txt").1{
                        assemblers[input[1]] = Assembler("\(path)\(input[1]).txt")
                        print("Successfully assembled")
                    }else{
                        print("Check current path or fileName")
                    }
                }else{
                    print("Need 'asm' and file name")
                }
            case "run":
                if input.count == 2{
                    if let a = assemblers[input[1]]{
                        a.runTuring()
                    }else{
                        print("First Assemble — \(input[1])")
                    }
                }else{
                    print("Need just 'run' and file name")
                }
                
            case "path":
                path = input[1]
            case "printlst":
                if input.count == 2{
                    if let a = assemblers[input[1]]{
                        a.printList()
                    }else{
                        print("First Assemble — \(input[1])")
                    }
                }else{
                    print("Need just 'printlst' and file name")
                }
            case "printbin":
                if input.count == 2{
                    if let a = assemblers[input[1]]{
                        a.printBinary()
                    }else{
                        print("First Assemble — \(input[1])")
                    }
                }else{
                    print("Need just 'printbin' and file name")
                }
            case "printsym":
                if input.count == 2{
                    if let a = assemblers[input[1]]{
                        a.printSymbolTable()
                    }else{
                        print("First Assemble — \(input[1])")
                    }
                }else{
                    print("Need just 'printsym' and file name")
                }
            case "quit":
                running = false
                print("Goodbye")
            case "help":
                print("SAP Help:\nasm <program name> - assemble the specified program\nrun <program name> - run the specified program\npath <path specification> - set the path for the SAP program directory include final / but not name of file. SAP file must have an extension of .txt\nprintlst <program name> - print listing file for the specified program\nprintbin <program name> - print binary file for the specified program\nprintsym <program name> - print symbol table for the specified program\nquit  - terminate SAP program\nhelp  - print help table\n")
            default:
                print("\(input) — does not match an input choice")
            }
            print("\n")
        }
    }
    
    //gets input from user
    func getInput() -> String {
        // 1
        let keyboard = FileHandle.standardInput
        // 2
        let inputData = keyboard.availableData
        // 3
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        // 4
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
}
