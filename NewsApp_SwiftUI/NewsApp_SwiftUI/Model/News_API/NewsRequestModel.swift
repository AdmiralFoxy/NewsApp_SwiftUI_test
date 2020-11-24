//
//  NewsRequestModel.swift
//  NewsApp_SwiftUI
//
//  Created by Stanislav Avramenko on 23.11.2020.
//

import Foundation
import Combine

class NewsRequestModel {
    static let shared = NewsRequestModel()

     func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
                   URLSession.shared.dataTaskPublisher(for: url)
                    .map { $0.data}
                    .decode(type: T.self, decoder: NewsAPI.jsonDecoder)
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
    }

    func fetchErr<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
               URLSession.shared.dataTaskPublisher(for: url)
               .tryMap { (data, response) -> Data in
                   guard let httpResponse = response as? HTTPURLResponse,
                        200...299 ~= httpResponse.statusCode else {
                   throw ErrorRequest.responseError(
                        ((response as? HTTPURLResponse)?.statusCode ?? 500,
                            String(data: data, encoding: .utf8) ?? ""))
                        }
                   return data
               }
                .decode(type: T.self, decoder: NewsAPI.jsonDecoder)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }

     func fetchArticles(from endpoint: NewsAPIModel)
                                     -> AnyPublisher<[Article], Never> {
         guard let url = endpoint.absoluteURL else {
                     return Just([Article]()).eraseToAnyPublisher()
         }
         return fetch(url)
             .map { (response: NewsResponse) -> [Article] in
                             return response.articles }
                .replaceError(with: [Article]())
                .eraseToAnyPublisher()
     }

       func fetchArticlesErr(from endpoint: NewsAPIModel) ->
                                           AnyPublisher<[Article], ErrorRequest>{
           Future<[Article], ErrorRequest> { [unowned self] promise in

               guard let url = endpoint.absoluteURL  else {
                   return promise(
                       .failure(.urlError(URLError(.unsupportedURL))))
               }
               self.fetchErr(url)
                 .tryMap { (result: NewsResponse) -> [Article] in
                         result.articles }
                  .sink(
                   receiveCompletion: { (completion) in
                       if case let .failure(error) = completion {
                           switch error {
                           case let urlError as URLError:
                               promise(.failure(.urlError(urlError)))
                           case let decodingError as DecodingError:
                               promise(.failure(.decodingError(decodingError)))
                           case let apiError as ErrorRequest:
                               promise(.failure(apiError))
                           default:
                               promise(.failure(.genericError))
                           }
                       }
                   },
                   receiveValue: { promise(.success($0)) })
                .store(in: &self.subscriptions)
           }
           .eraseToAnyPublisher()
       }

    private var subscriptions = Set<AnyCancellable>()
}
