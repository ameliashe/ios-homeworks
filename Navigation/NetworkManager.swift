//
//  NetworkManager.swift
//  Navigation
//
//  Created by Amelia Romanova on 2/1/25.
//

import Foundation

enum AppConfiguration {
	case people(URL)
	case planets(URL)
	case films(URL)
}

struct NetworkManager {
	

	static func request(for configuration: AppConfiguration) {

		let session = URLSession.shared
		let url: URL

		switch configuration {
		case .people(let configURL):
			url = configURL
			print("Config selected: \(configURL)")
		case .films(let configURL):
			url = configURL
			print("Config selected: \(configURL)")
		case .planets(let configURL):
			url = configURL
			print("Config selected: \(configURL)")
			   }
		
		let task = session.dataTask(with: url) { data, response, error in
			if error != nil {
				print(error!.localizedDescription)
				return
			}

			guard let httpResponse = response as? HTTPURLResponse else {
				print("Error: response is invalid")
				return
			}

			print("Status code: \(httpResponse.statusCode)")
			print("Response header: \(httpResponse.allHeaderFields)")

			if let data = data, let jsonString = String(data: data, encoding: .utf8) {
				print("Data recieved: \n\(jsonString)")
			}
		}
		task.resume()
	}


//	При отключенном интернете выводится сообщение: "The Internet connection appears to be offline."

}
