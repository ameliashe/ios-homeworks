//
//  PostViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 10/13/24.
//

import UIKit

class PostViewController: UIViewController {
	var postTitle: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBrown
		title = postTitle

		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector (showInfo))
	}


	@objc func showInfo() {
		let infoViewController: InfoViewController = {
			let infoVC = InfoViewController()
			infoVC.view.backgroundColor = .systemBackground
			infoVC.modalPresentationStyle = .pageSheet
			infoVC.modalTransitionStyle = .coverVertical
			return infoVC
		}()

		present(infoViewController, animated: true, completion: nil)
	}
}
