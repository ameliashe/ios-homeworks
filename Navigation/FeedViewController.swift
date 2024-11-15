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

	let postButton1: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Show post", for: .normal)

		return button
	}()

	let postButton2: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Show post", for: .normal)

		return button
	}()

	var post = Post(title: "This is a post!")

	lazy var postButtonStackView: UIStackView = {
		let stackView = UIStackView()

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.clipsToBounds = true
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 10

		stackView.addArrangedSubview(postButton1)
		stackView.addArrangedSubview(postButton2)

		return stackView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(postButtonStackView)
		configureButtons()
		configureStackView()
	}

	func configureButtons() {
		postButton1.addTarget(self, action: #selector(showPost), for: .touchUpInside)
		postButton2.addTarget(self, action: #selector(showPost), for: .touchUpInside)
	}

	@objc func showPost() {
		let postVC = PostViewController()
		postVC.postTitle = post.title
		navigationController?.pushViewController(postVC, animated: true)
	}

	func configureStackView() {
		NSLayoutConstraint.activate([
			postButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			postButtonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
