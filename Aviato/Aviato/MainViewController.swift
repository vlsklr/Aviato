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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.navigationController?.navigationBar.backgroundColor = .systemBlue
        setupSearchbar()
        setupSwipeDown()
        
        
        // Do any additional setup after loading the view.
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

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        print(searchBarText)
        let popViewController = FoundFlyghtViewController()
        self.present(popViewController, animated: true, completion: nil)
        //presenter?.downloadImage(stringURL: searchBarText)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
