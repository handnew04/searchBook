//
//  ModelType.swift
//  SearchBook
//
//  Created by handnew on 1/7/25.
//
import Foundation

typealias StringKeyDictionary = [String: Any]

protocol ModelType: Codable, Hashable {}

extension ModelType {
  static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
    return .iso8601
  }

  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = dateDecodingStrategy
    return decoder
  }
}


