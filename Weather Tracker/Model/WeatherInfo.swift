//
//  WeatherInfo.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 17/12/24.
//

import Foundation

struct WeatherInfo: Identifiable, Codable, Equatable, CityLocation {
    let id: Int
    let name: String
    let temperature: Double
    let condition: String
    let iconURL: String
    let humidity: Int
    let uvIndex: Double
    let feelsLike: Double
    let lat: Double
    let lon: Double
}
