//
//  ViewController.swift
//  MinionMovies
//
//  Created by Vitor Costa on 26/02/20.
//  Copyright © 2020 Vitor Costa. All rights reserved.
//

import UIKit
import RealmSwift

protocol ViewProtocol {
    var interactor: InteractorProtocol? { get }
    var movies: [HomeViewModel]? { get set }
}

class HomeViewController: UIViewController, ViewProtocol {
    @IBOutlet private weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var interactor: InteractorProtocol?
    var movies: [HomeViewModel]? = [HomeViewModel]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: Initializers
//    init(configurator: HomeViewConfigurator = HomeViewConfigurator.sharedInstance) {
//        super.init(nibName: nil, bundle: nil)
//
//        configure(configurator: configurator)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        configure(configurator: HomeViewConfigurator.sharedInstance)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.searchTextField.textColor = .white
        print(Realm.Configuration.defaultConfiguration.fileURL)
        interactor?.theScreenIsLoading()
    }
    
    @IBAction func showSearchBar(_ sender: Any) {
        if searchBar.isHidden {
            searchBar.isHidden = false
            collectionViewTopConstraint.constant = 0
            view.layoutIfNeeded()
        } else if searchBar.isHidden == false {
            searchBar.isHidden = true
            collectionViewTopConstraint.constant = -56
            view.layoutIfNeeded()
        }
    }
    
//    private func configure(configurator: HomeViewConfigurator = HomeViewConfigurator.sharedInstance) {
//        configurator.configure(viewController: self)
//    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return MovieCell() }
        
        movieCell.populate(with: movies?[indexPath.row].poster ?? "")
        return movieCell
        
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieDetail = storyboard?.instantiateViewController(identifier: "MovieDetailController") as? MovieDetailController else { return }
//        movieDetail.movie = movies[indexPath.row]
        searchBar.endEditing(true)
        
        self.navigationController?.pushViewController(movieDetail, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.searching(string: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
