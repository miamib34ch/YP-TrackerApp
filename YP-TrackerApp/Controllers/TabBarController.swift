//
//  ViewController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let trackersController = TrackersViewController()
        let statsController = StatsController()
        viewControllers = [trackersController, statsController]

        configureTabBarItems(trackersController, NSLocalizedString("tabBarTrackers", comment: "Лейбл вкладки трекеров в таббаре"), UIImage(named: "TrackersLogo"))
        configureTabBarItems(statsController, NSLocalizedString("tabBarStatistics", comment: "Лейбл вкладки статистики в таббаре"), UIImage(named: "StatsLogo"))
    }

    private func configureTabBarItems(_ controller: UIViewController, _ title: String, _ image: UIImage?) {
        controller.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
    }

}
