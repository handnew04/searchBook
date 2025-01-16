//
//  Book.swift
//  SearchBook
//
//  Created by handnew on 1/14/25.
//

import Foundation

struct Book: ModelType {
  let authors: [String]
  let contents, datetime, isbn: String
  let price: Int
  let publisher: String
  let salePrice: Int
  let thumbnail: String
  let title: String
  let translators: [String]
  let url: String
  var isBookmarked = false
}
