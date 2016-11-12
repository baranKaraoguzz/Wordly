//
//  NotificationState.swift
//  Wordly
//
//  Created by eposta developer on 06/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


enum NotificationState : Int {

case mobil_Off = 0

case mobilOn_AudioOn = 2

case mobilOn_AudioOff  = 1
}

struct NotifyChangedState {
    
private let mLogTag = "Notification state "
    
    let mobil : Bool
    let audio : Bool
    let frequency : Frequency
    
  
    init(isMobilOpen : Bool, isAudioOpen : Bool , frequency : Frequency){
        self.mobil = isMobilOpen
        self.audio = isAudioOpen
       self.frequency = frequency
      
    }
    
    func isChanged (compareTo : NotifyChangedState) -> Bool {
    
        // mobil is off , not changed
        if self.mobil == false && compareTo.mobil == false {
        debugPrint(mLogTag + "mobil = false && false, not changed.")
        return false
        }
        // mobil is on
        else if self.mobil == true && compareTo.mobil == true{
            // audio is changed
            if self.audio != compareTo.audio {
                debugPrint(mLogTag + "audio = different, is changed")
                return true
            }
            // frequency is changed
            else if self.frequency != compareTo.frequency {
                debugPrint(mLogTag + "frequency = different, is changed")
                return true
            
            }
            // neither frequency nor audio is changed.
            else {
                 debugPrint(mLogTag + "frequency & audio , not changed")
            return false
            }
            
        }
       // mobil is different
        else{
        debugPrint(mLogTag + "mobil = different, is changed")
        return true
        }
    
    }
    
    
    func getNotificationState() ->NotificationState{
        //mobil is OFF
        if mobil == false {
            debugPrint(mLogTag + "mobil is off")
            return NotificationState.mobil_Off
        }
        //mobil is ON
        else {
            if  audio == true {
            debugPrint(mLogTag + "mobil is on, audio is on")
                return NotificationState.mobilOn_AudioOn
            }
            else  {
                debugPrint(mLogTag + "mobil is on, audio is off")
                return NotificationState.mobilOn_AudioOff
            }
            
        }
        
    }
    
    
}