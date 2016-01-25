//
//  CuentaViewController.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/25/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import UIKit

class CuentaViewController: UIViewController {
    
    var viewModel: CuentaViewModel
    
    init(viewModel: CuentaViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}