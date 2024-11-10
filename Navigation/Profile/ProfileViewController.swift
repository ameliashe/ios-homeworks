//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit

class ProfileViewController: UIViewController {

	struct Post {
		let author: String
		let description: String
		let image: String
		let likes: Int
		let views: Int
	}

	let posts: [Post] = [
		Post(
			author: "Анна",
			description: "Невероятные виды на закат 🌅",
			image: "sunset_image",
			likes: 120,
			views: 430
		),
		Post(
			author: "Борис",
			description: "Люблю готовить! Сегодняшний эксперимент удался 👨‍🍳",
			image: "food_image",
			likes: 95,
			views: 210
		),
		Post(
			author: "Виктория",
			description: "Путешествия - это всегда приключение! Следующий пункт - Альпы 🏔️",
			image: "mountain_image",
			likes: 145,
			views: 500
		),
		Post(
			author: "Геннадий",
			description: "Пробежка по городу - лучший способ начать день 🏃‍♂️",
			image: "city_run_image",
			likes: 75,
			views: 300
		)
	]

	lazy private var postsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		setupView()
		
    }

	func setupView() {
		view.backgroundColor = .lightGray
	}

	let profileHeaderView = ProfileHeaderView()

	func setupTableView() {
		postsTableView.delegate = self
		postsTableView.dataSource = self
		postsTableView.register(postCell.self, forCellReuseIdentifier: postCell.reuseIdentifier)
		postsTableView.rowHeight = 100
	}

//	let postCell: UITableViewCell = {
//		let cell = UITableViewCell()
//		cell.translatesAutoresizingMaskIntoConstraints = false
//		
//		return cell
//	}()


	func setupConstraints() {
		NSLayoutConstraint.activate([
			postsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			postsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			postsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		<#code#>
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		<#code#>
	}
	
}
