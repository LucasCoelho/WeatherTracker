//
//  TextFieldWithDebounce.swift
//  Weather Tracker
//
//  Created by Lucas Coelho on 17/12/24.
//

import SwiftUI
import Combine

class TextFieldObserver: ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""

    private var subscriptions = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}

struct TextFieldWithDebounce: View {
    @Binding var debouncedText: String
    @StateObject private var textObserver = TextFieldObserver()
    
    var body: some View {
    
        HStack {
            TextField("Search", text: $textObserver.searchText)
                .font(.custom(Poppins.regular, size: 14))
                .padding(.leading, 15)
                .padding(.vertical)
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .padding(.trailing, 15)
                .foregroundStyle(Color("copyTertiary"))
        }
        .background(Color("weatherGray"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onReceive(textObserver.$debouncedText) { (val) in
            debouncedText = val
        }
    }
}
