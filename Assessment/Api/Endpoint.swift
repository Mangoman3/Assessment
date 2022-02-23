//
//  Endpoint.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/23/22.
//

import Foundation

enum Environment {
    case sandbox, production
}

enum NetworkError: Error {
    case transportError(Error)
    case serverError
    case noData, unknown
    case decodingError(Error)
    case encodingError(Error)
}


struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var environment: Environment {
        return .production
    }

    private var host: String {
        switch environment {
        case .sandbox, .production: return Constant.gymondoBase
        }
    }

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}

extension Endpoint {
    static func getVideCategories(_ id: String = "") -> Self {
        return Endpoint(path: Constant.Paths.path.EXERCISE_INFO.fallBackUrl + "/\(id)")
    }
}
