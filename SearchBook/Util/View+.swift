//
//  View+.swift
//  SearchBook
//
//  Created by handnew on 1/15/25.
//
import UIKit

extension UIImageView {
  func load(from url: URL) async throws {
    let (data, _) = try await URLSession.shared.data(from: url)
    await MainActor.run {
      self.image = UIImage(data: data)
    }
  }
}
