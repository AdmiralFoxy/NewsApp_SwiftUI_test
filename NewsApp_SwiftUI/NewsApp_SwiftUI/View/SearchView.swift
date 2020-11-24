//
//  SearchView.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import SwiftUI

struct SearchView: View {

    @Binding var searchTerm: String

    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "magnifyingglass")

            TextField("Search", text: self.$searchTerm)
                .font(.body)
                .foregroundColor(Color.primary)
                .padding(10)
                
            Spacer()
        }.foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(10)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchTerm: .constant("science"))
    }
}
