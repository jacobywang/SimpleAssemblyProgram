//
//  Assembler.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 5/12/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation

class Assembler{
    var turingString = ""
    var chunks: [[String]] = []
    var tokens = [[Token]]()
    
    var lineLocationTable: [Int] = []
    var symbolTable: [String : Int] = [:]
    var length = 0
    var startingLabel = ""
    var binary = ""
    var hasBadToken = false
   
    
    init(_ turingPath: String){
        if let text = readTextFile(turingPath).1{
            turingString = text
            let c = Chunker(path: turingPath)
            chunks = c.chunks
            
            tokens = Tokenizer(c).makeTokens()
            makeBinary()
        }else{
            print("Can't find a textfile.")
        }
    }
    
    func runTuring(){
        let vm = VirtualMachine2()
        if binary != ""{
            vm.symbols = symbolTable
            vm.runProgram(binary)
        }
    }
    
    func printBinary(){
        print("Binary")
        print(binary)
    }
    
    func printTokens(){
        print("TOKENS")
        for i in tokens{
            print(i)
        }
    }
    
    func printSymbolTable(){
        print("SYMBOL TABEL")
        for i in symbolTable{
            print("\(fit(i.0, 16))\(i.1)")
        }
        print("")
    }
    
    func lineIsComent(_ num: Int)->Bool{
        let turingLines = splitStringintoLines(expression: turingString)
        let lineParts = splitStringintoParts(expression: turingLines[num])
        if lineParts.count > 0{
            if Array(lineParts[0])[0] == ";"{
                return true
            }
        }
        return false
    }
    func firstValues(_ num: Int, _ binLineLoc: Int)->String{
        var s = ""
        let binArray = splitStringintoLines(expression: binary)
        if tokens[num].count > 0{
            if tokens[num].count - 1 >= 4{
                
            }else{
                let numVals = howManyVals(num)
                if numVals > 0{
                    for i in 0...numVals - 1{
                        s += "\(binArray[binLineLoc + i]) "
                    }
                }
            }
        }
        return s
    }
    
    func howManyVals(_ num: Int)->Int{
        let lineParts = tokens[num]
        var count = 0
        
        for i in lineParts{
            if i.type != .Label && i.type != .Directive && i.type != .BadToken{
                count += 1
                if i.type == .ImmediateTuple{
                    count = 5
                }
                if i.type == .ImmediateString{
                    count += Array(i.stringValue!).count
                }
            }
        }
        if count >= 4{
            return 4
        }else{
            return count
        }
    }
    
    func printList(){
        print("LIST")
        if !hasBadToken{
            //DO THE LIST WITH # STARTING AND BINARY #'s AT BEGINING OF EACH LINE
            let turingLines = splitStringintoLines(expression: turingString)
            var tokenLineCount = 0
            var lineStartVals = lineLocationTable
            for i in 0...turingLines.count - 1{
                if lineIsComent(i){
                    print("\(fit("", 20)) \(turingLines[i])")
                }else{
                    if lineStartVals.count > 0{
                        let binaryLocation = lineStartVals.remove(at: 0)
                        print("\(fit("\(binaryLocation): \(firstValues(tokenLineCount, binaryLocation + 2))", 20)) \(turingLines[i])")
                        tokenLineCount += 1
                    }
                }
            }
        }else{
            for line in tokens{
                var linePrint = ""
                var hasBad = false
                var errorMess = ""
                for index in 0...line.count - 1{
                    let tok = line[index]
                    switch tok.type{
                    case .Register:
                        linePrint += "r\(tok.intValue!) "
                    case .LabelDefinition:
                        linePrint += "\(tok.stringValue!) "
                    case .Label:
                        linePrint += "\(tok.stringValue!) "
                    case .ImmediateString:
                        linePrint += "\"\(tok.stringValue!)\" "
                    case .ImmediateInteger:
                        linePrint += "#\(tok.intValue!) "
                    case .ImmediateTuple:
                        let t = tok.tupleValue!
                        linePrint += "\\\(t.currentState), "
                        linePrint += "\(intToAsciiChar(t.inputCharacter)), "
                        linePrint += "\(t.newState), "
                        linePrint += "\(intToAsciiChar(t.outputCharacter)), "
                        if t.direction == 1{
                            linePrint += "r\\ "
                        }else{linePrint += "l\\ "}
                    case .Instruction:
                        linePrint += "\(findInstruction(tok.intValue!)) "
                    case .Directive:
                        linePrint += "\(tok.stringValue!) "
                    case .BadToken:
                        hasBad = true
                        linePrint += "\(tok.badTokenValue!) "
                        errorMess = tok.stringValue!
                    default:
                        break
                    }
                }
                print(linePrint)
                if !hasBad{
                    print("–––––––––––––––––\(errorMess)––––––––––––––––––––")
                }
            }
        }
    }
    
