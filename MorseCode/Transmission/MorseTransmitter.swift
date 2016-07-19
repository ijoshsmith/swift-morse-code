//
//  MorseTransmitter.swift
//  MorseCode
//
//  Created by Joshua Smith on 7/11/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

/// Causes a view to flash and a beeping noise to be produced for every mark in an encoded message.
final class MorseTransmitter {
    private unowned let blinkingView: UIView
    private let offColor: UIColor
    private let onColor: UIColor
    init(blinkingView: UIView, onColor: UIColor, offColor: UIColor) {
        self.blinkingView = blinkingView
        self.onColor = onColor
        self.offColor = offColor
    }
    
    typealias CompletionHandler = () -> Void
    private var completionHandler: CompletionHandler?
    private var transmissionStateStack: [TransmissionState]?
    
    func startTransmitting(encodedMessage encodedMessage: EncodedMessage, completionHandler: CompletionHandler) {
        precondition(transmissionStateStack == nil)
        
        self.completionHandler = completionHandler
        
        let transmissionStates = TransmissionState.createStates(from: encodedMessage)
        transmissionStateStack = transmissionStates.reverse()
        transmitNextState()
    }
}

private extension MorseTransmitter {
    func transmitNextState() {
        if let currentState = transmissionStateStack?.popLast() {
            transmit(currentState)
            scheduleTransmission(after: currentState)
        }
        else {
            stopTransmitting()
        }
    }
    
    func transmit(state: TransmissionState) {
        if state.isOn { turnOn() } else { turnOff() }
    }
    
    func turnOn() {
        blinkingView.backgroundColor = onColor
        FMSynthesizer.sharedSynth().play(3000.0, modulatorFrequency: 2000.0, modulatorAmplitude: 1.0)
    }
    
    func turnOff() {
        blinkingView.backgroundColor = offColor
        FMSynthesizer.sharedSynth().stop()
    }
    
    func scheduleTransmission(after state: TransmissionState) {
        let transmissionUnit = 0.092
        let baseDuration = transmissionUnit * Double(NSEC_PER_SEC)
        let duration = baseDuration * Double(state.relativeDuration)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(duration))
        dispatch_after(delayTime, dispatch_get_main_queue(), transmitNextState)
    }
    
    func stopTransmitting() {
        turnOff()
        completionHandler!()
        completionHandler = nil
        transmissionStateStack = nil
    }
}

private enum TransmissionState {
    typealias RelativeDuration = Int
    case On(RelativeDuration)
    case Off(RelativeDuration)
    
    static func createStates(from encodedMessage: EncodedMessage) -> [TransmissionState] {
        let transformation = MorseTransformation(
            dot:             TransmissionState.On(1),
            dash:            TransmissionState.On(3),
            markSeparator:   TransmissionState.Off(1),
            symbolSeparator: TransmissionState.Off(3),
            termSeparator:   TransmissionState.Off(7))
        return transformation.apply(to: encodedMessage)
    }
    
    var relativeDuration: Int {
        switch self {
        case let .On(relativeDuration):  return relativeDuration
        case let .Off(relativeDuration): return relativeDuration
        }
    }
    
    var isOn: Bool {
        switch self {
        case .On:  return true
        case .Off: return false
        }
    }
}
