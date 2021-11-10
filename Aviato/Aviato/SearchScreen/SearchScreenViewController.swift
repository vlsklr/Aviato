//
//  MainViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

class SearchScreenViewController: UIViewController {
    
    let searchBar: UISearchBar = UISearchBar()
    let searchButton: UIButton = UIButton()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let verticalMargins: CGFloat = 16.0
    let presenter: ISearchScreenPresenter
    var searchButtonPressed: Bool = false
    
    init(presenter: ISearchScreenPresenter) {
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
        setupActivityIndicator()
        if let airportImage = UIImage(named: "airport_bgc") {
            self.view.backgroundColor = UIColor(patternImage: airportImage)
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
    }
    
    func setupSearchButton() {
        self.view.addSubview(searchButton)
        searchButton.backgroundColor = .white
        searchButton.layer.borderColor = #colorLiteral(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        searchButton.layer.borderWidth = 3
        searchButton.setTitle(RootViewController.labels!.findFlyghtButton, for: .normal)
        searchButton.setTitleColor(UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .normal)
        searchButton.layer.cornerRadius = 25
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button:)), for: .touchDown)
        searchButton.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(verticalMargins)
            make.trailing.equalToSuperview().offset(-1 * verticalMargins)
            make.height.equalTo(50)
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
        searchBar.placeholder = RootViewController.labels!.searchBarPlaceholder
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 25
        searchBar.layer.borderColor = #colorLiteral(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        searchBar.layer.borderWidth = 3
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = .white
            searchBar.barTintColor = .white
            searchBar.searchTextField.textColor = .black
        } else {
            // Fallback on earlier versions
        }
        searchBar.snp.makeConstraints { contsraint in
            contsraint.top.equalTo(view).offset(250)
            contsraint.centerX.equalToSuperview()
            contsraint.height.equalTo(50)
            contsraint.leading.equalToSuperview().offset(verticalMargins)
            contsraint.trailing.equalToSuperview().offset(-1 * verticalMargins)
        }
        searchBar.setCenteredPlaceHolder(viewWidth: view.bounds.width, verticalMargins: verticalMargins)
    }
    
    @objc func search() {
        toggleAnimationButtonColor(button: self.searchButton)
        guard let searchBarText = searchBar.text else { return }
        print(searchBarText)
        presenter.findFlyghtInfo(view: self, flyghtNumber: searchBarText)
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    //Анимированно переключает цвет кнопки при нажатии на нее
    @objc func toggleAnimationButtonColor(button: UIButton) {
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: {
            button.backgroundColor = self.searchButtonPressed ? UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1) : .white
            button.layer.borderColor = self.searchButtonPressed ? UIColor.white.cgColor : UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1).cgColor
            button.setTitleColor(self.searchButtonPressed ? UIColor.white : UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .highlighted)
        })
        searchButtonPressed = !searchButtonPressed
        animator.startAnimation()
    }
}
//Расширение SearchBar помещающее placeholder в центр
extension UISearchBar {
    func setCenteredPlaceHolder(viewWidth: CGFloat, verticalMargins: CGFloat){
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let margins:CGFloat = verticalMargins * 2
        let searchBarWidth = viewWidth - margins
        let placeholderIconWidth = textFieldInsideSearchBar?.leftView?.frame.width
        let placeHolderWidth = textFieldInsideSearchBar?.attributedPlaceholder?.size().width
        let offsetIconToPlaceholder: CGFloat = 8
        let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder
        
        let offset = UIOffset(horizontal: ((searchBarWidth / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon), vertical: 0)
        self.setPositionAdjustment(offset, for: .search)
    }
}


extension SearchScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        print(searchBarText)
        presenter.findFlyghtInfo(view: self, flyghtNumber: searchBarText)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}

extension SearchScreenViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

protocol IMainViewController: IAlert {
    func toggleActivityIndicator()
    func showFoundFlyght(foundFlyghtViewController: FoundFlyghtViewController)
}

extension SearchScreenViewController: IAlert {
    func showAlert(message: String) {
        let alert = UIAlertController(title: RootViewController.labels!.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
}

extension SearchScreenViewController: IMainViewController {
    func showFoundFlyght(foundFlyghtViewController: FoundFlyghtViewController) {
        self.present(foundFlyghtViewController, animated: true, completion: nil)
    }
    
    func toggleActivityIndicator() {
        activityIndicator.isAnimating ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
}
