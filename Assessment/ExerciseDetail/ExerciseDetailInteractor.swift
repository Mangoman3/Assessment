//
//  ExerciseDetailInteractor.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import UIKit
import Combine

protocol ExerciseDetailBusinessLogic
{
        func getExerciseData(id: Int)
}

protocol ExerciseDetailDataStore
{
  var exercise: Exercise? { get set }
}

class ExerciseDetailInteractor: ExerciseDetailBusinessLogic, ExerciseDetailDataStore
{
  var presenter: ExerciseDetailPresentationLogic?
  var worker: ExerciseDetailWorker?
    private var cancellables = Set<AnyCancellable>()
    var exercise: Exercise?

  
  // MARK: Do something
    
        func getExerciseData(id: Int) {
            /// Fetching data

            worker = ExerciseDetailWorker(apiManager: ApiManager())
            worker?.getExerciseData(id:id)
                .sink { completion in
                    switch completion {
                    case .failure(let err):
                        print("Error is \(err.localizedDescription)")
                    case .finished:
                        print("Finished")
                    }
                } receiveValue: { [weak self] data in
                    self?.exercise = data
//                    self?.presenter?.presentExerciseDetail(response: data)
                }
                .store(in: &cancellables)

        }
    

}
