//
//  WeatherUserDefaults.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 18/12/24.
//

import Foundation

struct WeatherUserDefaults {
    var defaults = UserDefaults.standard
    private let savedInfo = "SavedWeatherInfo"

    func save(_ cityInfo: WeatherInfo) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cityInfo) {
            defaults.set(encoded, forKey: savedInfo)
        }
    }

    func getStoredWeatherInfo() -> WeatherInfo? {
        if let info = defaults.object(forKey: savedInfo) as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(WeatherInfo.self, from: info)
        }
        return nil
    }
}
