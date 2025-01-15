//
//  BookDTO.swift
//  SearchBook
//
//  Created by handnew on 1/15/25.
//

struct BookDTO: ModelType {
  let documents: [Document]
  let meta: Meta
}

struct Document: ModelType {
  let authors: [String]
  let contents, datetime, isbn: String
  let price: Int
  let publisher: String
  let salePrice: Int
  let thumbnail: String
  let title: String
  let translators: [String]
  let url: String

  enum CodingKeys: String, CodingKey {
    case authors, contents, datetime, isbn, price, publisher
    case salePrice = "sale_price"
    case thumbnail, title, translators, url
  }

  func toDomain() -> Book {
    return Book(
      authors: authors,
      contents: contents,
      datetime: datetime,
      isbn: isbn,
      price: price,
      publisher: publisher,
      salePrice: salePrice,
      thumbnail: thumbnail,
      title: title,
      translators: translators,
      url: url)
  }
}

struct Meta: ModelType {
  let isEnd: Bool
  let pageableCount, totalCount: Int

  enum CodingKeys: String, CodingKey {
    case isEnd = "is_end"
    case pageableCount = "pageable_count"
    case totalCount = "total_count"
  }
}
