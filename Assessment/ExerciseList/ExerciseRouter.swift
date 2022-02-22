//
//  ExerciseRouter.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/22/22.
//

import Foundation
import UIKit

@objc protocol ExerciseRoutingLogic {
 func routeToExerciseDetailViewController(segue: UIStoryboardSegue)
}

protocol ExerciseDataPassing {
    var dataStore: ExerciseDataStore? { get set }
}

class ExerciseRouter: NSObject, ExerciseRoutingLogic, ExerciseDataPassing {
    weak var viewController: ExerciseViewController?
    var dataStore: ExerciseDataStore?


    // MARK: Routing
    func routeToExerciseDetailViewController(segue: UIStoryboardSegue) {
        if let vc = segue.destination as? ExerciseDetailListViewController {
            if  let exercise = dataStore?.selectedExercise {
                vc.exercise = [exercise]
            }
        }
    }
    
}
