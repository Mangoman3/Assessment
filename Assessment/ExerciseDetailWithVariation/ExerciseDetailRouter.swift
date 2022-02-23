//
//  ExerciseDetailRouter.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import UIKit

@objc protocol ExerciseDetailRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ExerciseDetailDataPassing
{
  var dataStore: ExerciseDetailDataStore? { get }
}

class ExerciseDetailRouter: NSObject, ExerciseDetailRoutingLogic, ExerciseDetailDataPassing
{
  weak var viewController: ExerciseDetailViewController?
  var dataStore: ExerciseDetailDataStore?
  
}
