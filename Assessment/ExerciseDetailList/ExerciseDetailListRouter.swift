//
//  ExerciseDetailListRouter.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import UIKit

@objc protocol ExerciseDetailListRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ExerciseDetailListDataPassing
{
  var dataStore: ExerciseDetailListDataStore? { get }
}

class ExerciseDetailListRouter: NSObject, ExerciseDetailListRoutingLogic, ExerciseDetailListDataPassing
{
  weak var viewController: ExerciseDetailListViewController?
  var dataStore: ExerciseDetailListDataStore?
  
  // MARK: Routing
    
    func routeToExerciseDetailViewController(segue: UIStoryboardSegue) {
        if let vc = segue.destination as? ExerciseDetailViewController {
            if  let exercise = dataStore?.exercise {
               
               var dataStore = vc.router?.dataStore
                dataStore?.exercise = exercise
            }
        }
    }

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ExerciseDetailListViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ExerciseDetailListDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
