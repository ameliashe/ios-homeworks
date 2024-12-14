//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit
import SnapKit
import StorageService

class ProfileHeaderView: UITableViewHeaderFooterView {

	let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "cat")
		imageView.layer.borderWidth = 3
		imageView.layer.borderColor = UIColor.white.cgColor
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.isUserInteractionEnabled = true

		return imageView
	}()

	let fullNameLabel: UILabel = {
		let label = UILabel()
		label.text = "Рыжуля"
		label.font = .systemFont(ofSize: .init(18), weight: .bold)
		label.textColor = .black

		return label
	}()

	let statusLabel: UILabel = {
		let label = UILabel()
		label.text = "Лежу на подоконнике"
		label.font = .systemFont(ofSize: .init(14), weight: .light)
		label.textColor = .gray

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

	func setupConstraints() {
		avatarImageView.snp.makeConstraints { make in
			make.top.leading.equalToSuperview().offset(16)
			make.width.height.equalTo(100)
		}

		fullNameLabel.snp.makeConstraints { make in
			make.top.equalTo(avatarImageView.snp.top).offset(11)
			make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
			make.trailing.equalToSuperview().offset(-16)
		}

		statusLabel.snp.makeConstraints { make in
			make.bottom.equalTo(avatarImageView.snp.bottom).offset(-18)
			make.leading.trailing.equalTo(fullNameLabel)
		}

		statusTextField.snp.makeConstraints { make in
			make.top.equalTo(statusLabel.snp.bottom).offset(8)
			make.leading.trailing.equalTo(fullNameLabel)
			make.height.equalTo(40)
		}

		setStatusButton.snp.makeConstraints { make in
			make.top.equalTo(statusTextField.snp.bottom).offset(8)
			make.leading.equalToSuperview().offset(16)
			make.trailing.equalToSuperview().offset(-16)
			make.height.equalTo(50)
		}

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
