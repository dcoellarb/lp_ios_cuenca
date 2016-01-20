//
//  CustomerInfoViewController.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/14/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class CustomerInfoViewController : UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
    private var viewModel: CustomerInfoViewModel
    private let txtBorderY : CGFloat = 34
    private let txtHeight = 35
    private let txtSeparation = 20
    private let txtBorderColor = Colors.lightgray
    
    //UI controls
    var mainContainer : UIView! {
        didSet {
            self.mainContainer.backgroundColor = Colors.white
        }
    }
    var customerInfoContainer : UIView! {
        didSet {
            self.customerInfoContainer.backgroundColor = Colors.lightergray
        }
    }
    
    //Top bar
    var topBar : UIView! {
        didSet{
            self.topBar.backgroundColor = Colors.white
            self.topBar.layer.shadowColor = Colors.lightgray.CGColor
            self.topBar.layer.shadowOffset = CGSizeMake(0, 3);
            self.topBar.layer.shadowOpacity = 0.5;
            self.topBar.layer.shadowRadius = 1.0;
        }
    }
    var btnBack : UIButton! {
        didSet {
            self.btnBack.backgroundColor = Colors.white
            self.btnBack.setImage(UIImage(named: "back"), forState: .Normal)
            self.btnBack.addTarget(self, action: "action_back", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnBack.userInteractionEnabled = true
            self.btnBack.enabled = true
        }
    }
    var lblStepNumber : UILabel! {
        didSet{
            self.lblStepNumber.font = Font.regularFontWithSize(30)
            self.lblStepNumber.text = "2"
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
            self.lblStepTitle.text = "Ingresa o Registra tus datos"
        }
    }
    var lblStepDescription : UILabel! {
        didSet{
            self.lblStepDescription.font = Font.lightFontWithSize(12)
            self.lblStepDescription.text = "Necesitamos estos datos para tu contrato de seguro, factura y usuario."
            self.lblStepDescription.lineBreakMode = .ByWordWrapping
            self.lblStepDescription.numberOfLines = 0
        }
    }
    
    //Login frame
    var lblDescriptionRegister : UILabel! {
        didSet{
            self.lblDescriptionRegister.font = Font.lightFontWithSize(18)
            self.lblDescriptionRegister.text = "Si ya estas registrado en Lockphone ingresa tu email y clave."
            self.lblDescriptionRegister.lineBreakMode = .ByWordWrapping
            self.lblDescriptionRegister.numberOfLines = 0
            self.lblDescriptionRegister.textColor = Colors.darkgray
            self.lblDescriptionRegister.textAlignment = .Center
        }
    }
    var loginFrame : UIView! {
        didSet{
            self.loginFrame.backgroundColor = Colors.white
            //self.loginFrame.layer.cornerRadius = 5
            //self.loginFrame.layer.masksToBounds = true
            //self.loginFrame.layer.borderColor = Colors.darkgray.CGColor
            //self.loginFrame.layer.borderWidth = 1
            
            let topBorder = CALayer()
            topBorder.frame = CGRectMake(0, 0, self.view.frame.size.width, 1)
            topBorder.backgroundColor = txtBorderColor.CGColor
            self.loginFrame.layer.addSublayer(topBorder)

            let bottomBorder = CALayer()
            let height = (self.txtHeight * 2)+(self.txtSeparation * 4)
            bottomBorder.frame = CGRectMake(0, CGFloat(height), self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.loginFrame.layer.addSublayer(bottomBorder)
        
        }
    }
    var txtLoginEmail : UITextField! {
        didSet{
            self.txtLoginEmail.placeholder = "Email"
            self.txtLoginEmail.font = Font.regularFontWithSize(18)
            self.txtLoginEmail.keyboardType = UIKeyboardType.EmailAddress
            self.txtLoginEmail.delegate = self
            self.txtLoginEmail.tag = 0
            self.txtLoginEmail.autocapitalizationType = UITextAutocapitalizationType.None
            self.txtLoginEmail.autocorrectionType = UITextAutocorrectionType.No
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtLoginEmail.layer.addSublayer(bottomBorder)
            
            self.txtLoginEmail.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var txtLoginPassword : UITextField! {
        didSet{
            self.txtLoginPassword.placeholder = "Clave"
            self.txtLoginPassword.font = Font.regularFontWithSize(18)
            self.txtLoginPassword.secureTextEntry = true
            self.txtLoginPassword.inputAccessoryView = btnLogin
            self.txtLoginPassword.delegate = self
            self.txtLoginPassword.tag = 1
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtLoginPassword.layer.addSublayer(bottomBorder)
            
            self.txtLoginPassword.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var btnRegister : UIButton! {
        didSet {
            self.btnRegister.backgroundColor = Colors.lightergray
            self.btnRegister.setTitle("Aun no estoy registrado en Lockphone", forState: .Normal)
            self.btnRegister.setTitleColor(Colors.red, forState: .Normal)
            self.btnRegister.titleLabel?.font = Font.regularFontWithSize(14)
            self.btnRegister.addTarget(self, action: "show_registration", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnRegister.userInteractionEnabled = true
        }
    }
    var btnLogin : UIButton! {
        didSet {
            self.btnLogin.frame = CGRectMake(0, 0, self.view.frame.width, CGFloat(44))
            self.btnLogin.backgroundColor = Colors.redDisabled
            self.btnLogin.setTitle("INGRESAR", forState: .Normal)
            self.btnLogin.setTitleColor(Colors.white, forState: .Normal)
            self.btnLogin.titleLabel?.font = Font.regularFontWithSize(18)
            self.btnLogin.addTarget(self, action: "action_signin", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnLogin.userInteractionEnabled = true
            self.btnLogin.enabled = false
        }
    }
    var btnLoginSpinner : UIActivityIndicatorView! {
        didSet {
            self.btnLoginSpinner.hidden = true
            self.btnLoginSpinner.userInteractionEnabled = true
        }
    }
    
    //Registration
    var formContainer : UIScrollView! {
        didSet {
            self.formContainer.delegate = self
            self.formContainer.frame = self.view.bounds
            self.formContainer.contentSize = CGSizeMake(self.view.frame.size.width,900)
            self.formContainer.hidden = true
        }
    }
    var formContainerContent : UIView! {
        didSet {
            self.formContainerContent.backgroundColor = Colors.white
            self.formContainerContent.frame = CGRectMake(0, 101, self.formContainer.contentSize.width, self.formContainer.contentSize.height)
        }
    }
    var lblRegistroTitle : UILabel! {
        didSet {
            self.lblRegistroTitle.text = "REGISTRO"
            self.lblRegistroTitle.textColor = Colors.darkergray
            self.lblRegistroTitle.font = Font.lightFontWithSize(16)
            self.lblRegistroTitle.textAlignment = .Center
        }
    }
    var btnCancelRegistro : UIButton! {
        didSet {
            self.btnCancelRegistro.setTitle("Cerrar", forState: .Normal)
            self.btnCancelRegistro.setTitleColor(Colors.darkgray, forState: .Normal)
            self.btnCancelRegistro.titleLabel?.font = Font.regularFontWithSize(12)
            self.btnCancelRegistro.addTarget(self, action: "hide_registration", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnCancelRegistro.userInteractionEnabled = true
        }
    }
    var lblNombre : UILabel! {
        didSet {
            self.lblNombre.text = "Nombre"
            self.lblNombre.textColor = txtBorderColor
            self.lblNombre.font = Font.lightFontWithSize(12)
        }
    }
    var txtNombre : UITextField! {
        didSet {
            self.txtNombre.font = Font.regularFontWithSize(18)
            self.txtNombre.inputAccessoryView = btnNext
            self.txtNombre.delegate = self
            self.txtNombre.tag = 10
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = Colors.lightgray.CGColor
            self.txtNombre.layer.addSublayer(bottomBorder)
            
            self.txtNombre.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var lblDireccion : UILabel! {
        didSet {
            self.lblDireccion.text = "Direccion"
            self.lblDireccion.textColor = txtBorderColor
            self.lblDireccion.font = Font.lightFontWithSize(12)
        }
    }
    var txtDireccion : UITextField! {
        didSet {
            self.txtDireccion.font = Font.regularFontWithSize(18)
            self.txtDireccion.inputAccessoryView = btnNext
            self.txtDireccion.delegate = self
            self.txtDireccion.tag = 11

            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtDireccion.layer.addSublayer(bottomBorder)

            self.txtDireccion.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var lblTelefono : UILabel! {
        didSet {
            self.lblTelefono.text = "Telefono"
            self.lblTelefono.textColor = txtBorderColor
            self.lblTelefono.font = Font.regularFontWithSize(18)
            self.lblTelefono.font = Font.lightFontWithSize(12)
        }
    }
    var txtTelefono : UITextField! {
        didSet {
            self.txtTelefono.font = Font.regularFontWithSize(18)
            self.txtTelefono.keyboardType = UIKeyboardType.NumbersAndPunctuation
            self.txtTelefono.inputAccessoryView = btnNext
            self.txtTelefono.delegate = self
            self.txtTelefono.tag = 12
            self.txtTelefono.autocapitalizationType = UITextAutocapitalizationType.None
            self.txtTelefono.autocorrectionType = UITextAutocorrectionType.No
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtTelefono.layer.addSublayer(bottomBorder)
            
            self.txtTelefono.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var lblRucCI : UILabel! {
        didSet {
            self.lblRucCI.text = "RUC / CI"
            self.lblRucCI.textColor = txtBorderColor
            self.lblRucCI.font = Font.lightFontWithSize(14)
        }
    }
    var txtRucCI : UITextField! {
        didSet {
            self.txtRucCI.font = Font.regularFontWithSize(18)
            self.txtRucCI.keyboardType = UIKeyboardType.NumbersAndPunctuation
            self.txtRucCI.inputAccessoryView = btnNext
            self.txtRucCI.delegate = self
            self.txtRucCI.tag = 13
            self.txtRucCI.autocapitalizationType = UITextAutocapitalizationType.None
            self.txtRucCI.autocorrectionType = UITextAutocorrectionType.No
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtRucCI.layer.addSublayer(bottomBorder)
            
            self.txtRucCI.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var lblEmail : UILabel! {
        didSet {
            self.lblEmail.text = "Email"
            self.lblEmail.textColor = txtBorderColor
            self.lblEmail.font = Font.lightFontWithSize(14)
        }
    }
    var txtEmail : UITextField! {
        didSet {
            self.txtEmail.font = Font.regularFontWithSize(18)
            self.txtEmail.keyboardType = UIKeyboardType.EmailAddress
            self.txtEmail.inputAccessoryView = btnNext
            self.txtEmail.delegate = self
            self.txtEmail.tag = 14
            self.txtEmail.autocapitalizationType = UITextAutocapitalizationType.None
            self.txtEmail.autocorrectionType = UITextAutocorrectionType.No
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtEmail.layer.addSublayer(bottomBorder)
            
            self.txtEmail.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var lblErrorEmail : UILabel! {
        didSet {
            self.lblErrorEmail.text = ""
            self.lblErrorEmail.textColor = Colors.red
            self.lblErrorEmail.font = Font.lightFontWithSize(10)
            self.lblErrorEmail.hidden = true
            self.lblErrorEmail.textAlignment = .Center
        }
    }
    var lblPassword : UILabel! {
        didSet {
            self.lblPassword.text = "Clave"
            self.lblPassword.textColor = txtBorderColor
            self.lblPassword.font = Font.lightFontWithSize(14)
        }
    }
    var txtPassword : UITextField! {
        didSet {
            self.txtPassword.font = Font.regularFontWithSize(18)
            self.txtPassword.secureTextEntry = true
            self.txtPassword.inputAccessoryView = btnNext
            self.txtPassword.delegate = self
            self.txtPassword.tag = 15
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtPassword.layer.addSublayer(bottomBorder)
            
            self.txtPassword.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var lblConfirmPassword : UILabel! {
        didSet {
            self.lblConfirmPassword.text = "Confirmar Clave"
            self.lblConfirmPassword.textColor = txtBorderColor
            self.lblConfirmPassword.font = Font.lightFontWithSize(14)
        }
    }
    var txtConfirmPassword : UITextField! {
        didSet {
            self.txtConfirmPassword.font = Font.regularFontWithSize(18)
            self.txtConfirmPassword.secureTextEntry = true
            self.txtConfirmPassword.inputAccessoryView = btnNext
            self.txtConfirmPassword.delegate = self
            self.txtConfirmPassword.tag = 16
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0, self.txtBorderY, self.view.frame.size.width, 1)
            bottomBorder.backgroundColor = txtBorderColor.CGColor
            self.txtConfirmPassword.layer.addSublayer(bottomBorder)
            
            self.txtConfirmPassword.addTarget(self, action: "editChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    var lblErrorConfirmPassword : UILabel! {
        didSet {
            self.lblErrorConfirmPassword.text = ""
            self.lblErrorConfirmPassword.textColor = Colors.red
            self.lblErrorConfirmPassword.font = Font.lightFontWithSize(10)
            self.lblErrorConfirmPassword.hidden = true
            self.lblErrorConfirmPassword.textAlignment = .Center
        }
    }
    var btnNext : UIButton! {
        didSet {
            self.btnNext.frame = CGRectMake(0, 0, self.view.frame.width, CGFloat(44))
            self.btnNext.backgroundColor = Colors.redDisabled
            self.btnNext.setTitle("CONTINUAR", forState: .Normal)
            self.btnNext.setTitleColor(Colors.white, forState: .Normal)
            self.btnNext.titleLabel?.font = Font.regularFontWithSize(18)
            self.btnNext.addTarget(self, action: "action_signup", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnNext.userInteractionEnabled = true
            self.btnNext.enabled = false
        }
    }
    var btnNextSpinner : UIActivityIndicatorView! {
        didSet {
            self.btnNextSpinner.hidden = true
            self.btnNextSpinner.userInteractionEnabled = true
        }
    }
    
    //Error Frame
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
    var btnReintentar : UIButton! {
        didSet {
            self.btnReintentar.setTitleColor(Colors.white, forState: .Normal)
            self.btnReintentar.setTitle("Reintentar", forState: .Normal)
            self.btnReintentar.titleLabel?.font = Font.regularFontWithSize(18)
            self.btnReintentar.addTarget(self, action: "initData", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnReintentar.userInteractionEnabled = true
            self.btnReintentar.layer.cornerRadius = 5;
            self.btnReintentar.layer.masksToBounds = true;
        }
    }
    
    
    
    init (viewModel: CustomerInfoViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Lockphone"
        
        self.createPhoneInfoControls()
        self.createRegisterControls()
        self.createErrorControls()

        updateViewConstraints()
                
        self.hideError()
        self.txtLoginEmail.becomeFirstResponder()
    }
    
    func  editChange(sender: UITextField){
        if let text = sender.text{
            if sender.tag == 0 {
                self.viewModel.loginUsername = text
            } else if sender.tag == 1 {
                self.viewModel.loginPassword = text
                if self.viewModel.validateLoginForm(){
                    self.btnLogin.enabled = true
                    self.btnLogin.backgroundColor = Colors.red
                }else{
                    self.btnLogin.enabled = false
                    self.btnLogin.backgroundColor = Colors.redDisabled
                }
            } else if sender.tag == 10 {
                self.viewModel.nombre = text
                if self.viewModel.validatePassword() && self.viewModel.validateEmail() && self.viewModel.validateForm(){
                    self.btnNext.enabled = true
                    self.btnNext.backgroundColor = Colors.red
                }else{
                    self.btnNext.enabled = false
                    self.btnNext.backgroundColor = Colors.redDisabled
                }
            } else if sender.tag == 11 {
                self.viewModel.direccion = text
                if self.viewModel.validatePassword() && self.viewModel.validateEmail() && self.viewModel.validateForm(){
                    self.btnNext.enabled = true
                    self.btnNext.backgroundColor = Colors.red
                }else{
                    self.btnNext.enabled = false
                    self.btnNext.backgroundColor = Colors.redDisabled
                }
            } else if sender.tag == 12 {
                self.viewModel.telefono = text
                if self.viewModel.validatePassword() && self.viewModel.validateEmail() && self.viewModel.validateForm(){
                    self.btnNext.enabled = true
                    self.btnNext.backgroundColor = Colors.red
                }else{
                    self.btnNext.enabled = false
                    self.btnNext.backgroundColor = Colors.redDisabled
                }
            } else if sender.tag == 13 {
                self.viewModel.rucCI = text
                if self.viewModel.validatePassword() && self.viewModel.validateEmail() && self.viewModel.validateForm(){
                    self.btnNext.enabled = true
                    self.btnNext.backgroundColor = Colors.red
                }else{
                    self.btnNext.enabled = false
                    self.btnNext.backgroundColor = Colors.redDisabled
                }
            } else if sender.tag == 14 {
                self.viewModel.email = text
                if self.viewModel.validateEmail(){
                    if self.viewModel.validatePassword() && self.viewModel.validateForm(){
                        self.btnNext.enabled = true
                        self.btnNext.backgroundColor = Colors.red
                    }else{
                        self.btnNext.enabled = false
                        self.btnNext.backgroundColor = Colors.redDisabled
                    }
                    self.lblErrorEmail.hidden = true
                }else{
                    self.lblErrorEmail.text = "Email Invalido."
                    self.lblErrorEmail.hidden = false
                    self.btnNext.enabled = false
                    self.btnNext.backgroundColor = Colors.redDisabled
                }
            } else if sender.tag == 15 || sender.tag == 16{
                if sender.tag == 15{
                    self.viewModel.password = text
                } else {
                    self.viewModel.confirmPassword = text
                }
                if self.viewModel.validatePassword(){
                    if self.viewModel.validateEmail() && self.viewModel.validateForm(){
                        self.btnNext.enabled = true
                        self.btnNext.backgroundColor = Colors.red
                    }else{
                        self.btnNext.enabled = false
                        self.btnNext.backgroundColor = Colors.redDisabled
                    }
                    self.lblErrorConfirmPassword.hidden = true
                }else{
                    self.lblErrorConfirmPassword.text = "Claves no coinciden"
                    self.lblErrorConfirmPassword.hidden = false
                    self.btnNext.enabled = false
                    self.btnNext.backgroundColor = Colors.redDisabled
                }
            }
        }
        
    }
    
    private func createPhoneInfoControls(){
        self.mainContainer = UIView()
        self.mainContainer.frame = self.view.bounds
        self.view.addSubview(mainContainer)
        self.customerInfoContainer = UIView()
        self.mainContainer.addSubview(customerInfoContainer)
        self.topBar = UIView()
        self.mainContainer.addSubview(topBar)
        self.btnBack = UIButton()
        self.topBar.addSubview(btnBack)
        self.lblStepNumber = UILabel()
        self.topBar.addSubview(lblStepNumber)
        self.lblStepTitle = UILabel()
        self.topBar.addSubview(lblStepTitle)
        self.lblStepDescription = UILabel()
        self.topBar.addSubview(lblStepDescription)
        self.lblDescriptionRegister = UILabel()
        self.customerInfoContainer.addSubview(lblDescriptionRegister)
        self.btnLogin = UIButton()
        self.btnLoginSpinner = UIActivityIndicatorView()
        self.btnLogin.addSubview(btnLoginSpinner)
        self.loginFrame = UIView()
        self.customerInfoContainer.addSubview(loginFrame)
        self.txtLoginEmail = UITextField()
        self.loginFrame.addSubview(txtLoginEmail)
        self.txtLoginPassword = UITextField()
        self.loginFrame.addSubview(txtLoginPassword)
        self.btnRegister = UIButton()
        self.customerInfoContainer.addSubview(btnRegister)
    }
    private func createRegisterControls(){
        self.formContainer = UIScrollView()
        self.view.addSubview(formContainer)
        self.lblRegistroTitle = UILabel()
        self.formContainer.addSubview(lblRegistroTitle)
        self.btnCancelRegistro = UIButton()
        self.formContainer.addSubview(btnCancelRegistro)
        self.formContainerContent = UIView()
        self.formContainer.addSubview(formContainerContent)
        self.btnNext = UIButton()
        self.btnNextSpinner = UIActivityIndicatorView()
        self.btnNext.addSubview(btnNextSpinner)
        self.lblNombre = UILabel()
        self.formContainerContent.addSubview(lblNombre)
        self.txtNombre = UITextField()
        self.formContainerContent.addSubview(txtNombre)
        self.lblDireccion = UILabel()
        self.formContainerContent.addSubview(lblDireccion)
        self.txtDireccion = UITextField()
        self.formContainerContent.addSubview(txtDireccion)
        self.lblTelefono = UILabel()
        self.formContainerContent.addSubview(lblTelefono)
        self.txtTelefono = UITextField()
        self.formContainerContent.addSubview(txtTelefono)
        self.lblRucCI = UILabel()
        self.formContainerContent.addSubview(lblRucCI)
        self.txtRucCI = UITextField()
        self.formContainerContent.addSubview(txtRucCI)
        self.lblEmail = UILabel()
        self.formContainerContent.addSubview(lblEmail)
        self.txtEmail = UITextField()
        self.formContainerContent.addSubview(txtEmail)
        self.lblErrorEmail = UILabel()
        self.formContainerContent.addSubview(lblErrorEmail)
        self.lblPassword = UILabel()
        self.formContainerContent.addSubview(lblPassword)
        self.txtPassword = UITextField()
        self.formContainerContent.addSubview(txtPassword)
        self.lblConfirmPassword = UILabel()
        self.formContainerContent.addSubview(lblConfirmPassword)
        self.txtConfirmPassword = UITextField()
        self.formContainerContent.addSubview(txtConfirmPassword)
        self.lblErrorConfirmPassword = UILabel()
        self.formContainerContent.addSubview(lblErrorConfirmPassword)
    }
    private func createErrorControls(){
        self.errorFrame = UIView()
        self.view.addSubview(errorFrame)
        self.lblErrorMessage = UILabel()
        self.errorFrame.addSubview(lblErrorMessage)
        self.btnReintentar = UIButton()
        self.errorFrame.addSubview(self.btnReintentar)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateCustomerInfoConstraints()
        updateRegisterConstraints()
        updateErrorConstraints()
    }
    private func updateCustomerInfoConstraints() {
        self.customerInfoContainer.snp_updateConstraints{
            $0.top.equalTo(self.mainContainer.snp_top)
            $0.bottom.equalTo(self.mainContainer.snp_bottom)
            $0.left.equalTo(self.mainContainer.snp_left)
            $0.right.equalTo(self.mainContainer.snp_right)
        }
        self.topBar.snp_updateConstraints{
            $0.top.equalTo(self.mainContainer.snp_top).offset(20)
            $0.width.equalTo(self.mainContainer.snp_width)
            $0.height.equalTo(86)
        }
        self.btnBack.snp_updateConstraints{
            $0.top.equalTo(self.topBar.snp_top).offset(21)
            $0.left.equalTo(self.topBar.snp_left).offset(8)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        self.lblStepNumber.snp_updateConstraints{
            $0.top.equalTo(self.topBar.snp_top).offset(8)
            $0.left.equalTo(self.topBar.snp_left).offset(60)
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
        self.lblDescriptionRegister.snp_updateConstraints{
            $0.top.equalTo(self.customerInfoContainer.snp_top).offset(121)
            $0.height.equalTo(self.txtHeight*2)
            $0.width.equalTo(self.customerInfoContainer.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.loginFrame.snp_updateConstraints{
            $0.top.equalTo(self.lblDescriptionRegister.snp_bottom).offset(10)
            $0.height.equalTo((self.txtHeight * 2)+(self.txtSeparation*4))
            $0.centerX.equalTo(self.customerInfoContainer.snp_centerX)
            $0.width.equalTo(self.customerInfoContainer.snp_width)
        }
        self.txtLoginEmail.snp_updateConstraints{
            $0.top.equalTo(self.loginFrame.snp_top).offset(self.txtSeparation)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.loginFrame.snp_width).offset(-40)
            $0.leftMargin.equalTo(20)
        }
        self.txtLoginPassword.snp_updateConstraints{
            $0.top.equalTo(self.txtLoginEmail.snp_bottom).offset(self.txtSeparation)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.loginFrame.snp_width).offset(-40)
            $0.leftMargin.equalTo(20)
        }
        self.btnRegister.snp_updateConstraints{
            $0.top.equalTo(self.loginFrame.snp_bottom).offset(10)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.customerInfoContainer.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.btnLoginSpinner.snp_updateConstraints{
            $0.centerX.equalTo(self.btnLogin.snp_centerX)
            $0.centerY.equalTo(self.btnLogin.snp_centerY)
            $0.height.equalTo(self.btnLogin.snp_width)
            $0.width.equalTo(self.btnLogin.snp_width)
        }
    }
    private func updateRegisterConstraints(){
        self.lblRegistroTitle.snp_updateConstraints{
            $0.top.equalTo(self.formContainer.snp_top).offset(40)
            $0.width.equalTo(self.formContainer.snp_width)
            $0.height.equalTo(txtHeight)
        }
        self.btnCancelRegistro.snp_updateConstraints{
            $0.centerY.equalTo(self.lblRegistroTitle.snp_centerY)
            $0.right.equalTo(self.view.snp_right)
            $0.width.equalTo(100)
            $0.height.equalTo(txtHeight)
        }
        self.lblNombre.snp_updateConstraints{
            $0.top.equalTo(self.formContainerContent.snp_top).offset(15)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.txtNombre.snp_updateConstraints{
            $0.top.equalTo(self.lblNombre.snp_bottom)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.lblDireccion.snp_updateConstraints{
            $0.top.equalTo(self.txtNombre.snp_bottom).offset(txtSeparation)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.txtDireccion.snp_updateConstraints{
            $0.top.equalTo(self.lblDireccion.snp_bottom)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.lblTelefono.snp_updateConstraints{
            $0.top.equalTo(self.txtDireccion.snp_bottom).offset(txtSeparation)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.txtTelefono.snp_updateConstraints{
            $0.top.equalTo(self.lblTelefono.snp_bottom)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.lblRucCI.snp_updateConstraints{
            $0.top.equalTo(self.txtTelefono.snp_bottom).offset(txtSeparation)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.txtRucCI.snp_updateConstraints{
            $0.top.equalTo(self.lblRucCI.snp_bottom)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.lblEmail.snp_updateConstraints{
            $0.top.equalTo(self.txtRucCI.snp_bottom).offset(txtSeparation)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.txtEmail.snp_updateConstraints{
            $0.top.equalTo(self.lblEmail.snp_bottom)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.lblErrorEmail.snp_updateConstraints{
            $0.top.equalTo(self.txtEmail.snp_bottom).offset(3)
            $0.height.equalTo(15)
            $0.width.equalTo(self.formContainerContent.snp_width)
        }
        self.lblPassword.snp_updateConstraints{
            $0.top.equalTo(self.txtEmail.snp_bottom).offset(txtSeparation)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.txtPassword.snp_updateConstraints{
            $0.top.equalTo(self.lblPassword.snp_bottom)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.lblConfirmPassword.snp_updateConstraints{
            $0.top.equalTo(self.txtPassword.snp_bottom).offset(txtSeparation)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.txtConfirmPassword.snp_updateConstraints{
            $0.top.equalTo(self.lblConfirmPassword.snp_bottom).offset(10)
            $0.height.equalTo(self.txtHeight)
            $0.width.equalTo(self.formContainerContent.snp_width).offset(-20)
            $0.leftMargin.equalTo(10)
        }
        self.lblErrorConfirmPassword.snp_updateConstraints{
            $0.top.equalTo(self.txtConfirmPassword.snp_bottom).offset(3)
            $0.height.equalTo(15)
            $0.width.equalTo(self.formContainerContent.snp_width)
        }
        self.btnNextSpinner.snp_updateConstraints{
            $0.centerX.equalTo(self.btnNext.snp_centerX)
            $0.centerY.equalTo(self.btnNext.snp_centerY)
            $0.height.equalTo(self.btnNext.snp_width)
            $0.width.equalTo(self.btnNext.snp_width)
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
        self.btnReintentar.snp_updateConstraints{
            $0.bottom.equalTo(self.errorFrame.snp_bottom).offset(-5)
            $0.centerX.equalTo(self.view.snp_centerX)
            $0.width.equalTo(200)
            $0.height.equalTo(66)
        }
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
    
    func action_signup(){
        self.btnNext.enabled = false
        self.btnNext.setTitle("", forState: .Disabled)
        self.btnNextSpinner.hidden = false
        self.btnNextSpinner.startAnimating()
        debugPrint("next tapped")
        if self.viewModel.validatePassword() && self.viewModel.validateEmail() && self.viewModel.validateForm(){
            self.viewModel.signUp().subscribeNext{ success in
                self.btnNextSpinner.stopAnimating()
                self.btnNextSpinner.hidden = true
                self.btnNext.setTitle("CONTINUAR", forState: .Disabled)
                self.btnNext.enabled = true
                
                if success {
                    debugPrint("successfull signup")
                    if let nc = self.navigationController{
                        self.txtNombre.text = ""
                        self.txtDireccion.text = ""
                        self.txtTelefono.text = ""
                        self.txtRucCI.text = ""
                        self.txtEmail.text = ""
                        self.txtPassword.text = ""
                        self.txtConfirmPassword.text = ""
                        
                        let controller = PaymentViewController(viewModel: PaymentViewModel())
                        nc.pushViewController(controller, animated: true)
                    }
                }else{
                    debugPrint("fail signup")
                }
            }
        }
    }
    func action_signin(){
        self.btnLogin.enabled = false
        self.btnLogin.setTitle("", forState: .Disabled)
        self.btnLoginSpinner.hidden = false
        self.btnLoginSpinner.startAnimating()
        debugPrint("login tapped")
        
        if self.viewModel.validateLoginForm() {
            self.viewModel.login().subscribeNext{ success in
                self.btnLoginSpinner.stopAnimating()
                self.btnLoginSpinner.hidden = true
                self.btnLogin.setTitle("INGRESAR", forState: .Disabled)
                self.btnLogin.enabled = true

                if success {
                    if let nc = self.navigationController{
                        self.txtLoginEmail.text = ""
                        self.txtLoginPassword.text = ""
                        
                        let controller = PaymentViewController(viewModel: PaymentViewModel())
                        nc.pushViewController(controller, animated: true)
                    }
                }else{
                    debugPrint("fail login")
                }
            }
        }
    }
    
    func action_back(){
        if let nc = self.navigationController{
            nc.popViewControllerAnimated(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 0{
            self.txtLoginPassword.becomeFirstResponder()
        } else if textField.tag == 1{
            action_signin()
        } else if textField.tag == 10{
            self.txtDireccion.becomeFirstResponder()
            var point = lblDireccion.frame.origin
            point.x -= 10
            point.y -= 15
            self.formContainer.contentOffset = point
        }else if textField.tag == 11{
            self.txtTelefono.becomeFirstResponder()
            var point = lblTelefono.frame.origin
            point.x -= 10
            point.y -= 15
            self.formContainer.contentOffset = point
        }else if textField.tag == 12{
            self.txtRucCI.becomeFirstResponder()
            var point = lblRucCI.frame.origin
            point.x -= 10
            point.y -= 15
            self.formContainer.contentOffset = point
        }else if textField.tag == 13{
            self.txtEmail.becomeFirstResponder()
            var point = lblEmail.frame.origin
            point.x -= 10
            point.y -= 15
            self.formContainer.contentOffset = point
        }else if textField.tag == 14{
            self.txtPassword.becomeFirstResponder()
        }else if textField.tag == 15{
            self.txtConfirmPassword.becomeFirstResponder()
        }
        return true
    }
    
    func show_registration(){
        self.mainContainer.blur(blurRadius: 8)
        self.formContainer.hidden = false
        self.view.bringSubviewToFront(self.formContainer)
        
        self.formContainer.frame = CGRect(x: 0,y: self.view.bounds.height,width: self.view.bounds.width,height: 900)
        UIView.animateWithDuration(1.0,
            delay:0.1,
            options: [.CurveEaseOut],
            animations: {
                self.formContainer.frame = self.view.bounds
            },
            completion: { finished in
                self.txtNombre.becomeFirstResponder()
        })
    }
    func hide_registration(){
        self.formContainer.endEditing(true)
        self.formContainer.frame = self.view.bounds
        UIView.animateWithDuration(1.0,
            delay:0.1,
            options: [.CurveEaseIn],
            animations: {
                self.formContainer.frame = CGRect(x: 0,y: self.view.bounds.height,width: self.view.bounds.width,height: 900)
            },
            completion: { finished in
                self.mainContainer.unBlur()
                self.formContainer.hidden = true
                self.view.sendSubviewToBack(self.formContainer)
                
                self.txtLoginEmail.becomeFirstResponder()
        })
    }
}

