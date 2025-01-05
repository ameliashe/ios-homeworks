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

	private lazy var postButton1: CustomButton = {
		let button = CustomButton(
			title: "Show post",
			titleColor: .white
		) { [weak self] in
			self?.showPost()
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var postButton2: CustomButton = {
		let button = CustomButton(
			title: "Show post",
			titleColor: .white
		) { [weak self] in
			self?.showPost()
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var checkGuessButton: CustomButton = {
		let button = CustomButton(
			title: "Check Guess",
			titleColor: .white
		) { [weak self] in
			self?.checkButtonTapped()
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private let guessTextField: UITextField = {
		let field = UITextField()
		field.placeholder = "  Guess..."
		field.backgroundColor = .white
		field.font = .systemFont(ofSize: .init(15), weight: .regular)
		field.textColor = .black
		field.layer.cornerRadius = 10
		field.layer.borderWidth = 1
		field.layer.borderColor = UIColor.black.cgColor
		field.isUserInteractionEnabled = true
		field.translatesAutoresizingMaskIntoConstraints = false
		return field
	}()

	private let resultLabel: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.text = "Result"
		label.font = .systemFont(ofSize: .init(16), weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	var post = Post(title: "This is a post!")

	private lazy var postButtonStackView: UIStackView = {
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

	var model: FeedModel

	init(model: FeedModel) {
		self.model = model
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(handleCheckResult), name: .secretWordChecked, object: nil)
		addSubviews()
		configureStackView()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		NotificationCenter.default.removeObserver(self)
	}

	func addSubviews() {
		view.addSubview(postButtonStackView)
		view.addSubview(guessTextField)
		view.addSubview(checkGuessButton)
		view.addSubview(resultLabel)
	}

	func showPost() {
		let postVC = PostViewController()
		postVC.postTitle = post.title
		navigationController?.pushViewController(postVC, animated: true)
	}

	func configureStackView() {
		NSLayoutConstraint.activate([
			postButtonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			postButtonStackView.heightAnchor.constraint(equalToConstant: 110),
			postButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			postButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

			guessTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			guessTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			guessTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 16),
			guessTextField.heightAnchor.constraint(equalToConstant: 40),

			resultLabel.leadingAnchor.constraint(equalTo: guessTextField.trailingAnchor, constant: 16),
			resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			resultLabel.centerYAnchor.constraint(equalTo: guessTextField.centerYAnchor),

			checkGuessButton.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 16),
			checkGuessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			checkGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			checkGuessButton.heightAnchor.constraint(equalToConstant: 50),
		])
	}

	func checkButtonTapped() {
	
		guard let guessText = guessTextField.text else { return }

		model.check(guessText)
	}

	@objc func handleCheckResult(_ notification: Notification) {
		guard let userInfo = notification.userInfo,
			  let isCorrect = userInfo["isCorrect"] as? Bool else { return }

		resultLabel.text = isCorrect ? "is correct!" : "is wrong!"
		resultLabel.textColor = isCorrect ? .green : .red
	}
}
