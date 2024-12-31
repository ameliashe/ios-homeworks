//
//  Checker.swift
//  Navigation
//
//  Created by Amelia Romanova on 12/21/24.
//

import Foundation

class Checker {

	private let login: String = "amelia"
	private let password = "123123"

	static let shared: Checker = {
		let checker = Checker()
		return checker
	}()

	private init() {}

	func check(inputLogin: String, inputPassword: String) -> Bool {
		inputLogin == login && inputPassword == password
	}

}
