//
//  AuthPlugin.swift
//  SearchBook
//
//  Created by handnew on 1/7/25.
//

import Foundation
import Moya

struct AuthPlugin: PluginType {
  func prepare(_ request: URLRequest, target: any TargetType) -> URLRequest {
    var request = request

    if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
      request.addValue("KakaoAK \(key)", forHTTPHeaderField: "Authorization")
    }

    return request
  }
}
