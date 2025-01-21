//
//  BookAPI.swift
//  SearchBook
//
//  Created by handnew on 1/14/25.
//

import Foundation
import Moya
import Combine

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
