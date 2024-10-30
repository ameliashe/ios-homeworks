//
//  InfoViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/13/24.
//

import UIKit

class InfoViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let alertButton: UIButton = {
			let button = UIButton(type: .system)
			button.setTitle("Show Alert", for: .normal)
			button.addTarget(self, action: #selector(alertButtonTapped), for: .touchUpInside)

			return button
		}()

		view.addSubview(alertButton)

		alertButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			alertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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


	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}
