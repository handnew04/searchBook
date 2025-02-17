//
//  BookmarkViewModel.swift
//  SearchBook
//
//  Created by handnew on 2/4/25.
//
import Foundation
import CoreData
import Combine

@MainActor
class BookmarkViewModel {
  private let coredataManager = CoreDataManager.shared
  @Published var books : [Book] = []
  @Published var indexPathToDelete: IndexPath?

  func fetchBooks() {
    log.debug("fetchBooks...")
    Task {
      let bookmarks = coredataManager.fetchBookmarks()
      self.books = bookmarks
      log.debug("fetched books : \(books)")
    }
  }

  func deleteBookmark(isbn: String) {
    guard let book = books.first(where: { $0.isbn == isbn }) else { return }

    log.debug("Delete Bookmark: \(book)")
    coredataManager.deleteBookmark(for: book)

    let idx = books.firstIndex(of: book)!
    indexPathToDelete = IndexPath(item: idx, section: 0)
  }
}

