//
//  VR.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 4/5/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation


class VirtualMachine{
    var r = [Int](repeating: 0, count: 10)
    var memory: [Int] = []
    var theStack = Stack<Int>(size: 10000)
    
    var pointer = 0
    var length = 0
    var headerLength = 0 //where real program starts
    var lastComparison = 0 //comprr is a subtraction of the first from the second
    
    func runProgram(_ input: String){
        var arrayStringInput = splitStringintoLines(expression: input)
        var binary = arrayStringInput.map{Int($0)!}
        var output = ""
        
        var halted = false
        length = binary[0]
        headerLength = binary[1]
        pointer = binary[1]
        var subroutinePointer = 0
        binary.remove(at: 0)
        binary.remove(at: 0)
        
        while pointer < binary.count && halted == false{
            //print("(\(pointer + 3)**\(binary[pointer]))")
        //while binary[pointer] != 0{
            //print("\(pointer+3)**\(binary[pointer])")
            //r1 = r[binary[pointer + 1]]
            //r2 = r[binary[pointer + 2]]
            switch binary[pointer]{//instruction
            case 0://halt
                halted = true
            case 1: //clrr
                r[binary[pointer+1]] = 0
                pointer += 2
            case 2: //clrx
                binary[r[binary[pointer + 1]]] = 0
                pointer += 2
            case 3 : //clrm
                binary[pointer + 1] = 0
            case 4 : //clrb
                for i in binary[pointer + 1]...binary[pointer + 2] + binary[pointer + 1] - 1{
                    r[i] = 0
                }
                pointer += 3
            case 5 : //movir
                r[binary[pointer + 2]] = binary[pointer + 1]
                pointer += 3
            case 6://movrr
                r[binary[pointer + 2]] = r[binary[pointer + 1]]
                pointer += 3
            case 7 : //movrm
                binary[binary[pointer + 2]] = r[binary[pointer + 1]]
                pointer += 3
            case 8://movmr
                r[binary[pointer + 2]] = binary[binary[pointer + 1]] //r1 = m1
                pointer += 3
            case 9 : //movxr
                r[binary[pointer + 2]] = binary[r[binary[pointer + 1]]]
                pointer += 3
            case 10 : //movar
                r[binary[pointer + 2]] = binary[pointer + 1]
                pointer += 3
            case 11 : //movb
                break //to do
            case 12://addir
                r[binary[pointer + 2]] += binary[pointer + 1] //r1 + m1
                pointer += 3
            case 13://addrr
                r[binary[pointer + 2]] += r[binary[pointer + 1]]
                pointer += 3
            case 14 : //addmr
                r[binary[pointer + 2]] += binary[binary[pointer + 1]]
                pointer += 3
            case 15 : //addxr
                //print("r1 = \(r[binary[pointer + 1]]) bin[r] = \(binary[r[binary[pointer + 1]]]) r2 = \(r[binary[pointer + 2]])")
                r[binary[pointer + 2]] += binary[r[binary[pointer + 1]]]
                //print("r2 = \(r[binary[pointer + 2]])")
                pointer += 3
            case 16 : //subir
                r[binary[pointer + 2]] -= binary[pointer + 1]
                pointer += 3
            case 17 : //subrr
                r[binary[pointer + 2]] -= r[binary[pointer + 1]]
                pointer += 3
            case 18 : //submr
                r[binary[pointer + 2]] -= binary[binary[pointer + 1]]
                pointer += 3
            case 19 : //subxr
                r[binary[pointer + 2]] -= binary[r[binary[pointer + 1]]]
                pointer += 3
            case 20 : //mulir
                r[binary[pointer + 2]] *= binary[pointer + 1]
                pointer += 3
            case 21 : //mulrr
                r[binary[pointer + 2]] *= r[binary[pointer + 1]]
                pointer += 3
            case 22 : //mulmr
                r[binary[pointer + 2]] *= binary[binary[pointer + 1]]
                pointer += 3
            case 23 : //mulxr
                r[binary[pointer + 2]] *= binary[r[binary[pointer + 1]]]
                pointer += 3
            case 24 : //divir
                r[binary[pointer + 2]] /= binary[pointer + 1]
                pointer += 3
            case 25 : //divrr
                r[binary[pointer + 2]] /= r[binary[pointer + 1]]
                pointer += 3
            case 26 : //divmr
                r[binary[pointer + 2]] /= binary[binary[pointer + 1]]
                pointer += 3
            case 27 : //divxr
                r[binary[pointer + 2]] /= binary[r[binary[pointer + 1]]]
                pointer += 3
            case 28://jmp
                pointer = binary[pointer + 1]
            case 29://sojz
                r[binary[pointer + 1]] -= 1
                if r[binary[pointer + 1]] == 0{
                    pointer = binary[pointer + 2]
                }else{pointer += 3}
            case 30://sojnz
                r[binary[pointer + 1]] -= 1
                if r[binary[pointer + 1]] != 0{
                    pointer = binary[pointer + 2]
                }else{pointer += 3}
            case 31://aojz
                r[binary[pointer + 1]] += 1
                if r[binary[pointer + 1]] == 0{
                    pointer = binary[pointer + 2]
                }else{pointer += 3}
            case 32://aojnz
                r[binary[pointer + 1]] += 1
                if r[binary[pointer + 1]] != 0{
                    pointer = binary[pointer + 2]
                }else{pointer += 3}
            case 33://cmpir
                lastComparison = r[binary[pointer + 2]] - binary[pointer + 1]
                pointer += 3
            case 34://cmprr
                lastComparison = r[binary[pointer + 2]] - r[binary[pointer + 1]]
                pointer += 3
            case 35://cmpmr
                lastComparison = r[binary[pointer + 2]] - binary[binary[pointer + 1]]
                pointer += 3
            case 36://jmpn
                if lastComparison < 0{
                    pointer = binary[pointer + 1]
                }else{pointer += 2}
            case 37://jmpz
                if lastComparison == 0{
                    pointer = binary[pointer + 1]
                }else{pointer += 2}
            case 38://jmpp
                if lastComparison > 0{
                    pointer = binary[pointer + 1]
                }else{pointer += 2}
            case 39://jsr
                subroutinePointer = pointer + 2
                pointer = binary[pointer + 1]
                for rNum in 5...9{
                    theStack.push(element: r[rNum])
                    r[rNum] = 0
                }
            case 40://ret
                //error if no jsr b4
                for rNum in 0...4{
                    r[9 - rNum] = theStack.pop()!
                }
                pointer = subroutinePointer
            case 41://push
                theStack.push(element: r[binary[pointer + 1]])
                pointer += 2
            case 42://pop
                r[binary[pointer + 1]] = theStack.pop()!
                pointer += 2
            case 43://stackc
                //currently have it as seting condition to register specified
                if theStack.isEmpty(){
                    r[binary[pointer + 1]] = 2
                }else{
                    if theStack.isFull(){
                        r[binary[pointer + 1]] = 1
                    }else{
                        r[binary[pointer + 1]] = 0
                    }
                }
                pointer += 2
            case 44://outci
                if binary[pointer + 1] == 10{
                    output += "\n"
                }else{
                    output += "\(intToAsciiChar(binary[pointer + 1]))"
                }
                pointer += 2
            case 45://outcr
                if r[binary[pointer + 1]] == 10{
                    output += "\n"
                }else{
                    output += intToAsciiChar(r[binary[pointer + 1]])//was printing \n instead of new line
                    
                }
                pointer += 2
            case 46://outcx
                if binary[r[binary[pointer + 1]]] == 10{
                    output += "\n"
                }else{
                    output += intToAsciiChar(binary[r[binary[pointer + 1]]])
                }
                pointer += 2
            case 47://outcb
                //rn it adds all characters from mem locations r1 to r1 to output
                for i in r[binary[pointer + 1]]...r[binary[pointer + 2]] + r[binary[pointer + 1]] - 1{
                    if binary[i] == 10{
                        output += "\n"
                    }else{
                        output += intToAsciiChar(binary[i])
                    }
                }
                pointer += 3
            case 48://readi
                //what does it mean by error code?
                //do something if not int
                r[binary[pointer + 1]] = Int(getInput())!
                //r2
                pointer += 3
            case 49://printi
                output += "\(r[binary[pointer + 1]])"
                pointer += 2
            case 50://readc
                //error if not only one char
                r[binary[pointer + 1]] = charSToAsciiVal(getInput())
                pointer += 2
            case 51://readln
                let strngChars = getInput().characters
                r[binary[pointer + 2]] = strngChars.count
                var point = binary[pointer + 1]
                for c in strngChars{
                    binary[point] = charSToAsciiVal(String(c))
                    point += 1
                }
                pointer += 3
            case 52://brk
                pointer += 1
            case 53://movrx
                binary[r[binary[pointer + 2]]] = r[binary[pointer + 1]]
                pointer += 3
            case 54://movxx
                binary[r[binary[pointer + 2]]] = binary[r[binary[pointer + 1]]]
                pointer += 3
            case 55://outs
                //test--print("outs \(pointer + 3)------")
                let labelLocation = binary[pointer + 1]
                for i in labelLocation + 1...labelLocation + binary[labelLocation]{
                    output += intToAsciiChar(binary[i])
                }
                pointer += 2
            case 56://nop
                pointer += 1
            case 57://jmpne
                if lastComparison != 0{
                    pointer = binary[pointer + 1]
                }else{
                    pointer += 2
                }
            default:
                print("error-pointer = \(pointer), file \(pointer + 3)")
            }
        }
        print(output)
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
