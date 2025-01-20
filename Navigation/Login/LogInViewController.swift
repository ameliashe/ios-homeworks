//
//  LogInViewController.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 11/5/24.
//

import UIKit

class LogInViewController: UIViewController {

	//MARK: LoginService

#if DEBUG
		let activeUserService = TestUserService()
#else
		let activeUserService = CurrentUserService()
#endif

	var loginDelegate: LoginViewControllerDelegate? = nil

	//MARK: UI Elements
	lazy var credentialsStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [usernameTextField, separatorView, passwordTextField])
		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.distribution = .fill
		stackView.layer.cornerRadius = 10
		stackView.layer.borderColor = UIColor.black.cgColor
		stackView.layer.borderWidth = 0.5
		stackView.layer.borderColor = UIColor.lightGray.cgColor
		stackView.layer.masksToBounds = true
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	let usernameTextField: TextField = {
		let textField = TextField()
		textField.placeholder = "Email or phone"
		textField.backgroundColor = .systemGray6
		textField.text = "amelia"
		textField.textColor = .black
		textField.font = .systemFont(ofSize: 16)
		textField.tintColor = UIColor(named: "VKColor")
		textField.isUserInteractionEnabled = true
		textField.autocapitalizationType = .none
		return textField
	}()

	let passwordTextField: TextField = {
		let textField = TextField()
		textField.placeholder = "Password"
		textField.text = "123123"
		textField.backgroundColor = .systemGray6
		textField.textColor = .black
		textField.font = .systemFont(ofSize: 16)
		textField.tintColor = UIColor(named: "VKColor")
		textField.isUserInteractionEnabled = true
		textField.autocapitalizationType = .none
		textField.isSecureTextEntry = true
		return textField
	}()

	let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .lightGray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()

	let contentView: UIView = {
		   let view = UIView()
		   view.translatesAutoresizingMaskIntoConstraints = false
		   return view
	   }()

	let logoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "logo-2")
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private lazy var loginButton = CustomButton(title: "Log In") { [weak self] in
		self?.loginButtonTapped()
	}

	private lazy var guessPasswordButton = CustomButton(title: "Guess Password") { [weak self] in
		
	}

	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		viewSetup()
		layoutConstraintsSetup()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		setupKeyboardObservers()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		removeKeyboardObservers()
	}

	//MARK: UI Setup
	func viewSetup() {
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = .white

		contentView.addSubview(logoImageView)
		contentView.addSubview(credentialsStackView)
		contentView.addSubview(loginButton)

		scrollView.addSubview(contentView)
		view.addSubview(scrollView)
	}

	func layoutConstraintsSetup() {
		NSLayoutConstraint.activate([
			logoImageView.widthAnchor.constraint(equalToConstant: 100),
			logoImageView.heightAnchor.constraint(equalToConstant: 100),
			logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
			logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

			credentialsStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
			credentialsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			credentialsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			credentialsStackView.heightAnchor.constraint(equalToConstant: 100),

			loginButton.heightAnchor.constraint(equalToConstant: 50),
			loginButton.topAnchor.constraint(equalTo: credentialsStackView.bottomAnchor, constant: 16),
			loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),


			usernameTextField.leadingAnchor.constraint(equalTo: credentialsStackView.leadingAnchor),
			usernameTextField.trailingAnchor.constraint(equalTo: credentialsStackView.trailingAnchor),
			usernameTextField.heightAnchor.constraint(equalToConstant: 50),

			passwordTextField.leadingAnchor.constraint(equalTo: credentialsStackView.leadingAnchor),
			passwordTextField.trailingAnchor.constraint(equalTo: credentialsStackView.trailingAnchor),
			passwordTextField.heightAnchor.constraint(equalToConstant: 50),


			separatorView.leadingAnchor.constraint(equalTo: credentialsStackView.leadingAnchor),
			separatorView.trailingAnchor.constraint(equalTo: credentialsStackView.trailingAnchor),
			separatorView.heightAnchor.constraint(equalToConstant: 0.5),

			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),


			loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
		])
	}

	//MARK: Keyboard
	private func setupKeyboardObservers() {
		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(
			self,
			selector: #selector(self.willShowKeyboard(_:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		notificationCenter.addObserver(
			self,
			selector: #selector(self.willHideKeyboard(_:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	private func removeKeyboardObservers() {
		let notificationCenter = NotificationCenter.default
		notificationCenter.removeObserver(self)
	}

	@objc func willShowKeyboard(_ notification: NSNotification) {
		let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
		scrollView.contentInset.bottom += keyboardHeight ?? 0.0
	}

	@objc func willHideKeyboard(_ notification: NSNotification) {
		scrollView.contentInset.bottom = 0.0
	}

	//MARK: User Interaction Methods
	func loginButtonTapped() {
		guard let login = usernameTextField.text, let password = passwordTextField.text, !login.isEmpty else {
			showErrorAlert(message: "Введите логин/пароль!")
			return
		}
		guard loginDelegate?.check(login: login, password: password) == true else {
			showErrorAlert(message: "Неверный логин/пароль!")
			return
		}
		if let user = activeUserService.getUser(login: login) {
			let profileViewController = ProfileViewController()
			profileViewController.user = user
			navigationController?.pushViewController(profileViewController, animated: true)
		} else {
			showErrorAlert(message: "Неверный логин!")
		}
	}

	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}

protocol LoginViewControllerDelegate {

	func check(login: String, password: String) -> Bool

}

struct LoginInspector: LoginViewControllerDelegate {

	func check(login: String, password: String) -> Bool {
		Checker.shared.check(inputLogin: login, inputPassword: password)
	}
}
