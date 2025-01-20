//
//  FeedViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 10/13/24.
//

import UIKit

class FeedViewController: UIViewController {

	//MARK: UI elements
	private lazy var postButton1 = CustomButton(title: "Show post") { [weak self] in
		guard let post = self?.viewModel.getPost(at: 0) else { return }
		self?.navigateToPostViewController(post)
	}

	private lazy var postButton2 = CustomButton(title: "Show post") { [weak self] in
		guard let post = self?.viewModel.getPost(at: 1) else { return }
		self?.navigateToPostViewController(post)
	}

	private lazy var checkGuessButton = CustomButton(title: "Check Guess") { [weak self] in
		guard let guessText = self?.guessTextField.text, !guessText.isEmpty else { return }
		self?.viewModel.checkWord(guessText)
	}

	private let guessTextField: TextField = {
		let field = TextField()
		field.placeholder = "Guess..."
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

	//MARK: Model
	var viewModel: FeedViewModel

	//MARK: Initializers
	init(viewModel: FeedViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		viewModel.onResultUpdated = { [weak self] text, color in
			self?.resultLabel.text = text
			self?.resultLabel.textColor = color
		}

		addSubviews()
		configureStackView()
	}

	//MARK: Layout
	func addSubviews() {
		view.addSubview(postButtonStackView)
		view.addSubview(guessTextField)
		view.addSubview(checkGuessButton)
		view.addSubview(resultLabel)
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

	private func navigateToPostViewController(_ post: FeedModel.Post) {
		let postVC = PostViewController()
		postVC.postTitle = post.title
		navigationController?.pushViewController(postVC, animated: true)
	}
}
