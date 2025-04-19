//
//  VideosTableViewCell.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/30/25.
//

import UIKit

class VideosTableViewCell: UITableViewCell {

	let urlLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 17, weight: .medium)
		label.textColor = ColorPalette.customTextColor
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var videoIcon: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "play.rectangle.on.rectangle.fill"))
		imageView.tintColor = .red
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviews()
		setupConstraints()
	}

	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addSubviews() {
		contentView.addSubview(urlLabel)
		contentView.addSubview(videoIcon)
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			videoIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
			videoIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
			videoIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
			videoIcon.widthAnchor.constraint(equalToConstant: 40),

			urlLabel.leadingAnchor.constraint(equalTo: videoIcon.trailingAnchor, constant: 24),
			urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
			urlLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
		])
	}

	func update(_ video: String) {
		urlLabel.text = video
	}

}
