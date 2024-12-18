//
//  DetailView.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 18/12/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var cityInfo: WeatherInfo?

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }

    var body: some View {
        HStack {
            Spacer()
            Button {
                cityInfo = nil
            } label: {
                Image(systemName: "multiply")
                    .scaleEffect(1.5)
            }
            .foregroundStyle(Color("copyTertiary"))
        }
        .padding(.horizontal)

        VStack(spacing: 0) {
            AsyncImage(url: URL(string: cityInfo?.iconURL ?? ""), scale: 0.3)
                .padding(.top)
                .padding(.bottom, 24)

            HStack {
                Text(cityInfo?.name ?? "n/a")
                    .font(.custom(Poppins.bold, size: 30))
                Image(systemName: "location.fill")
            }
            .padding(.bottom, 24)

            HStack(alignment: .top) {
                Text(String(cityInfo?.temperature ?? 0))
                    .font(.custom(Poppins.medium, size: 70))
                Text("º")
                    .font(.custom(Poppins.medium, size: 20))
            }
            .padding(.bottom, 35)

            HStack(alignment: .center) {
                pieceOfInfo(title: "Humidity", value: NSNumber(integerLiteral: cityInfo?.humidity ?? 0), unit: "%")
                Spacer()
                pieceOfInfo(title: "UV", value: NSNumber(floatLiteral: cityInfo?.uvIndex ?? 0), unit: "")
                Spacer()
                pieceOfInfo(title: "Feels Like", value: NSNumber(floatLiteral: cityInfo?.feelsLike ?? 0), unit: "º")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("weatherGray"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 50)

            Spacer()
        }
        .onTapGesture {
            cityInfo = nil
        }
    }

    private func pieceOfInfo(title: String, value: NSNumber, unit: String) -> some View {
        VStack {
            Text(title)
                .foregroundStyle(Color("copyTertiary"))
                .font(.custom(Poppins.semibold, size: 12))
            Text((numberFormatter.string(from: value) ?? "n/a") + unit)
                .foregroundStyle(Color("copySecondary"))
                .font(.custom(Poppins.semibold, size: 15))
        }
    }
}

#Preview {
    DetailView(cityInfo: .constant(WeatherInfo(id: 1234, name: "New York", temperature: 40, condition: "Rainy", iconURL: "", humidity: 30, uvIndex: 6, feelsLike: 42, lat: 0, lon: 0)))
}
