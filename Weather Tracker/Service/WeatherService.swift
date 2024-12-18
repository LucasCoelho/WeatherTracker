//
//  WeatherService.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 17/12/24.
//

import Foundation

struct WeatherService {
    private let apiKey = Bundle.main.infoDictionary!["WEATHER_API_KEY"] as! String
    private let baseUrl = "https://api.weatherapi.com/v1/"

    func search(_ query: String) async throws -> [WeatherInfo] {
        let cities = try await fetchCities(query: query)
        var weatherList: [WeatherInfo] = []

        try await withThrowingTaskGroup(of: WeatherInfo.self) { group in
            for city in cities {
                group.addTask {
                    return try await fetchWeather(for: city)
                }
            }

            for try await weather in group {
                weatherList.append(weather)
            }
        }

        return weatherList
    }

    private func fetchCities(query: String) async throws -> [City] {
        guard let url = URL(string: "\(baseUrl+"search.json")?key=\(apiKey)&q=\(query)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([City].self, from: data)
    }

    func fetchWeather(for city: CityLocation) async throws -> WeatherInfo {
        guard let url = URL(string: "\(baseUrl+"current.json")?key=\(apiKey)&q=\(city.lat),\(city.lon)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Manually parse the JSON response
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard
            let location = json?["location"] as? [String: Any],
            let current = json?["current"] as? [String: Any],
            let condition = current["condition"] as? [String: Any],
            let name = location["name"] as? String,
            let temperature = current["temp_c"] as? Double,
            let conditionText = condition["text"] as? String,
            let icon = condition["icon"] as? String,
            let humidity = current["humidity"] as? Int,
            let uvIndex = current["uv"] as? Double,
            let feelsLike = current["feelslike_c"] as? Double
        else {
            throw URLError(.cannotParseResponse)
        }

        // Return the custom struct
        return WeatherInfo(
            id: city.id,
            name: name,
            temperature: temperature,
            condition: conditionText,
            iconURL: "https:\(icon)",
            humidity: humidity,
            uvIndex: uvIndex,
            feelsLike: feelsLike,
            lat: city.lat,
            lon: city.lon
        )
    }
}
