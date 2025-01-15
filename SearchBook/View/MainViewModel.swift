//
//  MainViewModel.swift
//  SearchBook
//
//  Created by handnew on 1/15/25.
//
import Combine

final class MainViewModel {
  private let bookService: BookServiceType = BookService()

  private var cancellables: Set<AnyCancellable> = []

  func requestBookList(page: Int) {
    bookService.searchBook(query: "베스트셀러", page: page, size: 20)
      .sink(receiveCompletion: { _ in }) { response in
        log.debug("response: \(response)")
        
      }
      .store(in: &cancellables)
  }
}
