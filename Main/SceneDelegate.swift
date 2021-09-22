//
//  SceneDelegate.swift
//  Main
//
//  Created by Samuel Brehm on 14/09/21.
//

import UIKit
import UI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigation = NavigationController()
        let getListEventsViewController = GetListEventsFactory.makeController(navigation: navigation)
        navigation.setRootViewController(getListEventsViewController)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}

