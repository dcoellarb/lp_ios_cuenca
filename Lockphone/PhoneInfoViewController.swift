//
//  PhoneInfoViewController.swift
//  Lockphone
//
//  Created by Daniel Coellar on 12/23/15.
//  Copyright © 2015 lockphone. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class PhoneInfoViewController : UIViewController{

    private var viewModel: PhoneInfoViewModel

    //UI controls
    var mainContainer : UIView! {
        didSet {
            self.mainContainer.backgroundColor = Colors.white
        }
    }
    var topBar : UIView! {
        didSet{
            self.topBar.backgroundColor = Colors.white
            self.topBar.layer.shadowColor = Colors.lightgray.CGColor
            self.topBar.layer.shadowOffset = CGSizeMake(0, 3);
            self.topBar.layer.shadowOpacity = 0.5;
            self.topBar.layer.shadowRadius = 1.0;
        }
    }
    var lblStepNumber : UILabel! {
        didSet{
            self.lblStepNumber.font = Font.regularFontWithSize(30)
            self.lblStepNumber.text = "1"
            self.lblStepNumber.textAlignment = .Center
            self.lblStepNumber.textColor = Colors.white
            self.lblStepNumber.backgroundColor = Colors.red
            self.lblStepNumber.layer.cornerRadius = 35
            self.lblStepNumber.layer.masksToBounds = true
        }
    }
    var lblStepTitle : UILabel! {
        didSet{
            self.lblStepTitle.font = Font.boldFontWithSize(16)
            self.lblStepTitle.text = "Informacion del Dispositivo"
        }
    }
    var lblStepDescription : UILabel! {
        didSet{
            self.lblStepDescription.font = Font.lightFontWithSize(12)
            self.lblStepDescription.text = "Para asegurar tu telefono necesitamos obtener su marca, modelo y numero de IMEI"
            self.lblStepDescription.lineBreakMode = .ByWordWrapping
            self.lblStepDescription.numberOfLines = 0
        }
    }
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
        }
    }
    var btnNext : UIButton! {
        didSet {
            self.btnNext.backgroundColor = Colors.redDisabled
            self.btnNext.setTitle("CONTINUAR", forState: .Normal)
            self.btnNext.setTitleColor(Colors.white, forState: .Normal)
            self.btnNext.titleLabel?.font = Font.regularFontWithSize(18)
            self.btnNext.addTarget(self, action: "continuar:", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnNext.userInteractionEnabled = true
            self.btnNext.enabled = false
        }
    }
    var loadingFrame : UIView! {
        didSet {
            self.loadingFrame.backgroundColor = Colors.white
            self.loadingFrame.layer.cornerRadius = 10;
            self.loadingFrame.layer.masksToBounds = true;
        }
    }
    var activityIndicator : UIActivityIndicatorView! {
        didSet {
            self.activityIndicator.activityIndicatorViewStyle = .Gray
            self.activityIndicator.startAnimating()
        }
    }
    var lblloadingMessage : UILabel! {
        didSet {
            self.lblloadingMessage.text = "Cargando..."
            self.lblloadingMessage.textColor = Colors.darkgray
            self.lblloadingMessage.textAlignment = .Center
        }
    }
    var errorFrame : UIView! {
        didSet {
            self.errorFrame.backgroundColor = Colors.darkgray
        }
    }
    var lblErrorMessage : UILabel! {
        didSet {
            self.lblErrorMessage.text = "ERROR"
            self.lblErrorMessage.textColor = Colors.white
            self.lblErrorMessage.textAlignment = .Center
            self.lblErrorMessage.font = Font.lightFontWithSize(16)
            self.lblErrorMessage.lineBreakMode = .ByWordWrapping
            self.lblErrorMessage.numberOfLines = 0
        }
    }
    var btnObtenerImei : UIButton! {
        didSet {
            self.btnObtenerImei.setTitleColor(Colors.white, forState: .Normal)
            self.btnObtenerImei.setTitle("Obtener IMEI", forState: .Normal)
            self.btnObtenerImei.titleLabel?.font = Font.regularFontWithSize(18)
            self.btnObtenerImei.addTarget(self, action: "obtenerIMEI:", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnObtenerImei.userInteractionEnabled = true
            self.btnObtenerImei.layer.cornerRadius = 5;
            self.btnObtenerImei.layer.masksToBounds = true;
        }
    }
    var btnReintentar : UIButton! {
        didSet {
            self.btnReintentar.setTitleColor(Colors.white, forState: .Normal)
            self.btnReintentar.setTitle("Reintentar", forState: .Normal)
            self.btnReintentar.titleLabel?.font = Font.regularFontWithSize(18)
            self.btnReintentar.addTarget(self, action: "reintentar:", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnReintentar.userInteractionEnabled = true
            self.btnReintentar.layer.cornerRadius = 5;
            self.btnReintentar.layer.masksToBounds = true;
        }
    }
    
    //Initializers
    init (viewModel: PhoneInfoViewModel){
        debugPrint("local init")
        
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
        self.createLoadingControls()
        self.createErrorControls()

        self.updateViewConstraints()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: "applicationDidBecomeActive", object: nil)
        
        self.initData()
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.updatePhoneInfoConstraints()
        self.updateLoadingConstraints()
        self.updateErrorConstraints()
    }
    func applicationDidBecomeActive(){
        debugPrint("local application did become active")

        self.initData()
    }
    
    //UIButtons targets
    func obtenerIMEI(sender: AnyObject) {
        if let id = viewModel.deviceId{
            if let url  = NSURL(string:"https://lockphone-qa-najhp5-2388.herokuapp.com/#/install_profile?deviceId=" + id){
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    func reintentar(sender: AnyObject){
        debugPrint("local reintentar")
        
        self.initData()
    }
    func continuar(sender: AnyObject){
        if let nc = self.navigationController {
            let controller = CustomerInfoViewController(viewModel: CustomerInfoViewModel())
            nc.pushViewController(controller, animated: true)
        }
    }

    //Create Controls
    private func createPhoneInfoControls(){
        self.mainContainer = UIView()
        self.mainContainer.frame = self.view.bounds
        self.view.addSubview(self.mainContainer)
        self.phoneInfoContainer = UIView()
        self.mainContainer.addSubview(self.phoneInfoContainer)
        self.topBar = UIView()
        self.mainContainer.addSubview(self.topBar)
        self.lblStepNumber = UILabel()
        self.topBar.addSubview(self.lblStepNumber)
        self.lblStepTitle = UILabel()
        self.topBar.addSubview(self.lblStepTitle)
        self.lblStepDescription = UILabel()
        self.topBar.addSubview(self.lblStepDescription)
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
        self.btnNext = UIButton()
        self.phoneInfoContainer.addSubview(self.btnNext)
    }
    private func createLoadingControls(){
        self.loadingFrame = UIView()
        self.view.addSubview(self.loadingFrame)
        self.activityIndicator = UIActivityIndicatorView()
        self.loadingFrame.addSubview(self.activityIndicator)
        self.lblloadingMessage = UILabel()
        self.loadingFrame.addSubview(self.lblloadingMessage)
    }
    private func createErrorControls(){
        self.errorFrame = UIView()
        self.view.addSubview(self.errorFrame)
        self.lblErrorMessage = UILabel()
        self.errorFrame.addSubview(self.lblErrorMessage)
        self.btnObtenerImei = UIButton()
        self.errorFrame.addSubview(self.btnObtenerImei)
        self.btnReintentar = UIButton()
        self.errorFrame.addSubview(self.btnReintentar)
    }
    
    //Update Constraints
    private func updatePhoneInfoConstraints() {
        self.phoneInfoContainer.snp_updateConstraints{
            $0.top.equalTo(self.mainContainer.snp_top).offset(20)
            $0.bottom.equalTo(self.mainContainer.snp_bottom)
            $0.left.equalTo(self.mainContainer.snp_left)
            $0.right.equalTo(self.mainContainer.snp_right)
        }        
        self.topBar.snp_updateConstraints{
            $0.top.equalTo(self.mainContainer.snp_top).offset(20)
            $0.width.equalTo(self.mainContainer.snp_width)
            $0.height.equalTo(86)
        }
        self.lblStepNumber.snp_updateConstraints{
            $0.top.equalTo(self.topBar.snp_top).offset(8)
            $0.left.equalTo(self.topBar.snp_left).offset(8)
            $0.width.equalTo(70)
            $0.height.equalTo(70)
        }
        self.lblStepTitle.snp_updateConstraints{
            $0.top.equalTo(self.topBar.snp_top).offset(8)
            $0.left.equalTo(self.lblStepNumber.snp_right).offset(8)
            $0.right.equalTo(self.topBar.snp_right).offset(-5)
        }
        self.lblStepDescription.snp_updateConstraints{
            $0.top.equalTo(self.lblStepTitle.snp_bottom).offset(2)
            $0.left.equalTo(self.lblStepNumber.snp_right).offset(8)
            $0.right.equalTo(self.topBar.snp_right).offset(-5)
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
        self.btnNext.snp_updateConstraints{
            $0.bottom.equalTo(self.phoneInfoContainer.snp_bottom)
            $0.width.equalTo(self.phoneInfoContainer.snp_width)
            $0.height.equalTo(44)
        }
    }
    private func updateLoadingConstraints() {
        self.loadingFrame.snp_updateConstraints{
            $0.centerX.equalTo(self.view.snp_centerX)
            $0.centerY.equalTo(self.view.snp_centerY)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        self.activityIndicator.snp_updateConstraints{
            $0.centerX.equalTo(self.loadingFrame.snp_centerX)
            $0.top.equalTo(self.loadingFrame.snp_top).offset(10)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        self.lblloadingMessage.snp_updateConstraints{
            $0.top.equalTo(self.activityIndicator.snp_bottom).offset(5)
            $0.centerX.equalTo(self.loadingFrame.snp_centerX)
            $0.width.equalTo(self.loadingFrame.snp_width)
        }
    }
    private func updateErrorConstraints() {
        self.errorFrame.snp_updateConstraints{
            $0.centerY.equalTo(self.view.snp_centerY)
            $0.width.equalTo(self.view.snp_width)
            $0.height.equalTo(150)
        }
        self.lblErrorMessage.snp_updateConstraints{
            $0.top.equalTo(self.errorFrame.snp_top).offset(5)
            $0.width.equalTo(self.errorFrame.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.btnObtenerImei.snp_updateConstraints{
            $0.bottom.equalTo(self.errorFrame.snp_bottom).offset(-5)
            $0.centerX.equalTo(self.view.snp_centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(66)
        }
        self.btnReintentar.snp_updateConstraints{
            $0.bottom.equalTo(self.errorFrame.snp_bottom).offset(-5)
            $0.centerX.equalTo(self.view.snp_centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(66)
        }
    }
    
    //Helper methods
    private func initData(){
        self.hideError()
        self.showLoading()
        getPhoneInfo()
    }
    private func getPhoneInfo(){
        if Reachability.isConnectedToNetwork() {
            self.viewModel.setPhoneInfo().subscribeNext { info in
                debugPrint("returning from setPhoneInfo:")
                
                self.hideLoading()
                if let brand = info.brand{
                    self.txtMarca.text = brand
                }
                if let model = info.model{
                    self.txtModelo.text = model
                }
                
                if let imei = self.viewModel.imei {
                    self.txtImei.text = imei.stringByReplacingOccurrencesOfString("%20", withString: " ")
                    self.txtValorAsegurado.text = self.viewModel.valorAsegurado
                    self.txtDeducible.text = self.viewModel.deducible
                    self.txtValorRecibir.text = self.viewModel.valorRecibir
                    self.txtPrecio.text = self.viewModel.costoMensual
                    self.btnNext.enabled = true
                    self.btnNext.backgroundColor = Colors.red
                }else{
                    if let _ = self.viewModel.deviceId{
                        self.lblErrorMessage.text = "Para asegurar tu telefono tenemos que identificar tu numero IMEI; por favor presiona Obtener IMEI para continuar."
                        self.btnObtenerImei.hidden = false
                        self.btnReintentar.hidden = true
                        self.showError()
                    }else{
                        self.lblErrorMessage.text = "Lo sentimos, tuvimos problemas al cargar la informacion, por favor intenta de nuevo."
                        self.btnObtenerImei.hidden = true
                        self.btnReintentar.hidden = false
                        self.showError()
                    }
                }
            }
        }else{
            debugPrint("no internet connection:")//+ status.description)
            self.lblErrorMessage.text = "Lo sentimos, parece no haber coneccion a internet, por favor revisa tu coneccion e intenta de nuevo."
            self.btnObtenerImei.hidden = true
            self.btnReintentar.hidden = false
            self.showError()
        }
    }
    
    private func showLoading(){
        self.mainContainer.blur(blurRadius: 4)
        self.loadingFrame.hidden = false
        self.view.bringSubviewToFront(self.loadingFrame)
    }
    private func hideLoading(){
        self.mainContainer.unBlur()
        self.loadingFrame.hidden = true
        self.view.sendSubviewToBack(self.loadingFrame)
    }

    private func showError(){
        self.mainContainer.blur(blurRadius: 4)
        self.errorFrame.hidden = false
        self.view.bringSubviewToFront(self.errorFrame)
    }
    private func hideError(){
        self.mainContainer.unBlur()
        self.errorFrame.hidden = true
        self.view.sendSubviewToBack(self.errorFrame)
    }
}