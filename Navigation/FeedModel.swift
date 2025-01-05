//
//  FeedModel.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/4/25.
//

import Foundation

final class FeedModel {
	var secretWord: String = "block"
	
	func check(_ word: String) {
		let isCorrect = word == secretWord
		NotificationCenter.default.post(name: .secretWordChecked, object: nil, userInfo: ["isCorrect": isCorrect])
	}
}

extension Notification.Name {
	static let secretWordChecked = Notification.Name(rawValue: "secretWordChecked")
}
