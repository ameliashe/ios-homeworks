//
//  Parser.swift
//  Navigation
//
//  Created by Amelia Romanova on 2/1/25.
//

import Foundation

class Parser {
	static func parseTask(_ data: Data) -> TodoTask? {
		do {
			let answer = try JSONSerialization.jsonObject(with: data) as! [String: Any]
			let userId = answer["userId"] as! Int
			let id = answer["id"] as! Int
			let title = answer["title"] as! String
			let completed = answer["completed"] as! Bool

			let todoTask = TodoTask(userId: userId, id: id, title: title, completed: completed)
			return todoTask

		} catch {
			print(error.localizedDescription)
		}
		return nil
	}

	static func decodePlanet(_ data: Data) -> Planet? {
		do {
			let answer = try JSONDecoder().decode(Planet.self, from: data)
			return answer
		} catch {
			print(error.localizedDescription)
		}
		return nil
	}
}
