//
//  DetailViewController.swift
//  SearchBook
//
//  Created by handnew on 1/16/25.
//
import UIKit
import SnapKit

class DetailViewController: UIViewController {
  private let viewModel: DetailViewModel

  private let coverImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.layer.cornerRadius = 16
    iv.clipsToBounds = true
    return iv
  }()

  private let bookmarkIcon: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()

  private let titleLabel: UILabel = {
    let lb = UILabel()
    lb.font = .systemFont(ofSize: 26, weight: .semibold)
    lb.numberOfLines = 0
    return lb
  }()

  private let authorLabel: UILabel = {
    let lb = UILabel()
    lb.font = .systemFont(ofSize: 18, weight: .medium)
    return lb
  }()

  private let publisherLabel: UILabel = {
    let lb = UILabel()
    lb.font = .systemFont(ofSize: 16, weight: .regular)
    lb.textColor = .darkGray
    return lb
  }()

  private let descriptionLabel: UILabel = {
    let lb = UILabel()
    lb.numberOfLines = 0
    lb.font = .systemFont(ofSize: 14, weight: .regular)
    lb.textColor = .gray
    return lb
  }()

  init(book: Book) {
    self.viewModel = DetailViewModel(book: book)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    log.debug("booooooook \(viewModel.book)")

    setupUI()
    configure()
  }

  private func setupUI() {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, publisherLabel, descriptionLabel])
    view.addSubview(coverImageView)
    view.addSubview(stackView)
    view.addSubview(bookmarkIcon)

    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fillProportionally
    stackView.spacing = 10

    coverImageView.layer.borderWidth = 0.5
    coverImageView.layer.borderColor = UIColor.lightGray.cgColor

    coverImageView.snp.makeConstraints { make in
      make.height.lessThanOrEqualTo(200)
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
    }

    bookmarkIcon.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.trailing.equalToSuperview().inset(16)
      make.size.equalTo(30)
    }

    stackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(coverImageView.snp.bottom).offset(30)
    }

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBookmark))
    bookmarkIcon.addGestureRecognizer(tapGesture)
    bookmarkIcon.isUserInteractionEnabled = true
  }

  private func configure() {
    let book = viewModel.book

    titleLabel.text = book.title
    authorLabel.text = book.authors.joined(separator: ", ")
    publisherLabel.text = book.publisher + " 펴냄"
    descriptionLabel.text = book.contents
    descriptionLabel.lineSpacing(spacing: 10)
    updateBookmarkIcon()

    guard let url = URL(string: book.thumbnail) else { return }
    Task {
      try? await coverImageView.load(from: url)
    }
  }

  @objc private func tappedBookmark() {
    if viewModel.book.isBookmarked {
      viewModel.deleteBookmark()
    } else {
      viewModel.addBookmark()
    }

    viewModel.book.isBookmarked.toggle()
    updateBookmarkIcon()
  }

  private func updateBookmarkIcon() {
    bookmarkIcon.image = viewModel.book.isBookmarked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
  }
}
