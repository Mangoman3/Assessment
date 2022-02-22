//
//  File.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Combine
import Foundation

protocol ExerciseBussinessLogic: AnyObject {
    func getExercises()
    func tappedExercise(index:Int)
}

protocol ExerciseDataStore: AnyObject {
    var arrExercise: [Exercise] { get set }
    var selectedExercise: Exercise? { get set }
}

class ExerciseInteractor: ExerciseDataStore {
    var selectedExercise: Exercise?

    var arrExercise: [Exercise] = []

    private var cancellables = Set<AnyCancellable>()
    let exerciseWorker: ExerciseListingApi
    let presenter: ExercisePresentationLogic

    internal init(
        exerciseWorker: ExerciseListingApi,
        presenter: ExercisePresentationLogic
    ) {
        self.exerciseWorker = exerciseWorker
        self.presenter = presenter
    }
}

extension ExerciseInteractor: ExerciseBussinessLogic {
    func tappedExercise(index:Int) {
        self.selectedExercise = arrExercise[index]
    }
    

    func getExercises() {

        self.exerciseWorker.getExerciseList()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] data in
                self?.arrExercise = data
                self?.presenter.presentExerciseList(data: data)
            }
            .store(in: &cancellables)

    }
    

}
