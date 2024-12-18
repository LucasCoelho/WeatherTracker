//
//  ContentView.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 17/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        content
            .ignoresSafeArea(edges: [.bottom])
            .onChange(of: viewModel.selectedCity) {
                if let city = viewModel.selectedCity {
                    viewModel.persist(city)
                }
            }
    }

    @ViewBuilder private var content: some View {
        VStack {
            TextFieldWithDebounce(debouncedText: $viewModel.debouncedText)
                .padding(.bottom, 20)

            switch viewModel.viewState {
            case .loading:
                loadingView
            case .failed:
                errorView
            case .success, .idle:
                if viewModel.selectedCity != nil {
                    DetailView(cityInfo: $viewModel.selectedCity)
                } else {
                    if viewModel.debouncedText.isEmpty {
                        emptyView
                    } else {
                        listView
                    }
                }
            }
        }
        .onChange(of: viewModel.debouncedText) {
            withAnimation {
                viewModel.selectedCity = nil
            }

            if viewModel.debouncedText.count > 1 {
                Task {
                    await viewModel.search(viewModel.debouncedText)
                }
            }
        }
        .padding()
    }

    private var listView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.cityList) { city in
                    CityRow(city: city)
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectedCity = city
                            }
                        }
                }
            }
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
            Spacer()
        }
    }

    private var errorView: some View {
        VStack {
            Spacer()
            Text("Something went wrong")
                .foregroundStyle(.red)
            Spacer()
            Spacer()
        }
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Spacer()

            Text("No City Selected")
                .font(.custom(Poppins.semibold, size: 30))
            Text("Please Search For A City")
                .font(.custom(Poppins.semibold, size: 15))

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
