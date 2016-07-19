//
//  MorseEncoder.swift
//  MorseCode
//
//  Created by Joshua Smith on 7/8/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

/// Creates a Morse encoded representation of text.
struct MorseEncoder {
    private let symbolTable: MorseCodingSystem.SymbolTable
    
    init(codingSystem: MorseCodingSystem) {
        symbolTable = codingSystem.symbolTable
    }
    
    /// Returns a Morse encoded representation of the specified text.
    /// If the text contains an unsupported character, returns `nil`.
    func encode(message message: String) -> EncodedMessage? {
        return createEncodedMessage(forMessage: message)
    }
}



// MARK: - Message encoding

private extension MorseEncoder {
    func createEncodedMessage(forMessage message: String) -> EncodedMessage? {
        let terms = extractTerms(from: message)
        let encodedTerms = encode(terms: terms)
        let isValid = terms.count == encodedTerms.count
        return isValid ? EncodedMessage(encodedTerms: encodedTerms) : nil
    }
    
    func extractTerms(from message: String) -> [String] {
        return message
            .uppercaseString
            .componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            .filter { $0.isEmpty == false } // Consecutive spaces yield empty strings.
    }
    
    func encode(terms terms: [String]) -> [EncodedTerm] {
        return terms.flatMap(encodeTerm)
    }
    
    func encodeTerm(term: String) -> EncodedTerm? {
        let characters = term.characters
        let symbols = characters.flatMap(symbolForCharacter)
        let isValid = characters.count == symbols.count
        return isValid ? EncodedTerm(symbols: symbols) : nil
    }
    
    func symbolForCharacter(character: Character) -> Symbol? {
        return symbolTable[character]
    }
}
