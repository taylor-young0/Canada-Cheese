//
//  TabBarController.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2021-07-29.
//  Copyright © 2021 Taylor Young. All rights reserved.
//
//  Modified from https://stackoverflow.com/a/58848387

import UIKit

protocol TabBarReselectHandling {
    func handleReselect()
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController === viewController {
            let navigationController = viewController as? UINavigationController
            let handler = navigationController?.viewControllers.first as? TabBarReselectHandling
            
            handler?.handleReselect()
        }
        
        return true
    }

}
