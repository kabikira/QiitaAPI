//
//  SceneDelegate.swift
//  CarthageSample3
//
//  Created by koala panda on 2023/03/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var loginViewController: LoginViewController?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            fatalError()
        }
        self.loginViewController = loginViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        print(url)
//        print(loginViewController)
        // ここでコードとステートがQiitaからURLに付属して返される
        
        loginViewController?.openURL(url)
    }
//    func application(_ app: UIApplication, open url: URL, opitons: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        guard let loginViewController = self.loginViewController else {
//            return true
//        }
//        print("!!!!!!!!")
//        loginViewController.openURL(url)
//        return true
//    }
    

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

