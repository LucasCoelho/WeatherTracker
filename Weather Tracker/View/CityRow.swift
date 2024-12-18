//
//  CityRow.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 18/12/24.
//

import SwiftUI

struct CityRow: View {
    let city: WeatherInfo

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text(city.name)
                    .font(.custom(Poppins.bold, size: 20))
                HStack(alignment: .top) {
                    Text(String(city.temperature))
                        .font(.custom(Poppins.semibold, size: 60))
                    Text("º")
                        .font(.custom(Poppins.medium, size: 20))
                }
            }
            .frame(width: 200)

            Spacer()

            AsyncImage(url: URL(string: city.iconURL), scale: 0.5)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        .background(Color("weatherGray"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

