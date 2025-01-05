//
//  InfoViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/13/24.
//

import UIKit

class InfoViewController: UIViewController {

	private lazy var alertButton: CustomButton = {
		let button = CustomButton(
			title: "Show Alert",
			titleColor: .white
		) { [weak self] in
			self?.alertButtonTapped()
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(alertButton)

		alertButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			alertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			alertButton.heightAnchor.constraint(equalToConstant: 50),
			alertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			alertButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
		])
	}

	@objc func alertButtonTapped() {
		let alert: UIAlertController = {
			let alert = UIAlertController(title: "Warning!", message: "This is Alert", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
				print("Ok")
			})
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
				print("Cancel")
			})
			
			return alert
		}()

		present(alert, animated: true)
	}
}
