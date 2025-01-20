//
//  Coordinator.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/10/25.
//

import Foundation
import UIKit


class ProfileCoordinator: Coordinator {

	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		let logInVC = LogInViewController()
		let myLoginFactory = MyLoginFactory()
		logInVC.loginDelegate = myLoginFactory.makeLoginInspector()

		navigationController.pushViewController(logInVC, animated: false)
	}

}
