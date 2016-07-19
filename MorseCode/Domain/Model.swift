//
//  Model.swift
//  MorseCode
//
//  Created by Joshua Smith on 7/9/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

/// Represents an entire Morse encoded message.
struct EncodedMessage { let encodedTerms: [EncodedTerm] }

/// Represents a word or number consisting of Morse code symbols.
struct EncodedTerm { let symbols: [Symbol] }

/// Represents a character encoded with Morse code marks.
struct Symbol { let marks: [Mark] }

/// Represents an individual component of a Morse code symbol.
enum Mark: String { case Dot = ".", Dash = "-" }
