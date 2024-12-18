//
//  City.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 17/12/24.
//

import Foundation

struct City: Codable, CityLocation {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime: String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}
