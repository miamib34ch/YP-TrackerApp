//
//  SceneDelegate.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.04.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if UserDefaults.standard.bool(forKey: "onboardingWasShowed") {
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
        } else {
            let onboardingPageViewController = OnboardingPageViewController(transitionStyle: .scroll,
                                                                            navigationOrientation: .horizontal)
            window?.rootViewController = onboardingPageViewController
            UserDefaults.standard.set(true, forKey: "onboardingWasShowed")
        }

        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

}
