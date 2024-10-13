//
//  FeedViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/13/24.
//

import UIKit

class FeedViewController: UIViewController {

	struct Post {
		let title: String
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let postButton = UIButton(type: .system)
		postButton.setTitle("Показать пост", for: .normal)
		postButton.addTarget(self, action: #selector(showPost), for: .touchUpInside)
		postButton.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(postButton)

		NSLayoutConstraint.activate([
			postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			postButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}

	var post = Post(title: "Это пост!")

	@objc func showPost() {
		let postVC = PostViewController()
		postVC.postTitle = post.title
		navigationController?.pushViewController(postVC, animated: true)
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
