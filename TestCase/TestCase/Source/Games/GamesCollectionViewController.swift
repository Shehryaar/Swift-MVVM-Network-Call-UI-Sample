//
//  GamesCollectionViewController.swift
//  TestCase
//
//  Created by Shehryar on 15/04/2021.
//

import UIKit

class GamesCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var searchBar:UISearchBar?
    lazy var viewModel:GameViewModel = {
        let vm = GameViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
//        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.75, height: 50))
//        searchBar?.searchTextField.cornerRadius = 18
//        searchBar?.searchTextField.borderWidth = 0.5
//        searchBar?.searchTextField.borderColor = .tint_1
//        searchBar?.searchTextField.font = UIFont.systemFont(ofSize: 14)
//        searchBar?.placeholder = "What are you looking for?"
//        let leftNavBarButton = UIBarButtonItem(customView:searchBar!)
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        viewModel.updateData = {
            self.collectionView.reloadData()
        }
    }
    
    private func configureView() {
        self.backButtonRemoveText()
        self.transparentNavigation()
    }
    
    func initialSetup() {
        configureView()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(GameCollectionViewCell.nib, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
    }
    
    //MARK: User Actions
    @IBAction func filterAction(_ sender: UIButton) {
        // TODO:- fix transition - https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
       // let vc = FilterViewController.instantiateSearch()
       // transitionVc(vc: vc, duration: 0.5, type: .fromRight)
    }
}

extension GamesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items[section].rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.items[indexPath.section]
        switch item.type {
        case .game:
            if let gameItem = item as? Games, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as? GameCollectionViewCell {
                cell.gameData = gameItem.gamesList[indexPath.row]
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
}


extension GamesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let item = viewModel.items[indexPath.section]
        let width = collectionView.frame.size.width
//        switch item.type {
//        case .post:
//            if let post = item as? GameViewModelItem {
//                if post.postList[indexPath.row].isMarkingAllowed {
//                    return CGSize(width: (width/2)-1, height: width/2)
//                }
//                else {
//                    return CGSize(width: (width/3)-2, height: (width/3))
//                }
//            }
            return CGSize(width: width, height: 200)
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}


extension GamesCollectionViewController: GameViewModelDelegate {
    
}
