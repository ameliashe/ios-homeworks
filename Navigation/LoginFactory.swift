//
//  LoginFactory.swift
//  Navigation
//
//  Created by Amelia Romanova on 12/30/24.
//

import Foundation

protocol LoginFactory {
	func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
	func makeLoginInspector() -> LoginInspector {
		return LoginInspector()
	}
}
