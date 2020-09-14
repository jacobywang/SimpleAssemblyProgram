//
//  Token.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 5/12/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation

enum TokenType{
    case Register
    case LabelDefinition
    case Label
    case ImmediateString
    case ImmediateInteger
    case ImmediateTuple
    case Instruction
    case Directive
    case BadToken
}

struct Token: CustomStringConvertible{
    let type: TokenType
    let intValue: Int?  //Register, label, immediteInt, Instruction
    let stringValue: String? //Label, Label definition, ImmediateString, Directive, BadToken
    let tupleValue: Tuple? //ImmediateTuple
    let badTokenValue: String?
    
    init(_ type: TokenType, _ valueI: Int){
        self.type = type
        intValue = valueI
        stringValue = nil
        tupleValue = nil
        badTokenValue = nil
    }
    init(_ type: TokenType, _ valueS: String){
        self.type = type
        intValue = nil
        stringValue = valueS
        tupleValue = nil
        badTokenValue = nil
    }
    init(_ type: TokenType, _ valueT: Tuple){
        self.type = type
        intValue = nil
        stringValue = nil
        tupleValue = valueT
        badTokenValue = nil
    }
    init(_ type: TokenType, _ valueS: String, _ badTVal: String){
        self.type = type
        intValue = nil
        stringValue = valueS
        tupleValue = nil
        badTokenValue = badTVal
    }
    
    
    var description: String{
        if let _ = intValue{
            return "\(type): \(intValue!)"
        }
        if let _ = stringValue{
            return "\(type): \(stringValue!)"
        }
        if let _ = tupleValue{
            return "\(type): \(tupleValue!)"
        }
        return "\(type)"
    }
}

struct Tuple: CustomStringConvertible{
    let currentState: Int
    let inputCharacter: Int
    let newState: Int
    let outputCharacter: Int
    let direction: Int
    
    init(_ cs: Int, _ ic: Int, _ ns: Int, _ oc: Int, _ dir: Int){
        currentState = cs
        inputCharacter = ic
        newState = ns
        outputCharacter = oc
        direction = dir
    }
    
    var description: String{
        return "[\(currentState), \(inputCharacter), \(newState), \(outputCharacter), \(direction)]"
    }
}

enum Instruction : Int {
    case halt
    case clrr
    case clrx
    case clrm
    case clrb
    case movir
    case movrr
    case movrm
    case movmr
    case movxr
    case movar
    case movb
    case addir
    case addrr
    case addmr
    case addxr
    case subir
    case subrr
    case submr
    case subxr
    case mulir
    case mulrr
    case mulmr
    case mulxr
    case divir
    case divrr
    case divmr
    case divxr
    case jmp
    case sojz
    case sojnz
    case aojz
    case aojnz
    case cmpir
    case cmprr
    case cmpmr
    case jmpn
    case jmpz
    case jmpp
    case jsr
    case ret
    case push
    case pop
    case stackc
    case outci
    case outcr
    case outcx
    case outcb
    case readi
    case printi
    case readc
    case readln
    case brk
    case movrx
    case movxx
    case outs
    case nop
    case jmpne

}
enum Directives{
    case start
    case end
    case integer
    case allocate
    case string
}













