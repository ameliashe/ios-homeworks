//
//  User.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 12/15/24.
//
import UIKit

class User {
	var login: String
	var fullName: String
	var avatar: UIImage
	var status: String

	init(login: String, fullName: String, avatar: UIImage, status: String) {
		self.login = login
		self.fullName = fullName
		self.avatar = avatar
		self.status = status
	}
}

protocol UserService {

	func getUser(login: String) -> User?

}

class CurrentUserService: UserService {

	private let currentUser = User(
		login: "amelia",
		fullName: "Амелия",
		avatar: UIImage(named: "cat") ?? UIImage(),
		status: "Хеллоу ворлд."
	)

	func getUser(login: String) -> User? {
		return login == currentUser.login ? currentUser : nil
	}

}

class TestUserService: UserService {

	private let testUser = User(
		login: "test",
		fullName: "DEBUG Test User",
		avatar: UIImage(),
		status: "Это тестовый профиль для дебаг схемы."
	)

	func getUser(login: String) -> User? {
		return login == testUser.login ? testUser : nil
	}

}
