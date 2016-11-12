//
//  WarningUtil.swift
//  Wordly
//
//  Created by eposta developer on 11/07/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation

struct WarningUtil {
    
    static let inValidEmail = "Lütfen geçerli bir e-posta adresi giriniz."
    static let inValidPassword = "Lütfen geçerli bir şifre giriniz."
    
    static let inValidPasswordRegex = "Şifreniz yalnızca harf ve rakamlardan oluşmalıdır. Türkçe karakter kullanmayınız."
    static let unRegisteredMail = "Lütfen kayıtlı olduğunuz e-posta adresinizi giriniz."
    static let smallPassword =   "Şifreniz en az 6 karakter olmalıdır."
    static let longPassword = "Şifreniz 12 karakterden uzun olamaz"
    static let notSamePassword =   "Şifreniz eşleşmemektedir. Tekrar deneyiniz."
    static let tryAgain = "Lütfen tekrar deneyiniz!"
    static let doYouMake = "Devam etmek istiyor musunuz?"
    static let connectInternet = "Lütfen internet bağlantınızı kontrol edip tekrar deneyiniz."
    static let logOut = "Oturumu kapatmak istediğinize emin misiniz?"
    static let mobileNotificationOFF = "Mobil bildirim kapalı."
    static let updateWordList = "Kelime listesi veritabanı güncellenecektir. Lütfen bekleyiniz."
    static let updating = "Güncelleniyor.."
    static let connecting = "Bağlanıyor.."
}
