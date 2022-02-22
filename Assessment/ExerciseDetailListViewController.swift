//
//  ExerciseDetailVariationViewController.swift
//  Assessment
//
//  Created by Arsalan Ghaffar on 2/22/22.
//

import Foundation
import UIKit


class ExerciseDetailListViewController: UIViewController {
    
    let viewModel = ExerciseDetailViewModel()
    @IBOutlet var collectionView: UICollectionView?
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private lazy var dataSource = makeDataSource()
    var exercise : [Exercise] = []
    

    enum Section: Hashable {
        case images
        case variation
    }
    
    enum Item: Hashable {
        case images(String)
        case variation(Int)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applySnapshot()
        collectionView?.register(UINib(nibName: ButtonCell.nibName, bundle: nil), forCellWithReuseIdentifier: ButtonCell.nibName)
        collectionView?.collectionViewLayout = createCompositionalLayout()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {(index, env) -> NSCollectionLayoutSection? in

            let section = self.dataSource.snapshot().sectionIdentifiers[index]
            switch section {
            
            case .images:
                let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(0.8))
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
            case .variation:
                let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(0.6))
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
        }
    }
    
    
    func makeDataSource() -> DataSource {
        
        let dataSource = DataSource(
            collectionView: collectionView!,
            cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in
                switch video {
                case .variation(let data) :
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ButtonCell.self),for: indexPath) as? ButtonCell
                                 
                    cell?.btnVariation.setTitle(String(data), for: .normal)
                   
                    cell?.btnVariation.addAction(UIAction(handler: { action in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ExerciseDetailViewController.self)) as! ExerciseDetailViewController
                        vc.exercise = self.exercise
                        self.navigationController?.pushViewController(vc, animated: true)
                    }), for: .touchUpInside)

                    return cell
                case .images(let data) :
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AlbumItemCell.self),for: indexPath) as? AlbumItemCell

                    cell?.imgCell.kf.indicatorType = .activity
                    cell?.imgCell.kf.setImage(with: data.url)

                    return cell
                }
                
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            if kind == UICollectionView.elementKindSectionHeader {
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let view =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: CategoryHeaderView.self),
                    for: indexPath
                ) as? CategoryHeaderView
                view?.lblTitle.text = section == .images ? self.exercise.first?.name ?? "" : "Variations"

                return view
            } else {
                let view =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier:String(describing: CategoryFooterView.self),
                    for: indexPath
                ) as? CategoryFooterView
                
                view?.lblTitle.text = ""

                return view
            }
        }
        return dataSource
    }

    func applySnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.images, .variation])
        if let exercise = self.exercise.first {
            snapshot.appendItems(exercise.images?.map{Item.images($0.image)} ?? [], toSection: .images)
            snapshot.appendItems(exercise.variations?.map{Item.variation($0)} ?? [], toSection: .variation)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
        
}
