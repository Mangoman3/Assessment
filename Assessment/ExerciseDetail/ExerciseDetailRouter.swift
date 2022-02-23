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
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ExerciseDetailViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ExerciseDetailDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
