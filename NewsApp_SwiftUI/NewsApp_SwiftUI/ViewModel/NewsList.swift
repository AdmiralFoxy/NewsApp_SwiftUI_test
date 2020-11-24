//
//  NewsList.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import SwiftUI
import SafariServices

struct ArticlesList: View {
    var articles: [Article]

    @State var showSafari = false
    @State var articleURL: URL?
    var body: some View {
        List {
           ForEach(articles) { article in
            Group {
                VStack(alignment: .leading, spacing: 7.0) {
                    NavigationLink(" ", destination: SafariView(url: URL(string: article.url!)!))
                    ArticleImage(imageLoader: ImageLoaderCache.shared.loaderFor(article: article))
                        .padding(-9.0)
                    Spacer(minLength: 20)
                    HStack {
                        Text("\(article.title)").font(.headline).fontWeight(.semibold).lineLimit(2)
                        Spacer()
                        Text(NewsAPI.formatter.string(from: article.publishedAt!))
                    }
                    Spacer()
                    Text("\(article.source.name != nil ? article.source.name! : "")")
                    Spacer(minLength: 10)
                    Text("\( article.description != nil ? article.description! : "")")
                        .font(.footnote)
                        .lineLimit(12)
                    Button(
                                action: {
                                    self.articleURL = URL(string: article.url!)
                                    self.showSafari = true
                                },
                                label: {
                                    Text("\(article.url != nil ? " " : "")")
                                    .foregroundColor(Color.blue)
                                }).sheet(isPresented: $showSafari) {
                                    SafariView(url: ((self.articleURL ?? URL(string: "https://apple.slashdot.org/story/20/11/23/2245242/apple-makes-another-concession-on-app-store-fees"))!))
                }
                .foregroundColor(Color.black)
            }
           }
           }
        }
    }
}

let calendar = Calendar.current
let components1 = DateComponents(calendar: calendar, year: 2020, month: 1, day: 23)
let sampleArticle1 = Article (title: "111", description: "222", author: "333", urlToImage: "https://fainaidea.com/wp-content/uploads/2019/06/acastro_190322_1777_apple_streaming_0003.0.jpg", publishedAt: calendar.date(from: components1)!, source: Source(id: "google", name: "apple", description: "", country: "ua", category: "general", url: "https://google.com"), url: "null")
struct ArticlesList_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesList(articles: [sampleArticle1])
    }
}
