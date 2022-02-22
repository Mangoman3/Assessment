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

class AlbumItemCell: UICollectionViewCell {
    @IBOutlet var imgCell: UIImageView!
}
class CategoryHeaderView: UICollectionReusableView {
    @IBOutlet var lblTitle: UILabel!
}
class CategoryFooterView: UICollectionReusableView {
    @IBOutlet var lblTitle: UILabel!
}

class ExerciseDetailViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?
    private var subscriptions = Set<AnyCancellable>()
    let viewModel = ExerciseDetailViewModel()
    typealias DataSource = UICollectionViewDiffableDataSource<Exercise, ImageData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Exercise, ImageData>
    private lazy var dataSource = makeDataSource()
    var exercise: [Exercise] = []
    var variation = [Int]()

    private var maxSectionCount: Int {
        return exercise.first?.variations?.count ?? 0
    }

    private var loadingInProgress = false

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        variation = exercise.first?.variations ?? []
        variation.insert(exercise.first?.id ?? 0, at: 0)
        applySnapshot(data: exercise)
        collectionView?.delegate = self
        collectionView?.collectionViewLayout = createCompositionalLayout()
        view.addSubview(loadingIndicator)
        let layoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10),
        ])
        collectionView!.contentInset.bottom = 50
        binding()
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            return self.setupLayoutSection()
        }
    }

    private func setupLayoutSection() -> NSCollectionLayoutSection {
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
        return dataSource
    }

    func applySnapshot(data: [Exercise]) {

        var snapshot = dataSource.snapshot()
        snapshot.appendSections(data)

        data.forEach { section in
            snapshot.appendItems(section.images ?? [], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    private func binding() {
        viewModel.$exercise
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                if let data = items, data.name != nil {
                    self.applySnapshot(data: [data])
                }
                self.loadingInProgress = false
                self.loadingIndicator.stopAnimating()
            }
            .store(in: &subscriptions)
    }
}

extension ExerciseDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.y
        let section = dataSource.snapshot().numberOfSections
        print(maxSectionCount, dataSource.snapshot().numberOfSections)
        if contentOffsetX >= (scrollView.contentSize.height - scrollView.bounds.height) - 50 {
            guard !loadingInProgress, maxSectionCount + 1 > section else { return }
            loadingInProgress = true
            viewModel.getHomeData(id: variation[section])
            loadingIndicator.startAnimating()
        }
    }
}

class ExerciseDetailViewModel: NSObject {

    private var cancellables = Set<AnyCancellable>()
    @Published var exercise: Exercise?

    func getHomeData(id: Int) {

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
