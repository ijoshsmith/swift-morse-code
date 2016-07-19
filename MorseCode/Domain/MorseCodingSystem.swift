//
//  MorseCodingSystem.swift
//  MorseCode
//
//  Created by Joshua Smith on 7/9/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

/// Provides character-to-symbol mappings for Morse coding systems.
enum MorseCodingSystem: String {
    /// Represents the International Morse Code system.
    case InternationalMorseCode
    
    /// Associates characters with Morse code symbols.
    typealias SymbolTable = [Character: Symbol]
    
    /// Returns a lookup table used when converting characters to Morse code symbols.
    var symbolTable: SymbolTable {
        return MorseCodingSystem.loadSymbolTable(fromTextFile: rawValue)
    }
}



// MARK: - Symbol table loading

private extension MorseCodingSystem {
    static func loadSymbolTable(fromTextFile fileName: String) -> SymbolTable {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")!
        let file = try! String(contentsOfFile: path)
        let lines = file.componentsSeparatedByString("\n")
        return MorseCodingSystem.loadSymbolTable(fromLines: lines)
    }
    
    static func loadSymbolTable(fromLines lines: [String]) -> SymbolTable {
        var symbolTable = SymbolTable(minimumCapacity: lines.count)
        for line in lines {
            let parts = line.componentsSeparatedByString("\t")
            let (character, encodedMarks) = (Character(parts[0]), parts[1])
            let marks = MorseCodingSystem.createMarks(fromEncodedMarks: encodedMarks)
            symbolTable[character] = Symbol(marks: marks)
        }
        return symbolTable
    }
    
    static func createMarks(fromEncodedMarks encodedMarks: String) -> [Mark] {
        return encodedMarks.characters.map { dotOrDash in
            Mark(rawValue: String(dotOrDash))!
        }
    }
}
