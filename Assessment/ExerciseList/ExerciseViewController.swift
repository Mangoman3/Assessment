//
//  ViewController.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Combine
import UIKit
import Foundation



protocol ExerciseDisplayLogic: AnyObject{
    func displayExerciseList(viewModel:[ExerciseViewModel])
}

class ExerciseViewController: UITableViewController {

    
    var router: (NSObjectProtocol & ExerciseRoutingLogic & ExerciseDataPassing)?

    var interactor: ExerciseBussinessLogic?
    private var subscriptions = Set<AnyCancellable>()
    private let reuseIdentifier = "Cell"
    var exercise : [ExerciseViewModel] = []
    
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
//        view.presentActivity(.medium, withTintColor: .black, blockSuperView: true)
//        viewModel.getHomeData()
//        binding()
        
    }

    
    // MARK: Setup

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
        var content = cell.defaultContentConfiguration()
        let data = exercise[indexPath.row]
        content.text = data.name
        content.image = UIImage(systemName: "exclamationmark.circle")
        if let url = URL(string: data.url) {
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imgView.load(url: url, placeholder: nil, cache: URLCache.shared)
        }
        content.image
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise.count
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
}


extension ExerciseViewController: ExerciseDisplayLogic {
    func displayExerciseList(viewModel: [ExerciseViewModel]) {
        self.exercise = viewModel
        self.tableView.reloadData()
    }
    
    
    
}








































extension UIView {
    func presentActivity(_ style: UIActivityIndicatorView.Style = .large,
                         withTintColor tintColor: UIColor? = .black,
                         blockSuperView isBlockView: Bool = true) {
        if let activityIndicator = findActivity() {
            activityIndicator.startAnimating()
        } else {
            let activityIndicator = UIActivityIndicatorView(style: style)
            if let tintColor = tintColor {
                activityIndicator.assignColor(tintColor)
            }
    
            activityIndicator.startAnimating()
            self.addSubview(activityIndicator)

            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 11.0, *) {
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
                    ])
                activityIndicator.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor).isActive = isBlockView
                activityIndicator.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor).isActive = isBlockView
            } else {
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                    ])
                activityIndicator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = isBlockView
                activityIndicator.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = isBlockView
            }
        }
    }

    func dismissActivity() {
        findActivity()?.stopAnimating()
    }

    func findActivity() -> UIActivityIndicatorView? {
        return self.subviews.lazy.compactMap { $0 as? UIActivityIndicatorView }.first
    }
}

extension UIActivityIndicatorView {
    func assignColor(_ color: UIColor) {
        self.color = color
    }
}


extension UIImageView {
    /// Loads image from web asynchronosly and caches it, in case you have to load url
    /// again, it will be loaded from cache if available
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}

extension String {
    
    var url: URL? {
        return URL(string: self)
    }
}
