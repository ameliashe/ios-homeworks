//
//  InfoViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 10/13/24.
//

import UIKit

class InfoViewController: UIViewController {

	//MARK: UI elements
	let taskLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.textColor = .black
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()

	let planetLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.textColor = .black
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()

	private lazy var alertButton = CustomButton(title: NSLocalizedString("Show Alert", comment: "Show alert button title")) { [weak self] in
		self?.alertButtonTapped()
	}


	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		addSubviews()
		setupConstraints()
		fetchData()
	}


	//MARK: Layout
	func addSubviews() {
		view.addSubview(alertButton)
		view.addSubview(taskLabel)
		view.addSubview(planetLabel)
	}

	fileprivate func setupConstraints() {
		alertButton.translatesAutoresizingMaskIntoConstraints = false
		taskLabel.translatesAutoresizingMaskIntoConstraints = false
		planetLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			alertButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			alertButton.heightAnchor.constraint(equalToConstant: 50),
			alertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			alertButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

			taskLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			taskLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			taskLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

			planetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			planetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			planetLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 16),
		])
	}


	//MARK: NetworkService
	func fetchData() {
		NetworkService.request(from: URL(string: "https://jsonplaceholder.typicode.com/todos/4")!) { [weak self] result in

			switch result {
			case .success(let data):
				let todoTaskParsed = Parser.parseTask(data)
				DispatchQueue.main.async {
					let taskText = String(
						format: NSLocalizedString("Task named: %@", comment: "Label showing the name of the fetched task"),
						todoTaskParsed?.title ?? NSLocalizedString("No task", comment: "Default task title")
					)
					self?.taskLabel.text = taskText
				}
			case .failure(let error):
				print(error.localizedDescription)
				break
			}
		}

		NetworkService.request(from: URL(string: "https://swapi.dev/api/planets/1")!) { [weak self] result in

			switch result {
			case .success(let data):
				let planet = Parser.decodePlanet(data)
				DispatchQueue.main.async {
					let orbitalPeriodText = String(
						format: NSLocalizedString("Orbital period of %@: %d", comment: "Planet name and its orbital period in days"),
						planet?.name ?? "-",
						planet?.orbitalPeriod ?? 0
					)
					self?.planetLabel.text = orbitalPeriodText
				}
			case .failure(let error):
				print(error.localizedDescription)
				break
			}
		}
	}

	//MARK: User interaction
	@objc func alertButtonTapped() {
		let alert: UIAlertController = {
			let alert = UIAlertController(title: NSLocalizedString("Warning!", comment: "Test alert title"), message: NSLocalizedString("This is Alert", comment: "Test alert message"), preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
				print("OK")
			})
			alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel alert button"), style: .cancel) { _ in
				print("Cancel")
			})

			return alert
		}()

		present(alert, animated: true)
	}
}
