//
//  Stack.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 4/18/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation

struct Stack<Element> : CustomStringConvertible{
    var size = Int()
    var pointer = 0
    var stack = [Element?]()
    
    init(size: Int){
        self.size = size
        for _ in 1...size{
            stack.append(nil)
        }
    }
    
    init(stack: [Element?]){
        self.stack = stack
        self.size = stack.count
    }
    
    func isEmpty()->Bool{
        if(pointer == 0){return true}
        else{return false}
        
    }
    
    func isFull()->Bool{
        if(pointer == size){return true}
        else{return false}
    }
    
    mutating func push(element: Element){
        if(isFull() != true){
            stack[pointer] = element
            pointer += 1
        }
    }
    
    mutating func pop()->Element?{
        if(isEmpty() != true){
            let hold = stack[pointer - 1]!
            stack[pointer - 1] = nil
            pointer -= 1
            return hold
        }
        else{return nil}
    }
    
    func map<T>(_ element: (Element) -> T) -> Stack<T>{
        var mappedItems = [T?]()
        for item in stack{
            if item != nil{mappedItems.append(element(item!))}
            else{mappedItems.append(nil)}
        }
        return Stack<T>(stack: mappedItems)
    }
    
    var description: String{
        var string = "Stack: ["
        
        for element in stack{
            if(element != nil){string += " \(element!) "}
            else{string += " - "}
        }
        string += "]"
        return string
    }
}
