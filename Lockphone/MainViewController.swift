//
//  MainViewController.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/19/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import UIKit

class MainViewController : UITabBarController{

    var viewModel: MainViewModel
    
    var controllers: [UIViewController]
    //var phones: PhonesViewController?
    //var aseguradora: AseguradoraViewController?
    //var cuenta: CuentaViewController?
    
    //Initializers
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.controllers = [UIViewController]()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //View overrrides
    override func viewDidLoad() {
        self.controllers.removeAll()
        
        //self.phones = PhonesViewController(viewModel: PhonesViewModel())
        //self.phones!.tabBarItem = UITabBarItem(title: "Phones", image: UIImage(named: "phones"), selectedImage: UIImage(named: "phones_selected"))
        //controllers.append(self.phones!)

        //self.aseguradora = AseguradoraViewController(viewModel: AseguradoraViewModel())
        //self.aseguradora!.tabBarItem = UITabBarItem(title: "Aseguradora", image: UIImage(named: "aseguradora"), selectedImage: UIImage(named: "aseguradora_selected"))
        //controllers.append(self.aseguradora!)

        //self.cuenta = CuentaViewController(viewModel: CuentaViewModel())
        //self.cuenta!.tabBarItem = UITabBarItem(title: "Phones", image: UIImage(named: "cuenta"), selectedImage: UIImage(named: "cuenta_selected"))
        //controllers.append(self.cuenta!)
        
        self.viewControllers = self.controllers
        
        self.tabBar.layer.borderColor = Colors.lightgray.CGColor
        self.tabBar.layer.borderWidth = 1
        self.tabBar.barTintColor = Colors.white
        self.tabBar.tintColor = Colors.red
    }
}