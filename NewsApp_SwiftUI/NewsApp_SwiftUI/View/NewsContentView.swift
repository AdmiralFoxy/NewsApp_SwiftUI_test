//
//  NewsContentView.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import SwiftUI

struct NewsContentView: View {
    @ObservedObject var newsViewModelError = NewsViewModelError()

    var body: some View {
        VStack {
            SearchView(searchTerm: self.$newsViewModelError.searchString)
                .gesture(TapGesture().onEnded({ _ in
                    newsViewModelError.indexEndpoint = 1
                }))

            Picker("", selection: $newsViewModelError.indexEndpoint){
                Text("Top HeadLines").tag(0)
                Text("Category").tag(2)
            }.pickerStyle(SegmentedPickerStyle())

            if newsViewModelError.indexEndpoint == 2 {
                Picker("", selection: $newsViewModelError.searchString){
                           Text("Sports").tag("sports")
                           Text("Health").tag("health")
                           Text("Science").tag("science")
                           Text("Business").tag("business")
                           Text("Technology").tag("technology")
                       }
                       .onAppear(perform: {
                         self.newsViewModelError.searchString = "science"
                       })
                       .pickerStyle(SegmentedPickerStyle())
            }
               ArticlesList(articles: newsViewModelError.articles)
        }
            .alert(item: self.$newsViewModelError.articlesError) { error in
                    Alert(
                       title: Text("Network error"),
                       message: Text(error.localizedDescription).font(.subheadline),
                       dismissButton: .default(Text("OK"))
                     )
        }
    }
}

struct NewsContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewsContentView()
    }
}
