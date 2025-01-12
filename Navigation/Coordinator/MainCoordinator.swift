//
//  Coordinator.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/10/25.
//

import Foundation
import UIKit

protocol Coordinator {
	var navigationController: UINavigationController { get set }
	func start()
}

class MainCoordinator: Coordinator {

	var navigationController = UINavigationController()
	var tabBarController = UITabBarController()

	var feedCoordinator: FeedCoordinator?
	var profileCoordinator: ProfileCoordinator?

	init(navigationController: UINavigationController, tabBarController: UITabBarController) {
		self.navigationController = navigationController
		self.tabBarController = tabBarController
	}

	func start() {

		let feedNC = UINavigationController()
		let profileNC = UINavigationController()

		feedCoordinator = FeedCoordinator(navigationController:	feedNC)
		profileCoordinator = ProfileCoordinator(navigationController: profileNC)

		feedCoordinator?.start()
		profileCoordinator?.start()

		let controllers = [feedNC, profileNC]
		tabBarController.viewControllers = controllers

		feedNC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet.rectangle"), tag: 0)
		profileNC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)

		tabBarController.selectedIndex = 0
		tabBarController.tabBar.isTranslucent = false

		navigationController.viewControllers = [tabBarController]
	}

}
