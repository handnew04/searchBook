//
//  Data+.swift
//  SearchBook
//
//  Created by handnew on 1/7/25.
//
import Foundation

extension Data {
  var prettyJson: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyPrintedString = String (data: data, encoding: .utf8) else { return nil }

    return prettyPrintedString
  }
}
