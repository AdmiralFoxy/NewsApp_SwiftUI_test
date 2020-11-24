//
//  NewsAPI.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import Foundation

struct NewsAPI {
    static let apiKey: String = "50fd00f4b12846bf9ac11dd52f93912d"

    static let jsonDecoder: JSONDecoder = {
     let jsonDecoder = JSONDecoder()
     jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
     jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
      return jsonDecoder
    }()

     static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
