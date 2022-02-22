//
//  Constants.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/23/22.
//

import Foundation


struct Constant {
    static let gymondoBase: String = "wger.de"

    struct Paths {
        enum path {
            case EXERCISE_INFO

             var fallBackUrl: String {
                switch self {
                case .EXERCISE_INFO: return "/api/v2/exerciseinfo"

                }
            }
        }

    }

}
