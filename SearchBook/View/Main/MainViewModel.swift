//
//  MainViewModel.swift
//  SearchBook
//
//  Created by handnew on 1/15/25.
//
import Foundation
import Combine

final class MainViewModel {
  private let coreDataManager: CoreDataManager = CoreDataManager.shared
  private let bookService: BookServiceType = BookService()
  private let size = 20

  @Published var books: [Book] = []
  @Published private var searchQuery = String()
  @Published var insertIndexPaths: [IndexPath]?

  private var cancellables: Set<AnyCancellable> = []
  private var page = 1
  private var isLoading = false
  private var isEndPage = false

  init() {
    setupSearchBinding()
  }

  private func setupSearchBinding() {
    $searchQuery
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .handleEvents(receiveOutput: { query in
        if query.isEmpty {
          self.books = []
        }
      })
      .filter { !$0.isEmpty }
      .filter { $0.count >= 2 }
      .sink { query in
        log.debug("Search query:::: \(query)")
        self.requestBooks(query: query)
      }
      .store(in: &cancellables)
  }

  private func requestBooks(query: String) {
    guard !isLoading else { return }

    isLoading = true

    bookService.searchBook(query: query, page: page, size: size)
      .sink(receiveCompletion: { _ in
        self.isLoading = false
        log.debug("REQEUST BOOK COMPLETE HERE!! :::::::")
      }) { response in
        let newBooks = response.documents.map { $0.toDomain() }
        let checkedBooks = self.coreDataManager.fetchBookmarks(for: newBooks)
        self.books = checkedBooks
        self.page += 1
        self.isEndPage = response.meta.isEnd
      }
      .store(in: &cancellables)
  }

  func requestNextPage() {
    guard !isLoading && !isEndPage else { return }

    isLoading = true

    bookService.searchBook(query: searchQuery, page: page, size: size)
      .sink { _ in
        self.isLoading = false
        log.debug("REQUEST NEXT BOOK COMPLETE HERE!!!! :::::::::::")
      } receiveValue: { response in
        let startIndex = self.books.count
        let indextPath = (startIndex..<startIndex + response.documents.count).map {
          IndexPath(item: $0, section: 0)
        }

        let appendBooks = response.documents.map { $0.toDomain() }


        guard !appendBooks.isEmpty else { return }

        let checkedBooks = self.coreDataManager.fetchBookmarks(for: appendBooks)

        self.books += checkedBooks
        self.insertIndexPaths = indextPath
        self.page += 1
        self.isEndPage = response.meta.isEnd
      }
      .store(in: &cancellables)
  }

  func searchBook(_ query: String) {
    page = 1
    searchQuery = query
    isEndPage = false
  }

  func addBookmark(isbn: String) {
    guard let idx = books.firstIndex(where: { $0.isbn == isbn }) else { return }

    log.debug("Add Bookmark : \(books[idx])")
    books[idx].isBookmarked = true
    coreDataManager.insertBookmark(from: books[idx])
  }

  func deleteBookmark(isbn: String) {
    guard let idx = books.firstIndex(where: { $0.isbn == isbn }) else { return }

    log.debug("Delete Bookmark : \(books[idx])")
    books[idx].isBookmarked = false
    coreDataManager.deleteBookmark(for: books[idx])
  }

  func fetchBookmarks() {
    guard !books.isEmpty else { return }
    books = coreDataManager.fetchBookmarks(for: books)
  }
}
