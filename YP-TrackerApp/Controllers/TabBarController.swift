//
//  ViewController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.04.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersController = TrackersViewController()
        let statsController = StatsController()
        viewControllers = [trackersController, statsController]
        
        configureTabBarItems(trackersController, "Трекеры", UIImage(named: "TrackersLogo"))
        configureTabBarItems(statsController, "Статистика", UIImage(named: "StatsLogo"))
    }

    func configureTabBarItems(_ controller: UIViewController, _ title: String, _ image: UIImage?) {
        controller.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
    }
    
}
