//
//  MainTabBarController.swift
//  SearchBook
//
//  Created by handnew on 1/16/25.
//

import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setupTabs()
    setupUI()
  }

  private func setupTabs() {
    let firstVC = UINavigationController(rootViewController: MainViewController())
    let secondVC = UINavigationController(rootViewController: BookmarkViewController())

    firstVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
    secondVC.tabBarItem = UITabBarItem(title: "Bookmark", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))

    self.viewControllers = [firstVC, secondVC]
  }

  private func setupUI() {
    let appearance = UITabBarAppearance()

    appearance.configureWithOpaqueBackground()
    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
  }
}
