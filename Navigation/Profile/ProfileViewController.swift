//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		setupView()
		setupProfileHeaderView()
		setupBottomButton()
    }

	func setupView() {
		view.backgroundColor = .lightGray
		title = "Profile"
		navigationController?.navigationBar.isTranslucent = false
	}

	let profileHeaderView = ProfileHeaderView()


	func setupProfileHeaderView() {
		view.addSubview(profileHeaderView)
		profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			profileHeaderView.heightAnchor.constraint(equalToConstant: 220)
		])
	}

	let bottomButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Кнопка внизу", for: .normal)
		return button
	}()

	func setupBottomButton() {
		view.addSubview(bottomButton)
		bottomButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

	}

}
