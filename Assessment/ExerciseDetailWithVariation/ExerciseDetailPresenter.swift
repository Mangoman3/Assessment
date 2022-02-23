//
//  ExerciseDetailPresenter.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import UIKit

protocol ExerciseDetailPresentationLogic
{

    func presentExerciseDetailVariations(response: Exercise)

}

class ExerciseDetailPresenter: ExerciseDetailPresentationLogic
{
    weak var viewController: ExerciseDetailDisplayLogic?
    
    
    // MARK: Do something
    
    func presentExerciseDetailVariations(response: Exercise)
    {
        viewController?.displayExerciseDetail(viewModel: response)
    }
    
  
  
}
