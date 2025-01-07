//
//  FeedModel.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/4/25.
//

import Foundation

final class FeedModel {

	public struct Post {
		let title: String
	}

	var posts: [Post] = [
		Post(title: "This is the first post!"),
		Post(title: "This is the second post!")
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
