//
//  GameDetailViewController.swift
//  TestCase
//
//  Created by Shehryar on 13/04/2021.
//

import UIKit

class GameDetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    var gameId = 0
    
    lazy var viewModel:GameDetailViewModel = {
        let vm = GameDetailViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getGameDetail(id: gameId)
        viewModel.updateData = {
            self.setViews()
        }
    }
    
    private func initialSetup() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = nil
        let navButton = UIBarButtonItem(title: viewModel.getButtonTitle(), style: .plain, target: self, action: #selector(navButtonAction))
        
       // let font = UIFont.systemFont(ofSize: 12)
        
//        /*Changing color*/
//        cancelBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor: UIColor.tint_2], for: .normal)
//        cancelBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor: UIColor.tint_2], for: .selected)
        self.navigationItem.rightBarButtonItem = navButton
    }
    
    private func setViews() {
        self.lblTitle.text = viewModel.item?.name
        self.lblDescription.text = viewModel.item?.description_raw
        viewModel.setImage(imageView: imgTitle)
        setNavigationBarItem()
    }
    
    //MARK: User Actions
    @IBAction func btnVisitRedditAction(_ sender: UIButton) {
        viewModel.redditAction()
    }
    
    @IBAction func btnVisitWebsiteAction(_ sender: UIButton) {
        viewModel.websiteAction()
    }
    
    @IBAction func navButtonAction(_ sender: UIButton) {
        viewModel.navigationButtonAction(viewController: self)
    }
}

extension GameDetailViewController: GameDetailViewModelDelegate {
    func didGameStatusUpdated() {
        setNavigationBarItem()
    }
}
