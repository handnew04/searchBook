//
//  BookAPI.swift
//  SearchBook
//
//  Created by handnew on 1/17/25.
//
import Foundation
import Combine
import Moya

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
