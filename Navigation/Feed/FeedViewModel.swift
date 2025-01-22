//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 1/6/25.
//

import Foundation
import UIKit

final class FeedViewModel {

	private var feedModel: FeedModel

	var onResultUpdated: ((String, UIColor) -> Void)?

	init(model: FeedModel) {
		self.feedModel = model
	}

	func checkWord(_ word: String) {
		feedModel.check(word) { isCorrect in
			let resultText = isCorrect ? "is correct!" : "is wrong!"
			let resultColor = isCorrect ? UIColor.green : UIColor.red
			onResultUpdated?(resultText, resultColor)
		}
	}

	func getPost(at index: Int) -> FeedModel.Post? {
		guard index >= 0 && index < feedModel.posts.count else { return nil }
		return feedModel.posts[index]
	}
}

