//
//  SettingDelegate.swift
//  Wordly
//
//  Created by eposta developer on 02/08/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER

protocol SettingDelegate : class {

    func getChangeNotificationFrequencyModel(model : CommonModelResponse)
    func getChangeEmailModel(model : CommonVersionModelResponse)
    func getChangeMailNotificationModel(model : CommonVersionModelResponse)
    func getChangeMobileNotificationModel(model : CommonModelResponse)
    func getChangeAudioNotificationModel(model : CommonModelResponse)
    func getChangeLevelNotifictionModel(model : CommonVersionModelResponse)

}