//
//  CustomButton.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/2/25.
//

import UIKit

final class CustomButton: UIButton {

	private var buttonAction: (() -> Void)?

	init(title: String, titleColor: UIColor, action: @escaping () -> Void) {
		super.init(frame: .zero)
		self.buttonAction = action
		setupButton(title: title, titleColor: titleColor)
		addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) {
			super.init(coder: coder)
		}

	private func setupButton(title: String, titleColor: UIColor) {
		self.setTitle(title, for: .normal)
		self.setTitleColor(titleColor, for: .normal)

		self.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
		self.layer.masksToBounds = true
		self.layer.cornerRadius = 10
	}

	@objc private func buttonTapped() {
		buttonAction?()
	}
}