    func makeBinary(){
        firstPass()
        
        //second pass--make binary
        if !hasBadToken{
            binary += "\(length)\n\(symbolTable["\(startingLabel):"]!)\n"
            for line in tokens{
                //MAKE STRING OF WHERE EACH LINE BEGINS AND THE FIRST 4 BINARY VALUES
                for index in 0...line.count - 1{
                    let tok = line[index]
                    
                    switch tok.type{
                    case .Instruction:
                        binary += "\(tok.intValue!)\n"
                    case .ImmediateInteger:
                        let prev = line[index - 1]
                        if prev.type == .Directive && prev.stringValue! == ".allocate"{
                            for _ in 0...tok.intValue! - 1{
                                binary += "0\n"
                            }
                        }else{
                            binary += "\(tok.intValue!)\n"
                        }
                    case .ImmediateString:
                        let chars = Array(tok.stringValue!)
                        binary += "\(chars.count)\n"
                        for c in chars{
                            binary += "\(charSToAsciiVal(String(c)))\n"
                        }
                    case .ImmediateTuple:
                        binary += "\(tok.tupleValue!.currentState)\n"
                        binary += "\(tok.tupleValue!.inputCharacter)\n"
                        binary += "\(tok.tupleValue!.newState)\n"
                        binary += "\(tok.tupleValue!.outputCharacter)\n"
                        binary += "\(tok.tupleValue!.direction)\n"
                    case .LabelDefinition:
                        let prev = line[index - 1]
                        if prev.type != .Directive || prev.stringValue! != ".start"{
                            binary += "\(symbolTable["\(tok.stringValue!):"]!)\n"
                        }
                    case .Register:
                        binary += "\(tok.intValue!)\n"
                    default:
                        break//.Directive, .Label
                    }
                }
            }
        }
    }
    //PROBLEM ADDING COUNT AND COUNT FOR SYMBOL TABLE 1 TOO LOW
    func firstPass(){//--symbol table, check errors/bad tokens
        var count = 0
        
        for var ln in 0...tokens.count - 1{
            var line = tokens[ln]
            lineLocationTable.append(count)
            for index in 0...line.count - 1{
                let tok = line[index]
                
                if tok.type == .BadToken{
                    hasBadToken = true
                }
                if tok.type == .Directive && tok.stringValue == ".start"{
                    let next = line[index + 1]
                    startingLabel = next.stringValue!
                }
                
                if tok.type == .Label{
                   symbolTable[tok.stringValue!] = count
                }
                if tok.type == .ImmediateString || tok.type == .ImmediateTuple{
                    if tok.type == .ImmediateString{
                        count += tok.stringValue!.count + 1
                    }else{
                        count += 5
                    }
                }else if tok.type == .Directive && tok.stringValue == ".allocate" && line[index + 1].type == .ImmediateString{
                    count += line[index + 1].intValue!
                }else{
                    if tok.type != .Directive && tok.type != .Label{
                        if index > 0{
                            let prev = line[index - 1]
                            if tok.type == .LabelDefinition && prev.type == .Directive && prev.stringValue! == ".start"{
                                
                            }else{count += 1}
                        }else{count += 1}
                    }
                }
                
                if tok.type == .LabelDefinition{
                    var exists = false
                    for l in tokens{
                        for t in l{
                            if t.type == .Label{
                                var tArray = Array(t.stringValue!)
                                tArray.remove(at: tArray.count - 1)
                                if String(tArray) == tok.stringValue{
                                    exists = true
                                }
                            }
                        }
                    }
                    if !exists{
                        tokens[ln][index] = Token(.BadToken, "\(tok.stringValue!) does not match any Label.")
                        hasBadToken = true
                    }
                }
                
            }
        }
        length = count
    }
}











