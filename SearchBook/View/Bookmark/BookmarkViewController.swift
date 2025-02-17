//
//  BookmarkViewController.swift
//  SearchBook
//
//  Created by handnew on 1/16/25.
//
import UIKit
import SnapKit
import Combine

class BookmarkViewController: UIViewController {
  private let viewModel = BookmarkViewModel()
  private var cancellables: Set<AnyCancellable> = []
  private var isInitialLoad = false

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10

    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.backgroundColor = .white
    collection.register(BookListCell.self, forCellWithReuseIdentifier: "BookmarkCell")
    return collection
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.delegate = self
    collectionView.dataSource = self

    setupUI()
    setupBindings()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isInitialLoad = false
    viewModel.fetchBooks()
  }

  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(collectionView)

    collectionView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().offset(10)
      make.leading.trailing.bottom.equalToSuperview().inset(16)
    }
  }

  private func setupBindings() {
    viewModel.$books
      .sink { [weak self] _ in
        guard let self, !isInitialLoad else { return }
        self.collectionView.reloadData()
        self.isInitialLoad = true
      }
      .store(in: &cancellables)

    viewModel.$indexPathToDelete
      .sink { [weak self] indexPath in
        guard let self, let indexPath else { return }
        self.collectionView.performBatchUpdates {
          self.viewModel.books.remove(at: indexPath.item)
          self.collectionView.deleteItems(at: [indexPath])
        }
      }
      .store(in: &cancellables)
  }
}

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.books.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard indexPath.item < viewModel.books.count else {
      return UICollectionViewCell()
    }

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkCell", for: indexPath) as! BookListCell

    let item = viewModel.books[indexPath.item]
    cell.configure(item)
    cell.bookmarkTapped = { [weak self] isbn in
      self?.viewModel.deleteBookmark(isbn: isbn)
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    return CGSize(width: width, height: 80)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedBook = viewModel.books[indexPath.item]
    let detailVC = DetailViewController(book: selectedBook)

    detailVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
