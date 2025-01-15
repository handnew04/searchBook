//
//  LogPlugin.swift
//  SearchBook
//
//  Created by handnew on 1/7/25.
//

import Foundation
import Moya

struct LogPlugin: PluginType {
  func willSend(_ request: any RequestType, target: any TargetType) {
    guard let httpRequest = request.request else {
      print("⬆⬆⬆[HTTP request] invalid request⬆⬆⬆")
      return
    }

    let url = httpRequest.description
    let httpMethod = httpRequest.httpMethod ?? "unknown method"

    var httpLog = """
                  ⬇⬇⬇[HTTP Request]⬇⬇⬇
                  TARGET: \(target)
                  URL: \(httpMethod) \(url)\n
                  """

    httpLog.append("HEADER: [\n")
    httpRequest.allHTTPHeaderFields?.forEach {
      httpLog.append("\t\($0): \($1)\n")
    }
    httpLog.append("]\n")

    if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
      httpLog.append("BODY \n\(bodyString)\n")
    }
    httpLog.append("⬆⬆⬆[HTTP Request End]⬆⬆⬆")

    log.debug(httpLog)
  }

  func didReceive(_ result: Result<Response, MoyaError>, target: any TargetType) {
    switch result {
    case let .success(response):
      onSuccess(response, target: target)
    case let .failure(error):
      onFailue(error, target: target)
    }
  }

  func onSuccess(_ response: Response, target: TargetType) {
    let request = response.request
    let url = request?.url?.absoluteString ?? "nil url"
    let statusCode = response.statusCode

    var httpLog = """
                  ⬇⬇⬇[HTTP Response]⬇⬇⬇
                  TARGET: \(target)
                  URL: \(url)
                  STATUS CODE: \(statusCode)\n
                  """
    httpLog.append("RESPONSE DATA: \n")

    if let responseString = response.data.prettyJson {
      httpLog.append("\(responseString)\n")
    } else if let responseString = String(bytes: response.data, encoding: .utf8) {
      httpLog.append("\(responseString)\n")
    }
    httpLog.append("⬆⬆⬆[HTTP Response End]⬆⬆⬆")
  }

  func onFailue(_ error: MoyaError, target: TargetType) {
    if let response = error.response {
      var httpLog = """
                  ⚠️⚠️⚠️[HTTP Error Response]⚠️⚠️⚠️
                  TARGET: \(target)
                  STATUS CODE: \(response.statusCode)
                  """

      if let responseString = response.data.prettyJson {
        httpLog.append("\nERROR RESPONSE: \n\(responseString)")
      }

      print(httpLog)
      return
    }

    var httpLog = """
            [HTTP Error]
            TARGET: \(target)
            ERRORCODE: \(error.errorCode)\n
            """
    httpLog.append("MESSAGE: \(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
    httpLog.append("[HTTP Error End]")

    print(httpLog)
  }
}
