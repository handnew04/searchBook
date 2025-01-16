//
//  BookListCell.swift
//  SearchBook
//
//  Created by handnew on 1/15/25.
//

import UIKit
import SnapKit

class BookListCell: UICollectionViewCell {
  let coverImage: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleToFill
    iv.clipsToBounds = true
    return iv
  }()

  let titleLabel: UILabel = {
    let lv = UILabel()
    lv.font = .systemFont(ofSize: 14, weight: .semibold)
    lv.textColor = .black
    return lv
  }()

  let authorLabel: UILabel = {
    let lv = UILabel()
    lv.font = .systemFont(ofSize: 11, weight: .medium)
    lv.textColor = .gray
    return lv
  }()

  let bookmarkIcon: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(systemName: "heart")
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    let titleStackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
    let stackView = UIStackView(arrangedSubviews: [coverImage, titleStackView, bookmarkIcon])

    contentView.addSubview(stackView)

    titleStackView.axis = .vertical
    titleStackView.spacing = 2
    titleStackView.alignment = .leading

    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    coverImage.snp.makeConstraints { make in
      make.width.equalTo(50)
      make.height.equalTo(70)
    }

    bookmarkIcon.snp.makeConstraints { make in
      make.size.equalTo(20)
    }

    titleStackView.snp.makeConstraints { make in
      make.height.lessThanOrEqualTo(contentView)
    }

    coverImage.setContentHuggingPriority(.required, for: .horizontal)
    bookmarkIcon.setContentHuggingPriority(.required, for: .horizontal)

    titleStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
  }

  func configure(_ book: Book) {
    titleLabel.text = book.title
    authorLabel.text = book.authors.joined(separator: ", ")

    Task {
      do {
        if let url = URL(string: book.thumbnail) {
          try await coverImage.load(from: url)
        }
      } catch {
        log.debug(NetworkError.failedImageDownload.description + "\(error)")
      }
    }
  }
}
