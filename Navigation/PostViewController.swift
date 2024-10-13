//
//  PostViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/13/24.
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
		let infoVC = InfoViewController()
		infoVC.view.backgroundColor = .systemBackground
		infoVC.modalPresentationStyle = .pageSheet
		infoVC.modalTransitionStyle = .coverVertical
		present(infoVC, animated: true, completion: nil)
	}

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}
