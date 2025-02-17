//
//  BookMO+.swift
//  SearchBook
//
//  Created by handnew on 2/4/25.
//

extension BookMO {
  func toBook() -> Book {
    return Book(
      authors: authors?.components(separatedBy: ",") ?? [],
      contents: contents ?? "",
      datetime: "",
      isbn: isbn ?? "",
      price: 0,
      publisher: publisher ?? "",
      salePrice: 0,
      thumbnail: thumbnail ?? "",
      title: title ?? "",
      translators: [],
      url: "",
      isBookmarked: isBookmarked
    )
  }
}
