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
    let searchButton: UIButton = UIButton()
    let logoutButton: UIButton = UIButton()
    let presenter: IPresenter
    
    init(presenter: IPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .systemBlue
        setupSearchbar()
        setupSearchButton()
        setupSwipeDown()
        setupLogoutButton()
        if let airportImage = UIImage(named: "airport_bgc") {
            self.view.backgroundColor = UIColor(patternImage: airportImage)
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    @objc func logout() {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            
            self.logoutButton.backgroundColor = .white
            
        })
        animator.startAnimation()
        presenter.logout()
    }
    
    func setupSearchButton() {
        self.view.addSubview(searchButton)
        searchButton.backgroundColor = .white
        searchButton.layer.borderColor = #colorLiteral(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        searchButton.layer.borderWidth = 3
        searchButton.setTitle("Искать", for: .normal)
        searchButton.setTitleColor(UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .normal)
        searchButton.layer.cornerRadius = 25
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(anim), for: .touchDown)
        searchButton.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupLogoutButton() {
        self.view.addSubview(logoutButton)
        logoutButton.backgroundColor = .white
        logoutButton.layer.borderColor = #colorLiteral(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        logoutButton.layer.borderWidth = 3
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setTitleColor(UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .normal)
        logoutButton.layer.cornerRadius = 25
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(anim), for: .touchDown)
        logoutButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(75)
            //            make.centerX.equalToSuperview()
            //            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
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
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 25
        
        searchBar.layer.borderColor = #colorLiteral(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        searchBar.layer.borderWidth = 3
        
        searchBar.snp.makeConstraints { contsraint in
            contsraint.top.equalTo(view).offset(250)
            contsraint.centerX.equalToSuperview()
            contsraint.height.equalTo(50)
            contsraint.leading.equalToSuperview().offset(16)
            contsraint.trailing.equalToSuperview().offset(-16)
        }
    }
    
    @objc func search() {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            
            self.searchButton.backgroundColor = .white
            
        })
        animator.startAnimation()

        guard let searchBarText = searchBar.text else { return }
        print(searchBarText)
        presenter.findFlyghtInfo(view: self, flyghtNumber: searchBarText)
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
    @objc func anim(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            button.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
            button.layer.borderColor = UIColor.white.cgColor
            button.setTitleColor(.white, for: .highlighted)

        })
        animator.startAnimation()
      
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
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MainViewController: IAlert {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
}


