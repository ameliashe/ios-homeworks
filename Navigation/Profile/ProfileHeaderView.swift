//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit

class ProfileHeaderView: UIView {

    let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "cat")
		imageView.layer.cornerRadius = 50
		imageView.layer.borderWidth = 3
		imageView.layer.borderColor = UIColor.white.cgColor
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}()

	let nameLabel: UILabel = {
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

	let changeStatusField: TextField = {
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


	private func setupView() {
		addSubview(profileImageView)
		addSubview(nameLabel)
		addSubview(statusLabel)
		addSubview(setStatusButton)
		addSubview(changeStatusField)

		changeStatusField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
		setStatusButton.addTarget(self, action: #selector(setStatusTapped), for: .touchUpInside)

		setupConstraints()
	}


	override init(frame: CGRect) {
		 super.init(frame: frame)
		 setupView()
	 }

	 required init?(coder: NSCoder) {
		 super.init(coder: coder)
		 setupView()
	 }

	private func setupConstraints() {

		NSLayoutConstraint.activate([
			profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			profileImageView.widthAnchor.constraint(equalToConstant: 100),
			profileImageView.heightAnchor.constraint(equalToConstant: 100),

			nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 11),
			nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

			statusLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -18),
			statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
			statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

			changeStatusField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
			changeStatusField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
			changeStatusField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
			changeStatusField.heightAnchor.constraint(equalToConstant: 40),

			setStatusButton.topAnchor.constraint(equalTo: changeStatusField.bottomAnchor, constant: 8),
			setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			setStatusButton.heightAnchor.constraint(equalToConstant: 50)
		])
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
