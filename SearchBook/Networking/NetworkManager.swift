//
//  NetworkManger.swift
//  SearchBook
//
//  Created by handnew on 1/7/25.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class NetworkManager<Target: TargetType>: MoyaProvider<Target> {
  let retryCount = 2
  var count = 0

  init(
    plugins: [PluginType] = [
      AuthPlugin(),
      LogPlugin(),
    ]) {
      let session = MoyaProvider<Target>.defaultAlamofireSession()
      session.sessionConfiguration.timeoutIntervalForRequest = 10

      super.init(session: session, plugins: plugins)
    }

  func request<T: ModelType>(
    _ target: Target,
    file: String = #file,
    function: String = #function,
    line: UInt = #line) -> AnyPublisher<T, Error> {
      guard count < retryCount else {
        return Fail(error: NetworkError.tooManyRetries).eraseToAnyPublisher()
      }
      
      return createBaseRequest(target)
        .tryMap { response -> T in
          try self.decodeResponse(response, type: T.self)
        }
        .mapError { error in
          self.handleNetworkError(error)
          return error
        }
        .eraseToAnyPublisher()

    }

  private func createBaseRequest(_ target: Target) -> AnyPublisher<Response, MoyaError> {
    requestPublisher(target)
      .filterSuccessfulStatusAndRedirectCodes()
      .subscribe(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  private func decodeResponse<T: ModelType>(_ response: Response, type: T.Type) throws -> T {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: response.data)
  }

  private func handleNetworkError(_ error: Error) {
    guard let moyaError = error as? MoyaError, case let .statusCode(response) = moyaError else { return }
  }
}
