//
//  CoreDataManager.swift
//  SearchBook
//
//  Created by handnew on 2/3/25.
//

import CoreData

final class CoreDataManager {
  static let shared = CoreDataManager()
  private let persistentContainer: NSPersistentContainer

  private init() {
    persistentContainer = NSPersistentContainer(name: "SearchBook")
    persistentContainer.loadPersistentStores { description, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }

  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  func newBackgroundContext() -> NSManagedObjectContext {
    let context = persistentContainer.newBackgroundContext()
    return context
  }

  func fetchBookmarks() -> [Book] {
    let request: NSFetchRequest<BookMO> = BookMO.fetchRequest()

    do {
      let results = try context.fetch(request)

      return results.map { $0.toBook() }
    } catch {
      log.debug("Failed to fetch bookmarks: \(error)")
      return []
    }
  }

  func fetchBookmarks(for books: [Book]) -> [Book] {
    let isbns = books.map { $0.isbn }
    let request: NSFetchRequest<BookMO> = BookMO.fetchRequest()
    request.predicate = NSPredicate(format: "isbn IN %@", isbns)

    do {
      let results = try context.fetch(request)
      let bookmarkedIsbns = Set(results.compactMap { $0.isbn })

      let updatedBooks = books.map { book -> Book in
        var updatedBook = book
        updatedBook.isBookmarked = bookmarkedIsbns.contains(book.isbn)
        return updatedBook
      }
      return updatedBooks

    } catch {
      log.debug("Failed to fetch bookmarks: \(error)")
      return books
    }
  }

  func fetchBookmark(with book: Book) -> Book {
    let request: NSFetchRequest<BookMO> = BookMO.fetchRequest()
    request.predicate = NSPredicate(format: "isbn == %@", book.isbn)
    request.fetchLimit = 1
    do {
      let result = try context.fetch(request)
      return result.first?.toBook() ?? book
    } catch {
      log.debug("Faield to fetch bookmark: \(error)")
      return book
    }
  }

  func insertBookmark(from book: Book) {
    let bookmarkedBook = BookMO(context: context)
    bookmarkedBook.title = book.title
    bookmarkedBook.authors = book.authors.joined(separator: ",")
    bookmarkedBook.publisher = book.publisher
    bookmarkedBook.isbn = book.isbn
    bookmarkedBook.thumbnail = book.thumbnail
    bookmarkedBook.contents = book.contents
    bookmarkedBook.isBookmarked = true

    do {
      try context.save()
    } catch {
      log.debug("Failed Insert BookMO ::: \(error)")
    }
  }

  func updateBookmark(with book: Book) {
    let request: NSFetchRequest<BookMO> = BookMO.fetchRequest()
    request.predicate = NSPredicate(format: "isbn == %@", book.isbn)
    do {
      let results = try context.fetch(request)
      if let bookmarkedBook = results.first {
        bookmarkedBook.title = book.title
        bookmarkedBook.authors = book.authors.joined(separator: ",")
        bookmarkedBook.publisher = book.publisher
        bookmarkedBook.isbn = book.isbn
        bookmarkedBook.thumbnail = book.thumbnail
        bookmarkedBook.contents = book.contents

        try context.save()
      } else {
        insertBookmark(from: book)
      }
    } catch {
      log.debug("Faild Update BookMO ::: \(error)")
    }
  }

  func deleteBookmark(for book: Book) {
    let request: NSFetchRequest<BookMO> = BookMO.fetchRequest()
    request.predicate = NSPredicate(format: "isbn == %@", book.isbn)
    request.fetchLimit = 1
    do {
      let results = try context.fetch(request)
      for bookmark in results {
        context.delete(bookmark)
      }
      try context.save()
    } catch {
      log.debug("Failed Delete BookMO isbn \(book.isbn) ::: error ::: \(error)")
    }
  }
}
