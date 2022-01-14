//
//  SceneDelegate.swift
//  Canada Cheese
//
//  Created by Taylor Young on 2020-09-03.
//  Copyright © 2020 Taylor Young. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /// If app not yet running, see https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Navigation bar tint color for regular size class
        UINavigationBar.appearance().tintColor = .systemRed
        
        if let urlContext = connectionOptions.urlContexts.first {

            let url = urlContext.url
            
            // Process the URL.
            guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                let params = components.queryItems else {
                    print("Invalid URL or cheeseId missing")
                    return
            }

            // if cheeseId given
            if let cheeseId = params.first(where: { $0.name == "id" })?.value {
                if UITraitCollection.current.horizontalSizeClass == .regular {
                    let sidebarVC = window?.rootViewController?.children.first?.children.first as? SidebarViewController
                    sidebarVC?.displayCheeseDetail(for: cheeseId, loaded: false)
                } else {
                    // compact size class
                    let splitViewController = window?.rootViewController as? UISplitViewController
                    let allCheeseVC = splitViewController?.viewController(for: .compact)?.children.first?.children.first as? AllCheeseTableViewController
                    
                    allCheeseVC?.displayCheeseDetail(for: cheeseId, loaded: false)
                }
            } else {
                print("cheeseId missing")
            }
        }
    }
    
    /// If app already running, see https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {

            let url = urlContext.url
            
            // Process the URL.
            guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                let params = components.queryItems else {
                    print("Invalid URL or cheeseId missing")
                    return
            }

            // if cheeseId is given
            if let cheeseId = params.first(where: { $0.name == "id" })?.value {
                if UITraitCollection.current.horizontalSizeClass == .regular {
                    let sidebarVC = window?.rootViewController?.children.first?.children.first as? SidebarViewController
                    sidebarVC?.displayCheeseDetail(for: cheeseId)
                } else {
                    // compact size class
                    let tabBarController = window?.rootViewController?.children.last as? TabBarController
                    let allCheeseVC = tabBarController?.children.first?.children.first as? AllCheeseTableViewController
                    // Move tabBarController back to AllCheeseTableViewController
                    tabBarController?.selectedIndex = 0
                    
                    allCheeseVC?.displayCheeseDetail(for: cheeseId)
                }
            } else {
                print("cheeseId missing")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

