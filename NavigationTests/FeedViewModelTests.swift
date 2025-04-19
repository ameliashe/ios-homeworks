//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by Amelia Romanova on 4/17/25.
//

import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {

	func testCheckWordCorrect() {
		let model = MockFeedModel(validWord: "apple")
		let viewModel = FeedViewModel(model: model)
		let exp = expectation(description: "onResultUpdated called")

		viewModel.onResultUpdated = { text, color in
			XCTAssertEqual(text, "– is correct!")
			XCTAssertEqual(color, .green)
			exp.fulfill()
		}

		viewModel.checkWord("apple")
		wait(for: [exp], timeout: 1)
	}

	func testCheckWordIncorrect() {
		let model = MockFeedModel(validWord: "apple")
		let viewModel = FeedViewModel(model: model)
		let exp = expectation(description: "onResultUpdated called")

		viewModel.onResultUpdated = { text, color in
			XCTAssertEqual(text, "– is wrong!")
			XCTAssertEqual(color, .red)
			exp.fulfill()
		}

		viewModel.checkWord("iphone")
		wait(for: [exp], timeout: 1)
	}

	func testGetPostValidIndex() {
		let post = FeedModel.Post(title: "Test")
		let model = MockFeedModel(validWord: "apple")
		model.posts = [post]

		let viewModel = FeedViewModel(model: model)
		let result = viewModel.getPost(at: 0)

		XCTAssertNotNil(result)
		XCTAssertEqual(result?.title, "Test")

	}

	func testGetPostsInvalidIndex() {
		let post = FeedModel.Post(title: "Test")
		let model = MockFeedModel(validWord: "apple")
		model.posts = [post]

		let viewModel = FeedViewModel(model: model)
		let result = viewModel.getPost(at: 4)

		XCTAssertNil(result)
	}
}

final class MockFeedModel: FeedModel {

	public struct Post {
		let title: String
	}

	private var validWord: String

	init(validWord: String) {
		self.validWord = validWord
		super.init()
	}


	override func check(_ word: String, completion: (Bool) -> Void) {
		print("MockFeedModel.check called with word: \(word)")
		let isCorrect = (word == validWord) ? true : false
		completion(isCorrect)
	}
}
