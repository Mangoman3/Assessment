//
//  ApiManager.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Combine
import Foundation



protocol ApiManagerProtocol: AnyObject {
    func getData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<T, Error>
}

class ApiManager: ApiManagerProtocol {
    static let shared = ApiManager()
    
    private var cancellables = Set<AnyCancellable>()

    func getData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(NetworkError.unknown))
            }

            URLSession.shared.dataTaskPublisher(for: endpoint.url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.serverError
                    }

                    guard !data.isEmpty else {
                        throw NetworkError.noData
                    }

                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { (completion) in
                        if case let .failure(error) = completion {
                            switch error {
                            case let decodingError as DecodingError:
                                promise(.failure(decodingError))
                            case let apiError as NetworkError:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(error))
                            }
                        }
                    },
                    receiveValue: { promise(.success($0)) }
                )
                .store(in: &self.cancellables)
        }
    }
}
