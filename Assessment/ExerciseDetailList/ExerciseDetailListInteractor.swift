//
//  ExerciseDetailListInteractor.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import UIKit
import Combine

protocol ExerciseDetailListBusinessLogic
{
    func getExerciseData()
}

protocol ExerciseDetailListDataStore
{
  var exercise: Exercise? { get set }
}

class ExerciseDetailListInteractor: ExerciseDetailListBusinessLogic, ExerciseDetailListDataStore
{
  var presenter: ExerciseDetailListPresentationLogic?
//  var worker: ExerciseDetailListWorkerApi?
    private var cancellables = Set<AnyCancellable>()
    var exercise: Exercise? 
    
  // MARK: Do something
    
    
    func getExerciseData(){
        // TODO: 
        self.presenter?.presentExerciseDetail(response: exercise!)
    }
    
  

}


