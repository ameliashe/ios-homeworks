//
//  Planet.swift
//  Navigation
//
//  Created by Amelia Romanova on 2/6/25.
//

import Foundation

@propertyWrapper
struct StringDecodable<Wrapped: LosslessStringConvertible>: Decodable {
	let wrappedValue: Wrapped

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let string = try container.decode(String.self)

		if let value = Wrapped(string) {
			wrappedValue = value
		} else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "Value \(string) is not convertible to \(Wrapped.self)"
			)
		}
	}
}

struct Planet: Decodable {
	let name: String
	@StringDecodable var rotationPeriod: Int
	@StringDecodable var orbitalPeriod: Int
	@StringDecodable var diameter: Int
	let climate: String
	let gravity: String
	let terrain: String
	@StringDecodable var surfaceWater: Int
	@StringDecodable var population: Int

	enum CodingKeys: String, CodingKey {
		case name
		case rotationPeriod = "rotation_period"
		case orbitalPeriod = "orbital_period"
		case diameter
		case climate
		case gravity
		case terrain
		case surfaceWater = "surface_water"
		case population
	}

}
