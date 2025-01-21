//
//  MainViewModel.swift
//  SearchBook
//
//  Created by handnew on 1/15/25.
//
import Foundation
import Combine

final class MainViewModel {
  private let bookService: BookServiceType = BookService()
  @Published var books: [Book] = []
  @Published private var searchQuery = String()
  private var cancellables: Set<AnyCancellable> = []
  private var page = 1

  init() {
    setupSearchBinding()
  }

  private func setupSearchBinding() {
    $searchQuery
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .filter { !$0.isEmpty }
      .filter { $0.count >= 2 }
      .sink { query in
        log.debug("Search query:::: \(query)")
        self.books = []
        self.requestBooks(query: query)
      }
      .store(in: &cancellables)
  }

  private func requestBooks(query: String) {
    bookService.searchBook(query: query, page: page, size: 20)
      .sink(receiveCompletion: { _ in }) { response in
        log.debug("response: \(response)")

        response.documents.forEach { doc in
          self.books.append(doc.toDomain())
        }
      }
      .store(in: &cancellables)
  }

  func searchBook(_ query: String) {
    searchQuery = query
  }

}
