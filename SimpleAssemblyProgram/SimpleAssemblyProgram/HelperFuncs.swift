//
//  HelperFuncs.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 4/5/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation

func splitStringintoParts(expression: String)->[String]{
    return expression.split{$0 == " "}.map{ String($0) }
}

func splitStringintoLines(expression: String)->[String]{
    return expression.split{$0 == "\n"}.map{ String($0) }
}

func readTextFile(_ path: String)->(message: String?, fileText: String?){
    let text: String
    do {
        text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
    catch {
        return ("\(error)", nil)
    }
    
    return (nil, text)
}

func fit(_ s: String, _ size: Int, right: Bool = true)-> String{
    var result = ""
    let sSize = s.count
    if sSize == size {return s }
    var count = 0
    if size < sSize {
        for c in s {
            if count < size {result.append(c)}
            count += 1
        }
        return result
    }
    
    result = s
    var addon = ""
    let num = size - sSize
    for _ in 0..<num {addon.append(" ")}
    if right {return result + addon}
    return addon + result
}


func removeSpace(_ textList: [String])->[String]{
    var array = textList
    for i in 0...array.count-1{
        if array[i] == " "{
            array.remove(at: i)
        }
    }
    return array
}


func intToAsciiChar(_ i: Int)->String{
    return UnicodeScalar(i)!.escaped(asASCII: true)
}

func charSToAsciiVal(_ c: String)->Int{
    let uInt = c.unicodeScalars.filter{$0.isASCII}.first?.value
    return Int(uInt!)
}

func findInstruction(_ num: Int)->String{
    switch num{
    case 0: return "halt"
    case 1: return "clrr"
    case 2: return "clrx"
    case 3: return "clrm"
    case 4: return "clrb"
    case 5: return "movir"
    case 6: return "movrr"
    case 7: return "movrm"
    case 8: return "movmr"
    case 9: return "movxr"
    case 10: return "movar"
    case 11: return "movb"
    case 12: return "addir"
    case 13: return "addrr"
    case 14: return "addmr"
    case 15: return "addxr"
    case 16: return "subir"
    case 17: return "subrr"
    case 18: return "submr"
    case 19: return "subxr"
    case 20: return "mulir"
    case 21: return "mulrr"
    case 22: return "mulmr"
    case 23: return "mulxr"
    case 24: return "divir"
    case 25: return "divrr"
    case 26: return "divmr"
    case 27: return "divxr"
    case 28: return "jmp"
    case 29: return "sojz"
    case 30: return "sojnz"
    case 31: return "aojz"
    case 32: return "aojnz"
    case 33: return "cmpir"
    case 34: return "cmprr"
    case 35: return "cmpmr"
    case 36: return "jmpn"
    case 37: return "jmpz"
    case 38: return "jmpp"
    case 39: return "jsr"
    case 40: return "ret"
    case 41: return "push"
    case 42: return "pop"
    case 43: return "stackc"
    case 44: return "outci"
    case 45: return "outcr"
    case 46: return "outcx"
    case 47: return "outcb"
    case 48: return "readi"
    case 49: return "printi"
    case 50: return "readc"
    case 51: return "readln"
    case 52: return "brk"
    case 53: return "movrx"
    case 54: return "movxx"
    case 55: return "outs"
    case 56: return "nop"
    case 57: return "jmpne"
    default:
        break
    }
    return ""
}














