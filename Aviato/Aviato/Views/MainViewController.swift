//
//  MainViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let searchBar: UISearchBar = UISearchBar()
    let presenter: IPresenter
//    let userID: UUID
    
    init(presenter: IPresenter) {
//        self.userID = userID
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.navigationController?.navigationBar.backgroundColor = .systemBlue
        setupSearchbar()
        setupSwipeDown()
    }
    
    func setupSwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func setupSearchbar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Найти рейс"
        searchBar.snp.makeConstraints { contsraint in
            contsraint.top.equalTo(view).offset(90)
            contsraint.centerX.equalToSuperview()
            contsraint.width.equalToSuperview()
            contsraint.height.equalTo(50)
        }
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
}

extension MainViewController: IFoundFlyghtViewController {
    func showFoundFlyght(flyghtViewInfo: FlyghtViewModel) {
        let popViewController = FoundFlyghtViewController(flyghtViewInfo: flyghtViewInfo, presenter: self.presenter)
        self.present(popViewController, animated: true, completion: nil)
    }
    
    
}


extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        print(searchBarText)
        presenter.findFlyghtInfo(view: self, flyghtNumber: searchBarText)
        
//        let popViewController = FoundFlyghtViewController(userID: userID)
//        self.present(popViewController, animated: true, completion: nil)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
