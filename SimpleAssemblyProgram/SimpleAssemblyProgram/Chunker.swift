//
//  Chunker.swift
//  SimpleAssemblyProgram
//
//  Created by Jacob Wang on 5/1/18.
//  Copyright © 2018 Jacob Wang. All rights reserved.
//

import Foundation

class Chunker{
    var programString = String()
    var chunks: [[String]] = []
    
    init(path: String){
        programString = readTextFile(path).1!
        chunkify()
    }
    
    
    func chunkify(){
        var newChunks: [[String]] = []
        let lines = splitStringintoLines(expression: programString)
        for l in lines{
            chunks.append(splitStringintoParts(expression: l))
        }
        
        for var line in chunks{
            var continuousString = false
            var condenseString = ""
            var tupleString = ""
            var lineArray: [String] = []
            
            if line.count > 0{
            for index in 0...line.count - 1{
                var part = Array(line[index])
                if part[0] == ";"{//if its a comment--comments aren't added to chunks
                    break
                }else{
                    if continuousString == true{//if making a string currently
                        if part[part.count - 1] == "\""{
                            continuousString = false
                            condenseString += line[index]
                        }else{
                            condenseString += "\(line[index]) "
                        }
                    }else{//not making a string currently
                        if part[0] == "\""{//if need to make a string now
                            if part[part.count - 1] == "\""{
                                condenseString += line[index]
                            }else{
                                continuousString = true
                                condenseString += "\(line[index]) "
                            }
                        }else if line.count > index + 4{
                            var lastInTup = Array(line[index + 4])
                            if part[0] == "\\" && lastInTup[lastInTup.count - 1] == "\\"{//if it is a tuple
                                for i in 0...4{
                                    tupleString += line[index + i]
                                }
                                lineArray.append(tupleString)
                                break
                            }else{
                                lineArray.append(line[index])
                            }
                        }else{
                            lineArray.append(line[index])
                        }
                    }
                }
                }
            }
            
            if condenseString != ""{
                lineArray.append(condenseString)
            }
            if lineArray != []{
                newChunks.append(lineArray)
            }
        }
        chunks = newChunks
    }
}

