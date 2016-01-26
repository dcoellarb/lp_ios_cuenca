//
//  PhonesViewModel.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/25/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import Foundation

class PhonesViewModel{
    
    var brand : String = ""
    var model : String = ""
    var imei : String = ""
    var valorAsegurado : String = ""
    var deducible : String = ""
    var valorRecibir : String = ""
    var costoMensual : String = ""
    var deviceImageName : String = ""
    
    //Intializer
    init(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let brand = defaults.objectForKey(UserDefatulsKeys.localBrand) as? String {
            self.brand = brand
        }
        if let model = defaults.objectForKey(UserDefatulsKeys.localModel) as? String {
            self.model = model
        }
        if let imei = defaults.objectForKey(UserDefatulsKeys.localImei) as? String {
            self.imei = imei
        }
        if let valorAsegurado = defaults.objectForKey(UserDefatulsKeys.localValorAsegurado) as? Double {
            if let formatedValue = Format().formatCurrency(valorAsegurado){
                self.valorAsegurado = formatedValue
            }
        }
        if let deducible = defaults.objectForKey(UserDefatulsKeys.localDeducible) as? Double {
            if let formatedValue = Format().formatCurrency(deducible){
                self.deducible = formatedValue
            }
        }
        if let valorRecibir = defaults.objectForKey(UserDefatulsKeys.localValorRecibir) as? Double {
            if let formatedValue = Format().formatCurrency(valorRecibir){
                self.valorRecibir = formatedValue
            }
        }
        if let costoMensual = defaults.objectForKey(UserDefatulsKeys.localCostoMensual) as? Double {
            if let formatedValue = Format().formatCurrency(costoMensual){
                self.costoMensual = formatedValue
            }
        }
        self.deviceImageName = DeviceModel.sharedInstance.imageName
    }
}