//
//  ExerciseDetailListPresenter.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import UIKit

protocol ExerciseDetailListPresentationLogic
{
  func presentExerciseDetail(response: Exercise)
}

class ExerciseDetailListPresenter: ExerciseDetailListPresentationLogic
{
  weak var viewController: ExerciseDetailListDisplayLogic?
  
  // MARK: Do something
  
  func presentExerciseDetail(response: Exercise)
  {
      let variation = response.variations.map{$0} ?? []
      let images = response.images?.map{$0.image} ?? []
      let name = response.name ?? ""
      let viewModel = ExerciseDetailListViewModel(images: images, variations: variation, name: name)
      viewController?.displayExerciseDetail(viewModel: viewModel)
  }
}
