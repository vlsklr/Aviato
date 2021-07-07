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
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let verticalMargins: CGFloat = 16.0
    let presenter: IMainPresenter
    
    init(presenter: IMainPresenter) {
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
        searchButton.setTitle("Искать", for: .normal)
        searchButton.setTitleColor(UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1), for: .normal)
        searchButton.layer.cornerRadius = 25
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(anim), for: .touchDown)
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
        searchBar.placeholder = "Найти рейс"
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 25
        searchBar.layer.borderColor = #colorLiteral(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        searchBar.layer.borderWidth = 3
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


extension MainViewController: UISearchBarDelegate {
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

extension MainViewController: IMainViewController {
    func showFoundFlyght(foundFlyghtViewController: FoundFlyghtViewController) {
        self.present(foundFlyghtViewController, animated: true, completion: nil)
    }
    
    func toggleActivityIndicator() {
        activityIndicator.isAnimating ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
}
