//
//  RegisterDelegate.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

/*
"result": "OK",
"message": "Lütfen hesabınızı aktif edin" / {"Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz."},
"error": "null/true",
"userId": "12131021051-1/",
"databaseVersion":"5",
"isUpdated":"true/false",
"forcedToUpdate":"false"

*/

import Foundation


//TAKE DATA FROM SERVICE , SENDS DATA TO CONTROLLER
protocol RegisterDelegate : class {
    
   func getRegisterResponseModel (model : RegisterResponse)
    
}