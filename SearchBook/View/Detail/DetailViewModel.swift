//
//  DetailViewModel.swift
//  SearchBook
//
//  Created by handnew on 1/16/25.
//

final class DetailViewModel {
  private let coredataManager = CoreDataManager.shared

  var book: Book

  init(book: Book) {
    self.book = book
  }

  func addBookmark() {
    coredataManager.insertBookmark(from: book)
  }

  func deleteBookmark() {
    coredataManager.deleteBookmark(for: book)
  }
}
