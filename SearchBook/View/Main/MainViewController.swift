//
//  ViewController.swift
//  SearchBook
//
//  Created by handnew on 1/3/25.
//

import UIKit
import SnapKit
import Combine

class MainViewController: UIViewController {
  private let viewModel = MainViewModel()
  private var cancellables = Set<AnyCancellable>()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10

    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.backgroundColor = .white
    collection.register(BookListCell.self, forCellWithReuseIdentifier: "BookCell")
    return collection
  }()

  private let searchBar: UISearchBar = {
    let sb = UISearchBar()
    sb.placeholder = "검색어를 입력하세요"
    sb.backgroundColor = .clear
    sb.backgroundImage = UIImage()
    return sb
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    collectionView.delegate = self
    collectionView.dataSource = self
    searchBar.delegate = self

    setupUI()
    setupBindings()
  }

  private func setupUI() {
    view.addSubview(searchBar)
    view.addSubview(collectionView)

    searchBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(44)
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(10)
      make.leading.trailing.bottom.equalToSuperview().inset(16)
    }

  }

  private func setupBindings() {
    viewModel.$books
      .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.books.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookListCell

    let item = viewModel.books[indexPath.item]
    cell.configure(item)
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

extension MainViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.searchBook(searchText)
  }
}

