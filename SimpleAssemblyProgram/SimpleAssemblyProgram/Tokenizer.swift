//
//  Tokenizer.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 5/1/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation

class Tokenizer{
    var programChunks = [[String]]()
    var symbolTable: [String: Int] = [:]
    var hasBadToken = false
    
    init(_ ch: Chunker){
        programChunks = ch.chunks
    }
    
    var instructionTable = ["halt": "", "clrr": "r", "clrx": "r", "clrm": "l", "clrb": "rr", "movir": "ir", "movrr": "rr", "movrm": "rl", "movmr": "lr", "movxr": "rr", "movar": "lr", "movb": "rrr", "addir": "ir", "addrr": "rr", "addmr": "lr", "addxr": "rr", "subir": "ir", "subrr": "rr", "submr": "lr", "subxr": "rr", "mulir": "ir", "mulrr": "rr", "mulmr": "lr", "mulxr": "rr", "divir": "ir", "divrr": "rr", "divmr": "lr", "divxr": "rr", "jmp": "l", "sojz": "rl", "sojnz": "rl", "aojz": "rl", "aojnz": "rl", "cmpir": "ir", "cmprr": "rr", "cmpmr": "lr", "jmpn": "l", "jmpz": "l", "jmpp": "l", "jsr": "l", "ret": "", "push": "r", "pop": "r", "stackc": "r", "outci": "i", "outcr": "r", "outcx": "r", "outcb": "rr", "readi": "rr", "printi": "r", "readc": "r", "readln": "lr", "brk": "", "movrx": "rr", "movxx": "rr", "outs": "l", "nop": "", "jmpne": "l"]
    var directiveTable = [".start": "l", ".end": "", ".integer": "i", ".allocate": "i", ".string": "s", ".tuple": "t", ".Start": "l", ".End": "", ".Integer": "i", ".Allocate": "i", ".String": "s", ".Tuple": "t"]

    
    func makeTokens()->[[Token]]{
        var tokens: [[Token]] = []
        
        for chunkLine in programChunks{//iterates through lines
            var lineOfTokens: [Token] = []
            
            var addedIntTok = false
            var addedRegTok = false
            var addedLDTok = false
            var addedStrTok = false
            var addedTupTok = false
            
            for var index in 0...chunkLine.count - 1{//iterates through the chunks in the current line
                let chunk = chunkLine[index]
                var chkChar = Array(chunk)
                if chkChar[chunk.count - 1] == ":"{
                    //label
                    lineOfTokens.append(Token(.Label, "\(chunk)"))
                }else {
                    if let _ = self.instructionTable[chunk]{
                        //instruction-check for components
                        switch instructionTable[chunk]!{
                        case "r":
                            if index + 2 == chunkLine.count{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                                if let r = checkReg(chunkLine[index + 1]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be a register.", chunkLine[index + 1]))
                                }
                                addedRegTok = true
                            }else{
                                lineOfTokens.append(Token(.BadToken, "There should only be 1 item after the instruction.", chunk))
                            }
                        case "rr":
                            if index + 3 == chunkLine.count{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                                if let r = checkReg(chunkLine[index + 1]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be a register.", chunkLine[index + 1]))
                                }
                                if let r = checkReg(chunkLine[index + 2]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 2]) - should be a register.", chunkLine[index + 2]))
                                }
                                addedRegTok = true
                            }else{
                                lineOfTokens.append(Token(.BadToken, "There should only be 2 registers after the instruction.", chunk))
                            }
                        case "rrr":
                            if index + 4 == chunkLine.count{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                                if let r = checkReg(chunkLine[index + 1]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be a register.", chunkLine[index + 1]))
                                }
                                if let r = checkReg(chunkLine[index + 2]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 2]) - should be a register.", chunkLine[index + 2]))
                                }
                                if let r = checkReg(chunkLine[index + 3]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 3]) - should be a register.", chunkLine[index + 3]))
                                }
                                addedRegTok = true
                            }else{
                                lineOfTokens.append(Token(.BadToken, "There should only be 3 registers after the instruction.", chunk))
                            }
                        case "l":
                            if index + 2 == chunkLine.count{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                                if let _ = checkReg(chunkLine[index + 1]){
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - shouldn't be a register.", chunkLine[index + 1]))
                                }else{
                                    lineOfTokens.append(Token(.LabelDefinition, "\(chunkLine[index + 1])"))
                                }
                                addedLDTok = true
                            }else{
                                lineOfTokens.append(Token(.BadToken, "There should only be 1 label after the instruction.", chunk))
                            }
                        case "lr":
                            if index + 3 == chunkLine.count{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                                if let _ = checkReg(chunkLine[index + 1]){
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - shouldn't be a register.", chunkLine[index + 1]))
                                }else{
                                    lineOfTokens.append(Token(.LabelDefinition, "\(chunkLine[index + 1])"))
                                }
                                if let r = checkReg(chunkLine[index + 2]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 2]) - should be a register.", chunkLine[index + 2]))
                                }
                                addedRegTok = true
                                addedLDTok = true
                            }else{
                                lineOfTokens.append(Token(.BadToken, "There should only be 1 label and 1 register after the instruction.", chunk))
                            }
                        case "rl":
                        if index + 3 == chunkLine.count{
                            lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                            if let r = checkReg(chunkLine[index + 1]){
                                lineOfTokens.append(r)
                            }else{
                                lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be a register.", chunkLine[index + 1]))
                            }
                            if let _ = checkReg(chunkLine[index + 2]){
                                lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 2]) - shouldn't be a register.", chunkLine[index + 2]))
                            }else{
                                lineOfTokens.append(Token(.LabelDefinition, "\(chunkLine[index + 2])"))
                            }
                            addedRegTok = true
                            addedLDTok = true
                        }else{
                            lineOfTokens.append(Token(.BadToken, "There should only be 1 label after the instruction.", chunk))
                            }
                        case "i":
                            if index + 2 == chunkLine.count{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                                if let i = checkInt(chunkLine[index + 1]){
                                    lineOfTokens.append(i)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be an Int(with #).", chunkLine[index + 1]))
                                }
                                addedIntTok = true
                            }else{
                                lineOfTokens.append(Token(.BadToken, "There should only be 1 Int after the instruction.", chunk))
                            }
                        case "ir":
                            if index + 3 == chunkLine.count{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunkLine[index])))
                                if let i = checkInt(chunkLine[index + 1]){
                                    lineOfTokens.append(i)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be an Int(with #).", chunkLine[index + 1]))
                                }
                                if let r = checkReg(chunkLine[index + 2]){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 2]) - should be a register.", chunkLine[index + 2]))
                                }
                                addedRegTok = true
                                addedIntTok = true
                            }else{
                                lineOfTokens.append(Token(.BadToken, "There should only be 1 Int after the instruction.", chunk))
                            }
                        default:// when it is ""
                            if index == chunkLine.count - 1{
                                lineOfTokens.append(Token(.Instruction, instructionValue(chunk)))
                            }else{
                                lineOfTokens.append(Token(.BadToken, "Instruction '\(chunk)' should not have anything after it.", chunk))
                            }
                        }
                    }else{
                        let firstChar = chkChar[0]
                        switch firstChar{
                        case "."://directive - check components--LIKE ABOVE
                            switch directiveTable[chunk]{
                            case ""?:
                                if index == chunkLine.count - 1{
                                    lineOfTokens.append(Token(.Directive, chunk))
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "Directive '\(chunk)' should not have anything after it.", chunk))
                                }
                            case "i"?:
                                if index + 2 == chunkLine.count{
                                    lineOfTokens.append(Token(.Directive, "\(chunkLine[index])"))
                                    if let i = checkInt(chunkLine[index + 1]){
                                        lineOfTokens.append(i)
                                    }else{
                                        lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be an Int(with #).", chunkLine[index + 1]))
                                    }
                                    addedIntTok = true
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "There should only be 1 Int after the directive - \(chunkLine[index]).", chunk))
                                }
                            case "l"?:
                                if index + 2 == chunkLine.count{
                                    lineOfTokens.append(Token(.Directive, "\(chunkLine[index])"))
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "There should only be 1 Label after the directive - \(chunkLine[index]).", chunk))
                                }
                            case "s"?:
                                if index + 2 == chunkLine.count{
                                    lineOfTokens.append(Token(.Directive, "\(chunkLine[index])"))
                                    if let s = checkString(chunkLine[index + 1]){
                                        lineOfTokens.append(s)
                                    }else{
                                        lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be an String.", chunkLine[index + 1]))
                                    }
                                    addedStrTok = true
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "There should only be 1 String after the directive - \(chunkLine[index]).", chunk))
                                }
                            case "t"?:
                                if index + 2 == chunkLine.count{
                                    lineOfTokens.append(Token(.Directive, "\(chunkLine[index])"))
                                    if let s = checkTup(chunkLine[index + 1]){
                                        lineOfTokens.append(s)
                                    }else{
                                        lineOfTokens.append(Token(.BadToken, "\(chunkLine[index + 1]) - should be an Tuple.", chunkLine[index + 1]))
                                    }
                                    addedTupTok = true
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "There should only be 1 Tuple after the directive - \(chunkLine[index]).", chunk))
                                }
                            default:
                                lineOfTokens.append(Token(.BadToken, "Cannot recognize directive - \(chunk)", chunk))
                            }
                            
                        case "#"://immediateInt - check that after # is int
                            if !addedIntTok{
                                if let i = checkInt(chunkLine[index]){
                                    lineOfTokens.append(i)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index]) - should be an Int(with #).", chunk))
                                }
                            }
                        case "\""://immediateString
                            if !addedStrTok{
                                if let s = checkString(chunkLine[index]){
                                    lineOfTokens.append(s)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index]) - should be an String.", chunk))
                                }
                            }
                        case "\\"://tuple - check that states are ints and direction is l or r
                            if !addedTupTok{
                                if let t = checkTup(chunk){
                                    lineOfTokens.append(t)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index]) - Invalid Tuple.", chunk))
                                }
                            }
                        case "r"://register
                            if !addedRegTok{
                                if let r = checkReg(chunk){
                                    lineOfTokens.append(r)
                                }else{
                                    lineOfTokens.append(Token(.BadToken, "\(chunkLine[index]) - Invalid register.", chunk))
                                }
                            }
                        default:
                            //label directive----MUST CHECK IN ASSEMBLER THAT IT MATCHES A LABEL
                            if !addedLDTok{
                                lineOfTokens.append(Token(.LabelDefinition, chunk))
                            }
                        }
                    }
                }
            }
            
            tokens.append(lineOfTokens)
        }
        return tokens
    }
    
    func makeStingNoFirst(_ s: String)->String{
        var char = Array(s)
        char.remove(at: 0)
        return String(char)
    }
    
    func instructionValue(_ instruction: String)->Int{
        let instructions = ["halt": 0, "clrr": 1, "clrx": 2, "clrm": 3, "clrb": 4, "movir": 5, "movrr": 6, "movrm": 7, "movmr": 8, "movxr": 9, "movar": 10, "movb": 11, "addir": 12, "addrr": 13, "addmr": 14, "addxr": 15, "subir": 16, "subrr": 17, "submr": 18, "subxr": 19, "mulir": 20, "mulrr": 21, "mulmr": 22, "mulxr": 23, "divir": 24, "divrr": 25, "divmr": 26, "divxr": 27, "jmp": 28, "sojz": 29, "sojnz": 30, "aojz": 31, "aojnz": 32, "cmpir": 33, "cmprr": 34, "cmpmr": 35, "jmpn": 36, "jmpz": 37, "jmpp": 38, "jsr": 39, "ret": 40, "push": 41, "pop": 42, "stackc": 43, "outci": 44, "outcr": 45, "outcx": 46, "outcb": 47, "readi": 48, "printi": 49, "readc": 50, "readln": 51, "brk": 52, "movrx": 53, "movxx": 54, "outs": 55, "nop": 56, "jmpne": 57]
        return instructions[instruction]!
    }
    
    func checkInt(_ s: String)->Token?{
        var chars = Array(s)
        if chars[0] == "#"{
            chars.remove(at: 0)
            if let num: Int = Int(String(chars)){
                return Token(.ImmediateInteger, num)
            }
        }
        return nil
    }
    func checkString(_ s: String)->Token?{
        var chars = Array(s)
        if chars[0] == "\"" && chars[chars.count - 1] == "\""{
            var noQuotes = ""
            for c in 0...chars.count - 1{
                if c != 0 && c != chars.count - 1{
                    noQuotes += "\(chars[c])"
                }
            }
            return Token(.ImmediateString, noQuotes)
        }
        return nil
    }
    func checkTup(_ s: String)->Token?{
        var chars = Array(s)
        if chars[0] == "\\" && chars[chars.count - 1] == "\\" && chars.count == 7{
            if chars[5] == "r" || chars[5] == "l"{
                if let _: Int = Int(String(chars[1])){
                    if let _: Int = Int(String(chars[3])){
                        if chars[5] == "r"{
                            return Token(.ImmediateTuple, Tuple(Int(String(chars[1]))!, charSToAsciiVal(String(chars[2])), Int(String(chars[3]))!, charSToAsciiVal(String(chars[4])), 1))
                        }else{
                            return Token(.ImmediateTuple, Tuple(Int(String(chars[1]))!, charSToAsciiVal(String(chars[2])), Int(String(chars[3]))!, charSToAsciiVal(String(chars[4])), -1))
                        }
                    }
                }
            }
        }
        return nil
    }
    func checkReg(_ s: String)->Token?{
        var chars = Array(s)
        if chars[0] == "r"{
            chars.remove(at: 0)
            if let num: Int = Int(String(chars)){
                if num < 10{
                    return Token(.Register, num)
                }
            }
        }
        return nil
    }
    func checkLab(_ s: String)->Token?{
        var chars = Array(s)
        if chars[0] != "r" && chars[0] != "#"{
            return Token(.LabelDefinition, s)
        }
        return nil
    }
}








