//
//  NewsViewModel.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import Combine
import Foundation

final class NewsViewModelError: ObservableObject {
     var newsAPI = NewsRequestModel.shared

    @Published var indexEndpoint: Int = 0
    @Published var searchString: String = "science"

    @Published var articles = [Article]()
    @Published var articlesError: ErrorRequest?

    private var validString:  AnyPublisher<String, Never> {
        $searchString
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    init(index:Int = 0, text: String = "science") {
        self.indexEndpoint = index
        self.searchString = text
        Publishers.CombineLatest( $indexEndpoint, validString)
        .setFailureType(to: ErrorRequest.self)
        .flatMap {  (indexEndpoint, search) ->
                               AnyPublisher<[Article], ErrorRequest> in
            if 3...30 ~= search.count {
            self.articles = [Article]()
            return self.newsAPI.fetchArticlesErr(from:
                    NewsAPIModel( index: indexEndpoint, text: search)!)
            } else {
                return Just([Article]())
                    .setFailureType(to: ErrorRequest.self)
                    .eraseToAnyPublisher()
            }
        }
        .sink(
            receiveCompletion:  {[unowned self] (completion) in
            if case let .failure(error) = completion {
                self.articlesError = error
            }},
              receiveValue: { [unowned self] in
                self.articles = $0
        })
        .store(in: &self.cancellableSet)
    }
    private var cancellableSet: Set<AnyCancellable> = []
}
