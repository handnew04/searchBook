//
//  NetworkError.swift
//  SearchBook
//
//  Created by handnew on 1/8/25.
//

enum NetworkError: Error {
  case tooManyRetries


  var description: String {
    switch self {
    case .tooManyRetries:
      return "Too many try to request"
    }
  }
}
