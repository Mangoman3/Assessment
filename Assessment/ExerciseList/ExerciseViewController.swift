//
//  ViewController.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Combine
import UIKit
import Foundation
import SwiftUI


protocol ExerciseDisplayLogic: AnyObject{
    func displayExerciseList(viewModel:[ExerciseViewModel])
}

class ExerciseViewController: UITableViewController {

    // MARK: Properties
    var router: (NSObjectProtocol & ExerciseRoutingLogic & ExerciseDataPassing)?
    var interactor: ExerciseBussinessLogic?
    private var subscriptions = Set<AnyCancellable>()
    private let reuseIdentifier = "Cell"
    var exercise : [ExerciseViewModel] = []
    
    
    /// Setting up depedencies
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
           super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
           setup()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           setup()
       }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getExercises()
    }

    
    
       private func setup() {
           let viewController = self
           let worker = ExerciseListingApiImpl(apiManager: ApiManager())
           let presenter = ExercisePresentor()
           let interactor = ExerciseInteractor(exerciseWorker: worker, presenter: presenter)
           let router = ExerciseRouter()
          
           viewController.interactor = interactor
           viewController.router = router
           presenter.display = viewController
           router.dataStore = interactor
           router.viewController = viewController
       }
    
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        let data = exercise[indexPath.row]
      // UIImage(systemName: "exclamationmark.circle")
        showSwiftUIview(data, cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.tappedExercise(index: indexPath.row)
        self.performSegue(withIdentifier: "ExerciseDetailViewController", sender: nil)
                
    }
    
    // MARK: Routing
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let scene = segue.identifier {
               let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
               if let router = router, router.responds(to: selector) {
                   router.perform(selector, with: segue)
               }
           }
       }
    
    ///Embedding swiftUI view
   func showSwiftUIview(_ data: ExerciseViewModel, _ cell: UITableViewCell) {
            if #available(iOS 13.0, *){
                
                let swiftUICellViewController = UIHostingController(rootView: ExerciseView(model: data))
                cell.layoutIfNeeded()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                self.addChild(swiftUICellViewController)
                cell.contentView.addSubview(swiftUICellViewController.view)
                swiftUICellViewController.view.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 10.0))
                cell.contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
                cell.contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
                cell.contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cell.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
                
                swiftUICellViewController.didMove(toParent: self)
                swiftUICellViewController.view.layoutIfNeeded()
                
            }
        }
}


extension ExerciseViewController: ExerciseDisplayLogic {
    func displayExerciseList(viewModel: [ExerciseViewModel]) {
        self.exercise = viewModel
        self.tableView.reloadData()
    }
}







































