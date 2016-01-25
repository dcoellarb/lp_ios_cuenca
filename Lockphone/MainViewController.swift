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
    var phones: PhonesViewController?
    var aseguradora: AseguradoraViewController?
    var cuenta: CuentaViewController?
    
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
        
        self.phones = PhonesViewController(viewModel: PhonesViewModel())
        self.phones!.tabBarItem = UITabBarItem(title: "Dispositivo", image: UIImage(named: "menuPhones"), selectedImage: UIImage(named: "menuPhonesSelected"))
        self.phones?.tabBarItem.image = self.phones?.tabBarItem.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.phones?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : Colors.white], forState: UIControlState.Normal)
        controllers.append(self.phones!)

        self.aseguradora = AseguradoraViewController(viewModel: AseguradoraViewModel())
        self.aseguradora!.tabBarItem = UITabBarItem(title: "Aseguradora", image: UIImage(named: "menuAseguradora"), selectedImage: UIImage(named: "menuAseguradoraSelected"))
        self.aseguradora?.tabBarItem.image = self.aseguradora?.tabBarItem.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.aseguradora?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : Colors.white], forState: UIControlState.Normal)
        controllers.append(self.aseguradora!)

        self.cuenta = CuentaViewController(viewModel: CuentaViewModel())
        self.cuenta!.tabBarItem = UITabBarItem(title: "Cuenta", image: UIImage(named: "menuCuenta"), selectedImage: UIImage(named: "menuCuentaSelected"))
        self.cuenta?.tabBarItem.image = self.cuenta?.tabBarItem.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.cuenta?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : Colors.white], forState: UIControlState.Normal)
        controllers.append(self.cuenta!)
        
        self.viewControllers = self.controllers
        
        self.tabBar.barTintColor = Colors.red
        self.tabBar.tintColor = Colors.white
        /*
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.blueColor()], forState: UIControlState.Normal) // changes the default color
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.blackColor()], forState: UIControlState.Selected) // changes the selected color
        */
    }
}