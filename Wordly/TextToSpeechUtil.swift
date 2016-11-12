//
//  TextToSpeechUtil.swift
//  Wordly
//
//  Created by eposta developer on 21/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import AVFoundation

struct TextToSpeech {
    
    static let sharedInstance = TextToSpeech()
    
    
    private init (){
        
    }
    
    func setTextToSpeech(word : String) {
        
        dispatch_async(dispatch_get_main_queue()) {
            let utterance = AVSpeechUtterance(string: word)
            utterance.voice = AVSpeechSynthesisVoice(language: "en")
            // utterance.rate = 1
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
            
        }
    }
    
    
    
}