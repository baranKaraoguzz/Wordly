//
//  RegisterResponse.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

/*
"result": "OK",
"message": "Lütfen hesabınızı aktif edin" / {"Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz."},
"error": "null/true",
"userId": "12131021051-1/",
"databaseVersion":"5",
"isUpdated":"true/false",
"forcedToUpdate":"false"

*/


struct RegisterResponse {

    var result : String = ""
    var message : String = ""
    var error : String = ""
    var userId : String = ""
    var databaseVersion : String = ""
    var isUpdated : String = ""
    var forcedToUpdate : String = ""

    
}