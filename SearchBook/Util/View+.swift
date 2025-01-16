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

extension UILabel {
  func lineSpacing(spacing: CGFloat) {
    guard let text = self.text else { return }

    let attributedString = NSMutableAttributedString(string: text)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = spacing

    attributedString.addAttribute(.paragraphStyle,
                                  value: paragraphStyle,
                                  range: NSRange(location: 0, length: attributedString.length))

    self.attributedText = attributedString
  }
}
