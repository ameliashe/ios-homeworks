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

	private lazy var alertButton = CustomButton(title: "Show Alert") { [weak self] in
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
					self?.taskLabel.text = "Таска называется: \(todoTaskParsed?.title ?? "No task")"
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
					self?.planetLabel.text = "Период обращения \(planet?.name ?? "-"): \(planet?.orbitalPeriod ?? 0)"
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
