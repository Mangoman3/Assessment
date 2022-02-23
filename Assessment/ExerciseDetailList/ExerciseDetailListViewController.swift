//
//  ExerciseDetailVariationViewController.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/22/22.
//

import Foundation
import UIKit


protocol ExerciseDetailListDisplayLogic: AnyObject
{
    func displayExerciseDetail(viewModel:ExerciseDetailListViewModel)
}


class ExerciseDetailListViewController: UIViewController , ExerciseDetailListDisplayLogic{
    // MARK: Properties
    @IBOutlet var collectionView: UICollectionView?

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
   
    var interactor: ExerciseDetailListBusinessLogic?
    var router: (NSObjectProtocol & ExerciseDetailListRoutingLogic & ExerciseDetailListDataPassing)?
    
    
    var viewModel: ExerciseDetailListViewModel?
    private lazy var dataSource = makeDataSource()


    /// Section Model
    enum Section: Hashable {
        case images
        case variation
    }

    enum Item: Hashable {
        case images(String)
        case variation(Int)
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
      let interactor = ExerciseDetailListInteractor()
      let presenter = ExerciseDetailListPresenter()
      let router = ExerciseDetailListRouter()
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
        interactor?.getExerciseData()
        collectionView?.register(UINib(nibName: ButtonCell.nibName, bundle: nil), forCellWithReuseIdentifier: ButtonCell.nibName)
        collectionView?.collectionViewLayout = createCompositionalLayout()
    }

  

    /// Creating Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (index, env) -> NSCollectionLayoutSection? in
            let section = self.dataSource.snapshot().sectionIdentifiers[index]
            switch section {
            case .images: return self.getImageLayout()
            case .variation: return self.getVariationLayout()
            }
        }
    }

    /// Cell Configure
    func makeDataSource() -> DataSource {

        let dataSource = DataSource(
            collectionView: collectionView!,
            cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in
                switch video {
                case .variation(let data):
                    return self.configureVariation(collectionView, indexPath, data)
                case .images(let data):
                    return self.configureImages(collectionView, indexPath, data)
                }
            }
        )
        confgiureHeaderFooter(dataSource)
        return dataSource
    }
    
    
    
    func displayExerciseDetail(viewModel:ExerciseDetailListViewModel){
        self.viewModel = viewModel
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.images, .variation])
        
            snapshot.appendItems(viewModel.images.map { Item.images($0) } , toSection: .images)
            snapshot.appendItems(viewModel.variations.map { Item.variation($0) } , toSection: .variation)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }


}




extension ExerciseDetailListViewController {
    
    /// Layout for Images
    fileprivate func getImageLayout() -> NSCollectionLayoutSection? {
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
    /// Layout for Variations
    fileprivate func getVariationLayout() -> NSCollectionLayoutSection? {
        let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.6))
        let item = NSCollectionLayoutItem(layoutSize: itemsize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(3)
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
    /// Configure Variation Cell
    fileprivate func configureVariation(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ data: (Int)) -> UICollectionViewCell? {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ButtonCell.self), for: indexPath) as? ButtonCell

        cell?.btnVariation.setTitle(String(data), for: .normal)

        cell?.btnVariation.addAction(
            UIAction(handler: { action in
//                let vc =
//                    self.storyboard?.instantiateViewController(withIdentifier: String(describing: ExerciseDetailViewController.self))
//                    as! ExerciseDetailViewController
////                vc.exercise = self.exercise
//                self.navigationController?.pushViewController(vc, animated: true)
                self.performSegue(withIdentifier: "ExerciseDetailViewController", sender: nil)
            }),
            for: .touchUpInside
        )

        return cell
    }
    /// Configure Images Cell
    fileprivate func configureImages(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ data: (String)) -> UICollectionViewCell? {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AlbumItemCell.self), for: indexPath)
            as? AlbumItemCell

        cell?.imgCell.kf.indicatorType = .activity
        cell?.imgCell.kf.setImage(with: data.url)

        return cell
    }
    /// Configure Supplementary views
    fileprivate func confgiureHeaderFooter(_ dataSource: ExerciseDetailListViewController.DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in

            if kind == UICollectionView.elementKindSectionHeader {
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let view =
                    collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: String(describing: CategoryHeaderView.self),
                        for: indexPath
                    ) as? CategoryHeaderView
                view?.lblTitle.text = section == .images ? self.viewModel?.name ?? "" : "Variations"

                return view
            } else {
                let view =
                    collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: String(describing: CategoryFooterView.self),
                        for: indexPath
                    ) as? CategoryFooterView

                view?.lblTitle.text = ""

                return view
            }
        }
    }

}
