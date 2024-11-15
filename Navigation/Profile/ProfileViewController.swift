//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit

class ProfileViewController: UIViewController {

	private enum HeaderFooterReuseID: String {
		case base = "ProfileHeaderView_ID"
	}

	private enum CellReuseID: String {
		case base = "ProfilePostCell_ID"
	}

	let posts: [Post] = [
		Post(
			author: "Анна Янкова",
			description: "Невероятные виды на закат. Вчера была отличная погода, и я сделала несколько снимков у озера.",
			image: "sunset",
			likes: 120,
			views: 430
		),
		Post(
			author: "Борис Юрьев",
			description: "Люблю готовить! Сегодняшний эксперимент удался: попробовал новый рецепт пасты с морепродуктами. Все, кто пробовал, остались в восторге – обязательно буду готовить снова!",
			image: "food",
			likes: 95,
			views: 210
		),
		Post(
			author: "Виктория Этюхова",
			description: "Путешествия - это всегда приключение!",
			image: "mountain",
			likes: 145,
			views: 500
		),
		Post(
			author: "Геннадий Щербаков",
			description: "Прогулка в лесу – лучшее лекарство от суеты. Сегодня обнаружил уютное место у реки, где можно посидеть в тишине и насладиться природой. Такие моменты помогают перезагрузиться.",
			image: "forest",
			likes: 90,
			views: 250
		),
		Post(
			author: "Диана Шастун",
			description: "Сегодня я посетила выставку современного искусства и вдохновилась на создание своего арт-проекта. Мне очень понравилось сочетание ярких цветов и минимализма в работах художников.",
			image: "art",
			likes: 60,
			views: 180
		),
		Post(
			author: "Евгений Чарков",
			description: "Вчера я попробовал новый сорт чая – улун с легкими цветочными нотками. Он не только обладает приятным вкусом, но и помогает расслабиться после долгого дня. Определенно, теперь это мой фаворит на вечерние чаепития!",
			image: "tea",
			likes: 75,
			views: 300
		)
	]

	let profileHeaderView = ProfileHeaderView()

	lazy private var postsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		addSubviews()
		setupView()
		setupConstraints()
		setupTableView()

    }

	func addSubviews() {
		view.addSubview(postsTableView)
	}

	func setupView() {
		view.backgroundColor = .systemGray6
	}

	func setupTableView() {
		postsTableView.rowHeight = UITableView.automaticDimension
		postsTableView.estimatedRowHeight = 200
		postsTableView.tableFooterView = UIView()
		postsTableView.contentInsetAdjustmentBehavior = .never

		postsTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue)

		postsTableView.register(CustomPostCell.self, forCellReuseIdentifier: CellReuseID.base.rawValue)

		postsTableView.delegate = self
		postsTableView.dataSource = self
	}

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

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterReuseID.base.rawValue) as? ProfileHeaderView else { return nil }
		headerView.contentView.backgroundColor = .systemGray6
		return headerView
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		posts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.base.rawValue, for: indexPath) as? CustomPostCell else {
			fatalError("could not dequeue cell")
		}
		cell.update(posts[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 220
	}

}
