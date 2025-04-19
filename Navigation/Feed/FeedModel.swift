//
//  FeedModel.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/4/25.
//

import Foundation

class FeedModel {

	public struct Post {
		let title: String
	}

	var posts: [Post] = [
		Post(title: NSLocalizedString("This is the first post!", comment: "Test post 1 title")),
		Post(title: NSLocalizedString("This is the second post!", comment: "Test post 2 title"))
	]

	var secretWord: String = "block"

	func check(_ word: String, completion: (Bool) -> Void) {
		let isCorrect = word == secretWord
		completion(isCorrect)
	}
}

extension Notification.Name {
	static let secretWordChecked = Notification.Name(rawValue: "secretWordChecked")
}
