//
//  PhonesViewController.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/25/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import UIKit

class PhonesViewController: UIViewController {

    var viewModel: PhonesViewModel
    
    //UI Controls
    var phoneInfoContainer : UIView! {
        didSet {
            self.phoneInfoContainer.backgroundColor = Colors.lightergray
        }
    }
    var imgPhoto : UIImageView! {
        didSet{
            self.imgPhoto.image = UIImage(named: self.viewModel.deviceImageName)
        }
    }
    var lblMarca : UILabel! {
        didSet {
            self.lblMarca.text = "Marca"
            self.lblMarca.font = Font.lightFontWithSize(12)
        }
    }
    var txtMarca : UILabel! {
        didSet {
            self.txtMarca.text = "Apple"
            self.txtMarca.font = Font.regularFontWithSize(18)
            self.txtMarca.text = self.viewModel.brand
        }
    }
    var lblModelo : UILabel! {
        didSet {
            self.lblModelo.text = "Modelo"
            self.lblModelo.font = Font.lightFontWithSize(12)
        }
    }
    var txtModelo : UILabel! {
        didSet {
            self.txtModelo.font = Font.regularFontWithSize(18)
            self.txtModelo.text = self.viewModel.model
        }
    }
    var lblImei : UILabel! {
        didSet {
            self.lblImei.text = "IMEI"
            self.lblImei.font = Font.regularFontWithSize(18)
            self.lblImei.font = Font.lightFontWithSize(12)
        }
    }
    var txtImei : UILabel! {
        didSet {
            self.txtImei.font = Font.regularFontWithSize(18)
            self.txtImei.minimumScaleFactor = 0.5
            self.txtImei.adjustsFontSizeToFitWidth = true
            self.txtImei.text = self.viewModel.imei
        }
    }
    var lblValorAsegurado : UILabel! {
        didSet {
            self.lblValorAsegurado.text = "Valor Asegurado"
            self.lblValorAsegurado.font = Font.lightFontWithSize(14)
        }
    }
    var txtValorAsegurado : UILabel! {
        didSet {
            self.txtValorAsegurado.font = Font.regularFontWithSize(18)
            self.txtValorAsegurado.text = self.viewModel.valorAsegurado
        }
    }
    var lblDeducible : UILabel! {
        didSet {
            self.lblDeducible.text = "Deducible/Depreciacion"
            self.lblDeducible.font = Font.lightFontWithSize(14)
        }
    }
    var txtDeducible : UILabel! {
        didSet {
            self.txtDeducible.font = Font.regularFontWithSize(18)
            self.txtDeducible.text = self.viewModel.deducible
        }
    }
    var lblValorRecibir : UILabel! {
        didSet {
            self.lblValorRecibir.text = "Valor a recibir"
            self.lblValorRecibir.font = Font.lightFontWithSize(14)
        }
    }
    var txtValorRecibir : UILabel! {
        didSet {
            self.txtValorRecibir.font = Font.regularFontWithSize(18)
            self.txtValorRecibir.text = self.viewModel.valorRecibir
        }
    }
    var lblPrecio : UILabel! {
        didSet {
            self.lblPrecio.text = "Costo Mensual"
            self.lblPrecio.font = Font.lightFontWithSize(14)
        }
    }
    var txtPrecio : UILabel! {
        didSet {
            self.txtPrecio.font = Font.regularFontWithSize(18)
            self.txtPrecio.text = self.viewModel.costoMensual
        }
    }

