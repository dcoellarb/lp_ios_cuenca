//
//  PaymentViewController.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/18/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {
    
    let viewModel: PaymentViewModel
    
    //UI controls
    var mainContainer : UIView! {
        didSet {
            self.mainContainer.backgroundColor = Colors.white
        }
    }
    var paymentInfoContainer : UIView! {
        didSet {
            self.paymentInfoContainer.backgroundColor = Colors.lightergray
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
            self.lblStepNumber.text = "3"
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
            self.lblStepTitle.text = "Selecciona tu forma de pago"
        }
    }
    var lblStepDescription : UILabel! {
        didSet{
            self.lblStepDescription.font = Font.lightFontWithSize(12)
            self.lblStepDescription.text = "La forma de pago seleccionada se utilizará para debitar el pago de tu seguro cada mes."
            self.lblStepDescription.lineBreakMode = .ByWordWrapping
            self.lblStepDescription.numberOfLines = 0
        }
    }
    //Paypal
    var payPalContainer : UIView! {
        didSet{
            self.payPalContainer.backgroundColor = Colors.white
            self.payPalContainer.layer.cornerRadius = 10
            self.payPalContainer.layer.masksToBounds = true
            self.payPalContainer.layer.borderColor = Colors.darkgray.CGColor
            self.payPalContainer.layer.borderWidth = 1
        }
    }
    var payPalLogo : UIImageView! {
        didSet {
            self.payPalLogo.image = UIImage(named: "paypal")
        }
    }
    var lblPayPalDescription : UILabel! {
        didSet {
            self.lblPayPalDescription.text = "Los pagos se debitaran mensualmente de tu cuenta de PayPal."
            self.lblPayPalDescription.font = Font.lightFontWithSize(12)
            self.lblPayPalDescription.lineBreakMode = .ByWordWrapping
            self.lblPayPalDescription.numberOfLines = 0
        }
    }
    var btnPayPal : UIButton! {
        didSet {
            self.btnPayPal.backgroundColor = Colors.paypal
            self.btnPayPal.setTitle("Autorizar con PayPal", forState: .Normal)
            self.btnPayPal.setTitleColor(Colors.white, forState: .Normal)
            self.btnPayPal.titleLabel?.font = Font.boldFontWithSize(20)
            self.btnPayPal.addTarget(self, action: "obtainPayPalConcent", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnPayPal.userInteractionEnabled = true
            self.btnPayPal.enabled = true
        }
    }
    //Stripe
    var stripeContainer : UIView! {
        didSet{
            self.stripeContainer.backgroundColor = Colors.white
            self.stripeContainer.layer.cornerRadius = 10
            self.stripeContainer.layer.masksToBounds = true
            self.stripeContainer.layer.borderColor = Colors.darkgray.CGColor
            self.stripeContainer.layer.borderWidth = 1
        }
    }
    var stripeLogo : UIImageView! {
        didSet {
            self.stripeLogo.image = UIImage(named: "stripe")
        }
    }
    var lblStripeDescription : UILabel! {
        didSet {
            self.lblStripeDescription.text = "Los pagos se debitaran mensualmente de tu Tarjeta de Credito, protegido por Stripe."
            self.lblStripeDescription.font = Font.lightFontWithSize(12)
            self.lblStripeDescription.lineBreakMode = .ByWordWrapping
            self.lblStripeDescription.numberOfLines = 0
        }
    }
    var btnStripe : UIButton! {
        didSet {
            self.btnStripe.backgroundColor = Colors.stripe
            self.btnStripe.setTitle("Autorizar con Tarjeta de Credito", forState: .Normal)
            self.btnStripe.setTitleColor(Colors.white, forState: .Normal)
            self.btnStripe.titleLabel?.font = Font.boldFontWithSize(20)
            self.btnStripe.addTarget(self, action: "toogleStripe", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnStripe.userInteractionEnabled = true
            self.btnStripe.enabled = true
        }
    }
    var stripePaymentTextField: STPPaymentCardTextField! {
        didSet {
            self.stripePaymentTextField.layer.cornerRadius = 0
            self.stripePaymentTextField.delegate = self
            self.stripePaymentTextField.hidden = true
        }
    }
    var btnStripeClose : UIButton! {
        didSet {
            self.btnStripeClose.setTitle("cerrar", forState: .Normal)
            self.btnStripeClose.setTitleColor(Colors.darkgray, forState: .Normal)
            self.btnStripeClose.titleLabel?.font = Font.boldFontWithSize(14)
            self.btnStripeClose.addTarget(self, action: "toogleStripe", forControlEvents: UIControlEvents.TouchUpInside)
            self.btnStripeClose.userInteractionEnabled = true
            self.btnStripeClose.enabled = true
            self.btnStripeClose.hidden = true
        }
    }
    
    //Loading Frame
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
    
    //Initializers
    init(viewModel: PaymentViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //View overrides
    override func viewDidLoad() {
        self.title = "Lockphone"
        
        self.createPaymentInfoControls()
        self.createLoadingControls()
        self.updateViewConstraints()
        
        self.hideLoading()
    }
    override func viewWillAppear(animated: Bool) {
        //PayPal
        self.viewModel.preconnectToPayPalService()
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updatePaymentInfoConstraints()
        updateLoadingConstraints()
    }
    
    private func createPaymentInfoControls(){
        self.mainContainer = UIView()
        self.mainContainer.frame = self.view.bounds
        self.view.addSubview(mainContainer)
        self.paymentInfoContainer = UIView()
        self.mainContainer.addSubview(paymentInfoContainer)
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
        
        self.payPalContainer = UIView()
        self.paymentInfoContainer.addSubview(payPalContainer)
        self.payPalLogo = UIImageView()
        self.payPalContainer.addSubview(payPalLogo)
        self.lblPayPalDescription = UILabel()
        self.payPalContainer.addSubview(lblPayPalDescription)
       self.btnPayPal = UIButton()
        self.payPalContainer.addSubview(btnPayPal)

        self.stripeContainer = UIView()
        self.paymentInfoContainer.addSubview(stripeContainer)
        self.stripeLogo = UIImageView()
        self.stripeContainer.addSubview(stripeLogo)
        self.lblStripeDescription = UILabel()
        self.stripeContainer.addSubview(lblStripeDescription)
        self.btnStripe = UIButton()
        self.stripeContainer.addSubview(btnStripe)
        self.stripePaymentTextField = STPPaymentCardTextField()
        self.stripeContainer.addSubview(stripePaymentTextField)
        self.btnStripeClose = UIButton()
        self.stripeContainer.addSubview(btnStripeClose)
    }
    private func createLoadingControls(){
        self.loadingFrame = UIView()
        self.view.addSubview(loadingFrame)
        self.activityIndicator = UIActivityIndicatorView()
        self.loadingFrame.addSubview(activityIndicator)
        self.lblloadingMessage = UILabel()
        self.loadingFrame.addSubview(lblloadingMessage)
    }
    
    private func updatePaymentInfoConstraints() {
        self.paymentInfoContainer.snp_updateConstraints{
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
        
        
        
        self.stripeContainer.snp_updateConstraints{
            $0.top.equalTo(self.paymentInfoContainer.snp_top).offset(121)
            $0.width.equalTo(self.view.snp_width).offset(-30)
            $0.centerX.equalTo(self.view.snp_centerX)
            $0.height.equalTo(198)
        }
        self.stripeLogo.snp_updateConstraints{
            $0.top.equalTo(self.stripeContainer.snp_top).offset(33)
            $0.left.equalTo(self.paymentInfoContainer.snp_left).offset(33)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        self.btnStripe.snp_updateConstraints{
            $0.bottom.equalTo(self.stripeContainer.snp_bottom).offset(-33)
            $0.height.equalTo(66)
            $0.left.equalTo(self.stripeContainer.snp_left)
            $0.right.equalTo(self.stripeContainer.snp_right)
        }
        self.stripePaymentTextField.snp_updateConstraints{
            $0.bottom.equalTo(self.stripeContainer.snp_bottom).offset(-33)
            $0.height.equalTo(66)
            $0.left.equalTo(self.stripeContainer.snp_left)
            $0.right.equalTo(self.stripeContainer.snp_right)
        }
        self.btnStripeClose.snp_updateConstraints{
            $0.top.equalTo(self.stripePaymentTextField.snp_bottom)
            $0.centerX.equalTo(self.stripeContainer.snp_centerX)
            $0.width.equalTo(100)
            $0.height.equalTo(33)
        }
        self.lblStripeDescription.snp_updateConstraints{
            $0.top.equalTo(self.stripeContainer.snp_top).offset(33)
            $0.left.equalTo(self.stripeLogo.snp_right).offset(15)
            $0.right.equalTo(self.stripeContainer.snp_right).offset(-15)
        }
        
        
        
        self.payPalContainer.snp_updateConstraints{
            $0.top.equalTo(self.stripeContainer.snp_bottom).offset(30)
            $0.width.equalTo(self.view.snp_width).offset(-30)
            $0.centerX.equalTo(self.view.snp_centerX)
            $0.height.equalTo(198)
        }
        self.payPalLogo.snp_updateConstraints{
            $0.top.equalTo(self.payPalContainer.snp_top).offset(33)
            $0.left.equalTo(self.paymentInfoContainer.snp_left).offset(33)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        self.btnPayPal.snp_updateConstraints{
            $0.bottom.equalTo(self.payPalContainer.snp_bottom).offset(-33)
            $0.height.equalTo(66)
            $0.left.equalTo(self.payPalContainer.snp_left)
            $0.right.equalTo(self.payPalContainer.snp_right)
        }
        self.lblPayPalDescription.snp_updateConstraints{
            $0.top.equalTo(self.payPalContainer.snp_top).offset(33)
            $0.left.equalTo(self.payPalLogo.snp_right).offset(15)
            $0.right.equalTo(self.payPalContainer.snp_right).offset(-15)
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
    
    func action_back(){
        if let nc = self.navigationController{
            nc.popViewControllerAnimated(true)
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
    
    //PayPal
    func obtainPayPalConcent(){
        if let payPalFuturePaymentController = PayPalFuturePaymentViewController.init(configuration: self.viewModel.payPalConfiguration, delegate: self){
            self.presentViewController(payPalFuturePaymentController, animated: true, completion: nil)
        }
    }
    
    //Stripe
    func toogleStripe(){
        self.btnStripe.hidden = !self.btnStripe.hidden
        self.stripePaymentTextField.hidden = !self.stripePaymentTextField.hidden
        self.btnStripeClose.hidden = !self.btnStripeClose.hidden
        if !self.stripePaymentTextField.hidden {
            self.stripePaymentTextField.becomeFirstResponder()
        }else{
            self.stripePaymentTextField.resignFirstResponder()
        }
    }
}

extension PaymentViewController: PayPalFuturePaymentDelegate {
    func payPalFuturePaymentDidCancel(futurePaymentViewController: PayPalFuturePaymentViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func payPalFuturePaymentViewController(futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [NSObject : AnyObject]) {
        
        self.sendAuthorizationToServer(futurePaymentAuthorization)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    private func sendAuthorizationToServer(authorization: NSDictionary){
        do {
            let consentJSONData = try NSJSONSerialization.dataWithJSONObject(authorization, options: [])
            debugPrint(consentJSONData)
            // (Your network code here!)
            //
            // Send the authorization response to your server, where it can exchange the authorization code
            // for OAuth access and refresh tokens.
            //
            // Your server must then store these tokens, so that your server code can execute payments
            // for this user in the future.
        } catch let parseError{
            debugPrint(parseError)
        }
    }
}

extension PaymentViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        debugPrint(textField.valid)
        if textField.valid {
            debugPrint("card is valid")
            if let card = textField.card {
                self.toogleStripe()
                self.lblloadingMessage.text = "Creando suscripcion..."
                self.showLoading()
                STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                    if let error = error  {
                        debugPrint(error)
                        self.hideLoading()
                    }
                    else if let token = token {
                        self.createBackendChargeWithToken(token) { status in
                            debugPrint(status)
                            self.hideLoading()
                        }
                    }
                }
            }
        } else {
            debugPrint("card not valid")
        }
    }
    
    func createBackendChargeWithToken(token: STPToken, completion: PKPaymentAuthorizationStatus -> ()) {
        sleep(5)
        completion(PKPaymentAuthorizationStatus.Success)
        /*
        let url = NSURL(string: "https://example.com/token")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=(token.tokenId)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
            }
            else {
                completion(PKPaymentAuthorizationStatus.Success)
            }
        }
        task.resume()
        */
    }
}

