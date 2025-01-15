//
//  BookAPI.swift
//  SearchBook
//
//  Created by handnew on 1/14/25.
//

import Foundation
import Moya
import Combine

typealias ResponsePublisher<T: ModelType> = AnyPublisher<T, Error>

enum BookAPI {
  case searchBook(query: String, page: Int, size: Int)
}

extension BookAPI: TargetType {
  var baseURL: URL { URL(string: "https://dapi.kakao.com/v3/search")! }

  var path: String { return "/book" }

  var method: Moya.Method { return .get }

  var task: Moya.Task {
    switch self {
    case let .searchBook(query, page, size):
      return .requestParameters(parameters: ["query": query, "page": page, "size": size], encoding: URLEncoding.queryString)
    }
  }

  var headers: [String : String]? {
    switch self {
    default:
      return [
        "Accept": "application/json",
        "Content-Type": "application/json",
      ]
    }
  }
}

protocol BookServiceType {
  func searchBook(query: String, page: Int, size: Int) -> ResponsePublisher<BookDTO>
}

final class BookService: BookServiceType {
  let networking: NetworkManager<BookAPI>

  init(networking: NetworkManager<BookAPI> = .init()) {
    self.networking = networking
  }

  func searchBook(query: String, page: Int = 1, size: Int = 20) -> ResponsePublisher<BookDTO> {
    return networking.request(.searchBook(query: query, page: page, size: size))
  }

}
