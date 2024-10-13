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

		let alertButton = UIButton(type: .system)
		alertButton.setTitle("Вызвать Алерт", for: .normal)
		alertButton.addTarget(self, action: #selector(alertButtonTapped), for: .touchUpInside)

		view.addSubview(alertButton)

		alertButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			alertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}

	@objc func alertButtonTapped() {
		let alert = UIAlertController(title: "Внимание!", message: "Это Алерт", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
			print("Ok")
		})
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
			print("Cancel")
		})
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
