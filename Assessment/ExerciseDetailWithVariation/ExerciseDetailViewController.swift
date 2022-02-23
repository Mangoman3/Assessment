//
//  ExerciseDetailViewController.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/21/22.
//

import Combine
import Foundation
import Kingfisher
import UIKit


protocol ExerciseDetailDisplayLogic: AnyObject
{
    func displayExerciseDetail(viewModel:Exercise)
}



class ExerciseDetailViewController: UIViewController,ExerciseDetailDisplayLogic {
    // MARK: Properties
    @IBOutlet var collectionView: UICollectionView?

    typealias DataSource = UICollectionViewDiffableDataSource<Exercise, ImageData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Exercise, ImageData>
    private lazy var dataSource = makeDataSource()
    private var subscriptions = Set<AnyCancellable>()

    
    var interactor: ExerciseDetailBusinessLogic?
    var router: (NSObjectProtocol & ExerciseDetailRoutingLogic & ExerciseDetailDataPassing)?

    var exercise: [Exercise] = []
    private var variation = [Int]()
    private var loadingInProgress = false

    private var maxSectionCount: Int {
        return exercise.first?.variations?.count ?? 0
    }
    /// loading indicator
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    /// adding Loading indicator
    fileprivate func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10),
        ])
    }

    
   

    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
      super.init(coder: aDecoder)
      setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
      let viewController = self
      let interactor = ExerciseDetailInteractor()
      let presenter = ExerciseDetailPresenter()
      let router = ExerciseDetailRouter()
      viewController.interactor = interactor
      viewController.router = router
      interactor.presenter = presenter
      presenter.viewController = viewController
      router.viewController = viewController
      router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if let scene = segue.identifier {
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        if let router = router, router.responds(to: selector) {
          router.perform(selector, with: segue)
        }
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        interactor?.getInitialData()
        collectionView?.delegate = self
        collectionView?.collectionViewLayout = createCompositionalLayout()
        collectionView!.contentInset.bottom = 50
        setupLoadingIndicator()
    }

    /// Update UI with data snapshot
    fileprivate func applySnapshot(data: [Exercise]) {

        var snapshot = dataSource.snapshot()
        snapshot.appendSections(data)
        data.forEach { section in
            snapshot.appendItems(section.images ?? [], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func displayExerciseDetail(viewModel:Exercise){
        self.exercise.append(viewModel)
        if exercise.count == 1 {
            variation = exercise.first?.variations ?? []  // setting variations to keep track of lazy loading
            variation.insert(exercise.first?.id ?? 0, at: 0)
        }
       
        var snapshot = Snapshot()
        snapshot.appendSections(self.exercise)
        self.exercise.forEach { section in
            snapshot.appendItems(section.images ?? [], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
        self.loadingInProgress = false
        self.loadingIndicator.stopAnimating()
    }
    /// Creating Compositional Layout
    fileprivate func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (index, env) -> NSCollectionLayoutSection? in
            return self.getExerciseLayout()
        }
    }

    /// ViewModel binding
//    private func binding() {
//        viewModel.$exercise
//            .receive(on: RunLoop.main)
//            .sink { [weak self] items in
//                guard let self = self else { return }
//                if let data = items, data.name != nil {
////                    self.applySnapshot(data: [data])
//                }
//                self.loadingInProgress = false
//                self.loadingIndicator.stopAnimating()
//            }
//            .store(in: &subscriptions)
//    }
}

extension ExerciseDetailViewController {

    /// Cell Configure
    func makeDataSource() -> DataSource {

        let dataSource = DataSource(
            collectionView: collectionView!,
            cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in

                let cell =
                    collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AlbumItemCell.self), for: indexPath) as? AlbumItemCell

                cell?.imgCell.kf.indicatorType = .activity
                cell?.imgCell.kf.setImage(with: video.image.url)

                return cell
            }
        )

        confgiureHeaderFooter(dataSource)
        return dataSource
    }

    /// Layout for Exercise
    fileprivate func getExerciseLayout() -> NSCollectionLayoutSection {
        let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
        let item = NSCollectionLayoutItem(layoutSize: itemsize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header, footer]

        return section
    }

    /// Configure Supplementary views
    fileprivate func confgiureHeaderFooter(_ dataSource: ExerciseDetailViewController.DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in

            if kind == UICollectionView.elementKindSectionHeader {
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let view =
                    collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: String(describing: CategoryHeaderView.self),
                        for: indexPath
                    ) as? CategoryHeaderView
                view?.lblTitle.text = section.name
                return view
            } else {
                let view =
                    collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: String(describing: CategoryFooterView.self),
                        for: indexPath
                    ) as? CategoryFooterView
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

                view?.lblTitle.text = indexPath.section == 0 ? "Variations : \(section.variations?.count ?? 0)" : ""

                return view
            }
        }
    }
}

extension ExerciseDetailViewController: UICollectionViewDelegate {
    //LazyLoading variations
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.y
        let section = dataSource.snapshot().numberOfSections
        print(maxSectionCount, dataSource.snapshot().numberOfSections)
        if contentOffsetX >= (scrollView.contentSize.height - scrollView.bounds.height) - 50 {
            guard !loadingInProgress, maxSectionCount + 1 > section else { return }
            loadingInProgress = true
//            viewModel.getHomeData(id: variation[section])
            interactor?.getExerciseData(id: variation[section])
            loadingIndicator.startAnimating()
        }
    }
}



class ExerciseDetailViewModel: NSObject {

    private var cancellables = Set<AnyCancellable>()
    @Published var exercise: Exercise?

    func getHomeData(id: Int) {
        /// Fetching data
        ApiManager.shared.getData(endpoint: Endpoint.getVideCategories(String(id)), type: Exercise.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] data in
                self?.exercise = data
            }
            .store(in: &cancellables)
    }
}
