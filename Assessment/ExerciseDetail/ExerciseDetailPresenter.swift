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
    func presentExerciseDetailVariations(response: Exercise) {
        
    }
    
    // MARK: Do something
    
    func presentExerciseDetail(response: Exercise)
    {
        let variation = response.variations.map{$0} ?? []
        let images = response.images?.map{$0.image} ?? []
        let name = response.name ?? ""
        let viewModel = ExerciseDetailListViewModel(images: images, variations: variation, name: name)
//        viewController?.displayExerciseDetail(viewModel: viewModel)
    }
    
  
  
}
