//
//  SceneDelegate.swift
//  TabattaTimer
//
//  Created by apple on 01/02/21.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // 1. Capture the scene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2. Create a new UIWindow using the windowScene constructor which takes in a window scene.
        window = UIWindow(windowScene: windowScene)
        
        // 3. Create a view hierarchy programmatically
        let rootViewController = TTHomeViewController()
        
        // 4. Set the root view controller of the window with your view controller
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        
        // 5. Set the window and call makeKeyAndVisible()
        window?.makeKeyAndVisible()
    }

}

