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

	//Сделаем игру в угадывание слова ограниченной по времени.
	private lazy var playGuessButton = CustomButton(title: "Play \"Guess the word\"!") { [weak self] in
		self?.playButtonTapped()
	}

	private lazy var checkGuessButton = CustomButton(title: "CheckGuess") { [weak self] in
		guard let guessText = self?.guessTextField.text, !guessText.isEmpty else { return }
		self?.viewModel.checkWord(guessText)
	}

	private lazy var showPlayerButton = CustomButton(title: "Music Player") { [weak self] in
		self?.navigateToPlayerVC()
	}

	private lazy var showVideosButton = CustomButton(title: "Videos") { [weak self] in
		self?.navigateToVideosVC()
	}

	private lazy var showAudioRecorderButton = CustomButton(title: "Audio Recorder") { [weak self] in
		self?.navigateToAudioRecVC()
	}

	private let guessTextField: TextField = {
		let field = TextField()
		field.placeholder = "Guess..."
		field.backgroundColor = .white
		field.font = .systemFont(ofSize: 15, weight: .regular)
		field.textColor = .black
		field.layer.cornerRadius = 10
		field.layer.borderWidth = 1
		field.layer.borderColor = UIColor.black.cgColor
		field.isUserInteractionEnabled = true
		field.translatesAutoresizingMaskIntoConstraints = false
		field.isHidden = true
		return field
	}()

	private let resultLabel: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.text = "Result"
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.isHidden = true
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

	private let timerLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red
		label.text = ""
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		label.isHidden = true
		return label
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

	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		viewModel.onResultUpdated = { [weak self] text, color in
			self?.resultLabel.text = text
			self?.resultLabel.textColor = color
		}
		checkGuessButton.isHidden = true

		addSubviews()
		configureStackView()
	}

	//MARK: Layout
	func addSubviews() {
		view.addSubview(postButtonStackView)
		view.addSubview(guessTextField)
		view.addSubview(checkGuessButton)
		view.addSubview(resultLabel)
		view.addSubview(playGuessButton)
		view.addSubview(timerLabel)
		view.addSubview(showPlayerButton)
		view.addSubview(showVideosButton)
		view.addSubview(showAudioRecorderButton)
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


			playGuessButton.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 16),
			playGuessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			playGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			playGuessButton.heightAnchor.constraint(equalToConstant: 50),


			timerLabel.bottomAnchor.constraint(equalTo: guessTextField.topAnchor, constant: -16),
			timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),


			showPlayerButton.topAnchor.constraint(equalTo: postButtonStackView.bottomAnchor, constant: 70),
			showPlayerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			showPlayerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			showPlayerButton.heightAnchor.constraint(equalToConstant: 50),


			showVideosButton.topAnchor.constraint(equalTo: showPlayerButton.bottomAnchor, constant: 10),
			showVideosButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			showVideosButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			showVideosButton.heightAnchor.constraint(equalToConstant: 50),

			showAudioRecorderButton.topAnchor.constraint(equalTo: showVideosButton.bottomAnchor, constant: 10),
			showAudioRecorderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			showAudioRecorderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			showAudioRecorderButton.heightAnchor.constraint(equalToConstant: 50),

		])
	}

	//MARK: User Interaction Methods
	private func navigateToPostViewController(_ post: FeedModel.Post) {
		let postVC = PostViewController()
		postVC.postTitle = post.title
		navigationController?.pushViewController(postVC, animated: true)
	}

	private func navigateToPlayerVC() {
		let playerVC = PlayerViewController()
		navigationController?.pushViewController(playerVC, animated: true)
	}

	private func navigateToVideosVC() {
		let videosVC = VideosViewController()
		navigationController?.pushViewController(videosVC, animated: true)
	}

	private func navigateToAudioRecVC() {
		let audioRecVC = AudioRecViewController()
		navigationController?.pushViewController(audioRecVC, animated: true)
	}

	func playButtonTapped() {
		toggleViews()

		var timeRemaining = 30
		self.timerLabel.text = "Time remaining: \(timeRemaining)"

		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
			guard let self = self else { return }
				timeRemaining -= 1
				self.timerLabel.text = timeRemaining <= 0 ? "Time's up!" : "Time remaining: \(timeRemaining)"
			if timeRemaining == 0 {
				timer.invalidate()
				toggleViews()
			}
		}
	}

	func toggleViews() {
		self.guessTextField.isHidden.toggle()
		self.resultLabel.isHidden.toggle()
		self.checkGuessButton.isHidden.toggle()
		self.playGuessButton.isHidden.toggle()
		self.timerLabel.isHidden.toggle()
		self.postButton1.isHidden.toggle()
		self.postButton2.isHidden.toggle()
	}
}
