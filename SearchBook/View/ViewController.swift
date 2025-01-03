//
//  ViewController.swift
//  SearchBook
//
//  Created by handnew on 1/3/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  private let text: UITextField = {
    let tf = UITextField()
    tf.placeholder = "zmzmzm"
    return tf
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = .white

    setupUI()
  }

  private func setupUI() {
    view.addSubview(text)

    text.snp.makeConstraints { make in
      make.center.equalTo(view)
    }
  }
}

