//
//  CategoriesViewController.swift
//  TestOnlineRestaurant
//
//  Created by Аслан Микалаев on 28.06.2023.
//

import UIKit
import SnapKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Private
    private var dishesModel: [Dishes] = []
    private let network = ServiceFactory.shared
    
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 14
        layout.itemSize = CGSize(
            width: (view.frame.size.width - 48) / 3,
            height: 144
        )
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            CategoriesPageCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoriesPageCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fetchDishesList()
    }
    
    // MARK: - Fetch dishes list
    func fetchDishesList() {
        network.allDishes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.dishesModel = data.dishes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: NetworkErrorTypes.emptyData.errorDescription ?? "Error")
                }
            }
        }
    }
}

// MARK: - Setup views
private extension CategoriesViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - Collection view data source and delegate
extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dishesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesPageCollectionViewCell.identifier, for: indexPath) as! CategoriesPageCollectionViewCell
        let selectedItem = dishesModel[indexPath.item]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.red.cgColor
        cell.configure(selectedItem)
        return cell
    }
}









import SwiftUI

struct MyProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MyProvider.ContainerView>) -> some CategoriesViewController {
            return CategoriesViewController()
        }
        
        func updateUIViewController(_ uiViewController: MyProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MyProvider.ContainerView>) {
            
        }
    }
}
