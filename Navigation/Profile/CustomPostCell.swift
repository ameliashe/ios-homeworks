//
//  CustomPostCell.swift
//  Navigation
//
//  Created by Amelia Romanova on 11/14/24.
//

import UIKit
import StorageService

class CustomPostCell: UITableViewCell {

	let authorLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .bold)
		label.textColor = .black
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = .systemGray
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let likesLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let viewsLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textColor = .black
		label.textAlignment = .right
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let attachedImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.backgroundColor = .black
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		addSubviews()
		setupConstraints()
		tuneView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	func addSubviews() {
		contentView.addSubview(authorLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(likesLabel)
		contentView.addSubview(viewsLabel)
		contentView.addSubview(attachedImageView)
	}

	func setupConstraints() {

		NSLayoutConstraint.activate([
			authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			attachedImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
			attachedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			attachedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			attachedImageView.heightAnchor.constraint(equalTo: attachedImageView.widthAnchor),

			descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			descriptionLabel.topAnchor.constraint(equalTo: attachedImageView.bottomAnchor, constant: 16),

			likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
			likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

			viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
			viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)

		])
	}

	func tuneView() {
		contentView.backgroundColor = .white
		accessoryType = .none
	}

	func update(_ model: Post) {
		authorLabel.text = model.author
		descriptionLabel.text = model.description
		attachedImageView.image = UIImage(named: model.image)
		let textLikes = String(
			format: NSLocalizedString("%d likes", comment: "Number of likes"),
			model.likes
		)
		likesLabel.text = textLikes

		let textViews = String(
			format: NSLocalizedString("%d views", comment: "Number of views"),
			model.views
		)
		viewsLabel.text = textViews
	}

}
