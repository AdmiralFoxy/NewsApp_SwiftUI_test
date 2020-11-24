//
//  NetRequest.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import Foundation

enum NewsAPIModel {
    case topHeadLines
    case articlesFromCategory(_ category: String)
    case search (searchFilter: String)

    var baseURL:URL {URL(string: "https://newsapi.org/v2/")!}

    func path() -> String {
        switch self {
        case .topHeadLines, .articlesFromCategory:
            return "top-headlines"
        case .search:
            return "everything"
        }
    }

    var absoluteURL: URL? {
        let queryURL = baseURL.appendingPathComponent(self.path())
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else {
            return nil
        }
        switch self {
        case .topHeadLines:
            urlComponents.queryItems = [URLQueryItem(name: "country", value: region),
                                        URLQueryItem(name: "apikey", value: NewsAPI.apiKey)
                                       ]
        case .articlesFromCategory(let category):
            urlComponents.queryItems = [URLQueryItem(name: "country", value: region),
                                        URLQueryItem(name: "category", value: category),
                                        URLQueryItem(name: "apikey", value: NewsAPI.apiKey)
                                        ]
        case .search (let searchFilter):
            urlComponents.queryItems = [URLQueryItem(name: "q", value: searchFilter.lowercased()),
                                       /*URLQueryItem(name: "language", value: locale),*/
                                       /* URLQueryItem(name: "country", value: region),*/
                                        URLQueryItem(name: "apikey", value: NewsAPI.apiKey)
                                      ]
        }
        return urlComponents.url
    }

    var region: String {
        return "ua"
    }

    init? (index: Int, text: String = "science") {
        switch index {
        case 0: self = .topHeadLines
        case 1: self = .search(searchFilter: text)
        case 2: self = .articlesFromCategory(text)
        default: return nil
        }
    }
}
