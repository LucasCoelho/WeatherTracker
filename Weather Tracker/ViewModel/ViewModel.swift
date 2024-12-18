//
//  ViewModel.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 18/12/24.
//

import Foundation

enum ViewState {
    case idle, loading, success, failed
}

@Observable class ViewModel {
    var viewState = ViewState.idle
    var cityList = [WeatherInfo]()
    var debouncedText = ""
    var selectedCity: WeatherInfo?

    @ObservationIgnored
    let service = WeatherService()

    init() {
        if let city = WeatherUserDefaults().getStoredWeatherInfo() {
            Task { await get(cityInfo: city) }
        }
    }

    @MainActor func search(_ text: String) async {
        viewState = .loading
        do {
            cityList = try await service.search(text)
            viewState = .success
        } catch {
            viewState = .failed
        }
    }

    @MainActor
    func get(cityInfo: WeatherInfo) async {
        viewState = .loading

        do {
            selectedCity = try await service.fetchWeather(for: cityInfo)
            viewState = .success
        } catch {
            viewState = .failed
        }
    }

    func persist(_ cityInfo: WeatherInfo) {
        WeatherUserDefaults().save(cityInfo)
    }
}
