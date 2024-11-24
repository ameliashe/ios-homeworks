//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {

	let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "cat")
		imageView.layer.borderWidth = 3
		imageView.layer.borderColor = UIColor.white.cgColor
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.isUserInteractionEnabled = true

		return imageView
	}()

	let fullNameLabel: UILabel = {
		let label = UILabel()
		label.text = "Рыжуля"
		label.font = .systemFont(ofSize: .init(18), weight: .bold)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	let statusLabel: UILabel = {
		let label = UILabel()
		label.text = "Лежу на подоконнике"
		label.font = .systemFont(ofSize: .init(14), weight: .light)
		label.textColor = .gray
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	let setStatusButton: UIButton = {
		let button = UIButton()
		button.setTitle("Show status", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = 4
		button.layer.shadowColor = UIColor.black.cgColor
		button.layer.shadowOffset = .init(width: 4, height: 4)
		button.layer.shadowRadius = 4
		button.layer.shadowOpacity = 0.7
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	let statusTextField: TextField = {
		let field = TextField()
		field.placeholder = "Change status"
		field.backgroundColor = .white
		field.font = .systemFont(ofSize: .init(15), weight: .regular)
		field.textColor = .black
		field.layer.cornerRadius = 12
		field.layer.borderWidth = 1
		field.layer.borderColor = UIColor.black.cgColor
		field.isUserInteractionEnabled = true
		field.translatesAutoresizingMaskIntoConstraints = false
		return field
	}()

	var avatarTapped: (() -> Void)?

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)

		addSubviews()
		setupConstraints()
		configureStatusChange()
		configureAvatarTap()
	}

	 required init?(coder: NSCoder) {
		 super.init(coder: coder)
	 }

	override func layoutSubviews() {
		super.layoutSubviews()
		avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
	}

	private func addSubviews() {
		addSubview(avatarImageView)
		addSubview(fullNameLabel)
		addSubview(statusLabel)
		addSubview(setStatusButton)
		addSubview(statusTextField)
	}

	func configureStatusChange() {
		statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
		setStatusButton.addTarget(self, action: #selector(setStatusTapped), for: .touchUpInside)
	}

	private func setupConstraints() {

		NSLayoutConstraint.activate([
			avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			avatarImageView.widthAnchor.constraint(equalToConstant: 100),
			avatarImageView.heightAnchor.constraint(equalToConstant: 100),

			fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 11),
			fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
			fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

			statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18),
			statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
			statusLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),

			statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
			statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
			statusTextField.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
			statusTextField.heightAnchor.constraint(equalToConstant: 40),

			setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 8),
			setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			setStatusButton.heightAnchor.constraint(equalToConstant: 50)
		])
	}

	func configureAvatarTap() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTappedAction))
			avatarImageView.addGestureRecognizer(tapGesture)
	}

	private var statusText: String = "Лежу на подоконнике"

	@objc private func statusTextChanged(_ textField: UITextField) {
		  statusText = textField.text ?? ""
		print("Status text changed: \(statusText)")
	  }

	@objc private func setStatusTapped() {
		print("Button pressed. Setting status to: \(statusText)")
			statusLabel.text = statusText
		}

	@objc private func avatarTappedAction() {
		avatarTapped?()
	}
}

class TextField: UITextField {

	let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
}
