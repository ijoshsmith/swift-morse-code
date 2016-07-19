//
//  ViewController.swift
//  MorseCode
//
//  Created by Joshua Smith on 7/8/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blinkingView: UIView!
    @IBOutlet weak var encodedMessageTextView: UITextView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var transmitMessageButton: UIButton!
    
    private var morseTransmitter: MorseTransmitter!
    
    private struct BlinkingViewColors {
        static let on = UIColor.greenColor()
        static let off = UIColor.lightGrayColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        morseTransmitter = MorseTransmitter(blinkingView: blinkingView,
                                            onColor: BlinkingViewColors.on,
                                            offColor: BlinkingViewColors.off)

        blinkingView.backgroundColor = BlinkingViewColors.off
        blinkingView.layer.cornerRadius = blinkingView.frame.width / 2.0;
    }
    
    @IBAction func handleTransmitMessageButton(sender: AnyObject) {
        if let message = messageTextField.text where message.isEmpty == false {
            transmit(message)
        }
    }
    
    private func transmit(message: String) {
        let morseEncoder = MorseEncoder(codingSystem: .InternationalMorseCode)
        if let encodedMessage = morseEncoder.encode(message: message) {
            showMorseCodeTextFor(encodedMessage)
            beginTransmitting(encodedMessage)
        }
        else {
            encodedMessageTextView.text = "Unable to encode at least one character in message."
        }
    }
    
    private func showMorseCodeTextFor(encodedMessage: EncodedMessage) {
        encodedMessageTextView.text = createMorseCodeText(from: encodedMessage)
        encodedMessageTextView.font = UIFont(name: "Menlo", size: 16)
    }
    
    private func createMorseCodeText(from encodedMessage: EncodedMessage) -> String {
        let transformation = MorseTransformation(
            dot:             ".",
            dash:            "-",
            markSeparator:   "",
            symbolSeparator: " ",
            termSeparator:   "\n")
        let characters = transformation.apply(to: encodedMessage)
        return characters.joinWithSeparator("")
    }
    
    private func beginTransmitting(encodedMessage: EncodedMessage) {
        transmitMessageButton.enabled = false
        morseTransmitter.startTransmitting(encodedMessage: encodedMessage) { [weak self] in
            self?.transmitMessageButton.enabled = true
        }
    }
}
