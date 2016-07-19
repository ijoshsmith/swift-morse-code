//
//  MorseTransformation.swift
//  MorseCode
//
//  Created by Joshua Smith on 7/10/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

/// Converts an `EncodedMessage` to an alternate representation.
struct MorseTransformation<T> {
    let dot, dash, markSeparator, symbolSeparator, termSeparator: T
    
    func apply(to encodedMessage: EncodedMessage) -> [T] {
        return encodedMessage.apply(self)
    }
}

private extension EncodedMessage {
    func apply<T>(transformation: MorseTransformation<T>) -> [T] {
        return encodedTerms
            .map { $0.apply(transformation) }
            .joinWithSeparator([transformation.termSeparator])
            .toArray()
    }
}

private extension EncodedTerm {
    func apply<T>(transformation: MorseTransformation<T>) -> [T] {
        return symbols
            .map { $0.apply(transformation) }
            .joinWithSeparator([transformation.symbolSeparator])
            .toArray()
    }
}

private extension Symbol {
    func apply<T>(transformation: MorseTransformation<T>) -> [T] {
        return marks
            .map { $0.apply(transformation) }
            .joinWithSeparator([transformation.markSeparator])
            .toArray()
    }
}

private extension Mark {
    func apply<T>(transformation: MorseTransformation<T>) -> [T] {
        return [self == .Dot ? transformation.dot : transformation.dash]
    }
}

private extension JoinSequence {
    func toArray() -> [Base.Generator.Element.Generator.Element] {
        return Array(self)
    }
}