    //Initializers
    init(viewModel: PhonesViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //View Controller life cicle
    override func viewDidLoad() {
        self.title = "Lockphone"
        
        self.createPhoneInfoControls()
        self.updateViewConstraints()
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.updatePhoneInfoConstraints()
    }
    
    //Create Controls
    private func createPhoneInfoControls(){
        self.phoneInfoContainer = UIView()
        self.view.addSubview(self.phoneInfoContainer)
        self.imgPhoto = UIImageView()
        self.phoneInfoContainer.addSubview(self.imgPhoto)
        self.lblMarca = UILabel()
        self.phoneInfoContainer.addSubview(self.lblMarca)
        self.txtMarca = UILabel()
        self.phoneInfoContainer.addSubview(self.txtMarca)
        self.lblModelo = UILabel()
        self.phoneInfoContainer.addSubview(self.lblModelo)
        self.txtModelo = UILabel()
        self.phoneInfoContainer.addSubview(self.txtModelo)
        self.lblImei = UILabel()
        self.phoneInfoContainer.addSubview(self.lblImei)
        self.txtImei = UILabel()
        self.phoneInfoContainer.addSubview(self.txtImei)
        self.lblValorAsegurado = UILabel()
        self.phoneInfoContainer.addSubview(self.lblValorAsegurado)
        self.txtValorAsegurado = UILabel()
        self.phoneInfoContainer.addSubview(self.txtValorAsegurado)
        self.lblDeducible = UILabel()
        self.phoneInfoContainer.addSubview(self.lblDeducible)
        self.txtDeducible = UILabel()
        self.phoneInfoContainer.addSubview(self.txtDeducible)
        self.lblValorRecibir = UILabel()
        self.phoneInfoContainer.addSubview(self.lblValorRecibir)
        self.txtValorRecibir = UILabel()
        self.phoneInfoContainer.addSubview(self.txtValorRecibir)
        self.lblPrecio = UILabel()
        self.phoneInfoContainer.addSubview(self.lblPrecio)
        self.txtPrecio = UILabel()
        self.phoneInfoContainer.addSubview(self.txtPrecio)
    }
    
    //Update Constraints
    private func updatePhoneInfoConstraints() {
        self.phoneInfoContainer.snp_updateConstraints{
            $0.top.equalTo(self.view.snp_top).offset(20)
            $0.bottom.equalTo(self.view.snp_bottom)
            $0.left.equalTo(self.view.snp_left)
            $0.right.equalTo(self.view.snp_right)
        }
        self.imgPhoto.snp_updateConstraints{
            $0.top.equalTo(self.phoneInfoContainer.snp_top).offset(101)
            $0.leftMargin.equalTo(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.4)
            $0.height.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.7)
        }
        self.lblMarca.snp_updateConstraints{
            $0.top.equalTo(self.phoneInfoContainer.snp_top).offset(101)
            $0.left.equalTo(self.imgPhoto.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.6)
        }
        self.txtMarca.snp_updateConstraints{
            $0.top.equalTo(self.lblMarca.snp_bottom)
            $0.left.equalTo(self.imgPhoto.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.6)
        }
        self.lblModelo.snp_updateConstraints{
            $0.top.equalTo(self.txtMarca.snp_bottom).offset(5)
            $0.left.equalTo(self.imgPhoto.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.6)
        }
        self.txtModelo.snp_updateConstraints{
            $0.top.equalTo(self.lblModelo.snp_bottom)
            $0.left.equalTo(self.imgPhoto.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.6)
        }
        self.lblImei.snp_updateConstraints{
            $0.top.equalTo(self.txtModelo.snp_bottom).offset(5)
            $0.left.equalTo(self.imgPhoto.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.6)
        }
        self.txtImei.snp_updateConstraints{
            $0.top.equalTo(self.lblImei.snp_bottom)
            $0.left.equalTo(self.imgPhoto.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.6)
        }
        self.lblValorAsegurado.snp_updateConstraints{
            $0.top.equalTo(self.imgPhoto.snp_bottom).offset(10)
            $0.left.equalTo(self.phoneInfoContainer.snp_left).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
        self.txtValorAsegurado.snp_updateConstraints{
            $0.top.equalTo(self.imgPhoto.snp_bottom).offset(10)
            $0.left.equalTo(self.lblValorAsegurado.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
        self.lblDeducible.snp_updateConstraints{
            $0.top.equalTo(self.txtValorAsegurado.snp_bottom).offset(10)
            $0.left.equalTo(self.phoneInfoContainer.snp_left).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
        self.txtDeducible.snp_updateConstraints{
            $0.top.equalTo(self.txtValorAsegurado.snp_bottom).offset(10)
            $0.left.equalTo(self.lblDeducible.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
        self.lblValorRecibir.snp_updateConstraints{
            $0.top.equalTo(self.txtDeducible.snp_bottom).offset(10)
            $0.left.equalTo(self.phoneInfoContainer.snp_left).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
        self.txtValorRecibir.snp_updateConstraints{
            $0.top.equalTo(self.txtDeducible.snp_bottom).offset(10)
            $0.left.equalTo(self.lblPrecio.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
        self.lblPrecio.snp_updateConstraints{
            $0.top.equalTo(self.txtValorRecibir.snp_bottom).offset(10)
            $0.left.equalTo(self.phoneInfoContainer.snp_left).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
        self.txtPrecio.snp_updateConstraints{
            $0.top.equalTo(self.txtValorRecibir.snp_bottom).offset(10)
            $0.left.equalTo(self.lblPrecio.snp_right).offset(10)
            $0.width.equalTo(self.phoneInfoContainer.snp_width).multipliedBy(0.5)
        }
    }
    
}