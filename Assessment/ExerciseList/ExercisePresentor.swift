//
//  ExercisePresentor.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Foundation


protocol ExercisePresentationLogic {
    func presentExerciseList(data:[Exercise])
}


class ExercisePresentor: ExercisePresentationLogic {
    
    weak var display: ExerciseDisplayLogic?
    
    
    func presentExerciseList(data: [Exercise]) {
        var exerciseViewModel = [ExerciseViewModel]()
        for model in data {
            let viewModel = ExerciseViewModel(name: model.name ?? "", url: model.images?.first?.image ?? "")
            exerciseViewModel.append(viewModel)
        }
        display?.displayExerciseList(viewModel: exerciseViewModel)
    }
    
    
}
