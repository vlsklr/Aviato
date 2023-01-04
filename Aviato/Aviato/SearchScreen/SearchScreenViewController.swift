//
//  MainViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

protocol ISearchScreenViewController: UIViewController {
    func toggleActivityIndicator()
    func showFoundFlyght(foundFlyghtView: FoundFlyghtViewController)
}

class SearchScreenViewController: UIViewController {
    
    // MARK: - VisualConstants
    
    private enum VisualConstants {
        static let titleLabelFont = UIFont(name: "Wadik", size: 16.0)
        static let rockStarRegularfont = UIFont(name: "RockStar", size: 14.0)
        static let rockStarRegularfont12 = UIFont(name: "RockStar", size: 12.0)
        static let textFieldBackgroundColor = UIColor(red: 1, green: 0.8, blue: 1, alpha: 0.1)
        static let backgroundColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        static let verticalMargins: CGFloat = 16.0
        static let cornerRadius: CGFloat = 10.0
    }
    
    // MARK: - Properties
    
    let titleLabel: UILabel
    let logoView: UIImageView
    let searchField: UITextField
    let searchButton: UIButton
    let historyButton: UIButton
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let presenter: ISearchScreenPresenter
    var searchButtonPressed: Bool = false
    
    // MARK: - Initializers
    
    init(presenter: ISearchScreenPresenter) {
        titleLabel = UILabel()
        logoView = UIImageView()
        searchField = UITextField()
        searchButton = UIButton()
        historyButton = UIButton()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI Management

extension SearchScreenViewController {
    
    private func setupUI() {
        setupTitleLabel()
        setupLogoView()
        setupSearchField()
        setupSearchButton()
        setupSwipeDown()
        setupActivityIndicator()
        setupHistoryButton()
        view.backgroundColor = VisualConstants.backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.font = VisualConstants.titleLabelFont
        titleLabel.textColor = .white
        titleLabel.text = RootViewController.labels?.searchScreenTitle
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupLogoView() {
        view.addSubview(logoView)
        logoView.image = UIImage(named: "aviato_logo")
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(94)
        }
    }
    
    private func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
    }
    
    private func setupSearchButton() {
        view.addSubview(searchButton)
        let title = NSAttributedString(string: RootViewController.labels!.findFlyghtButton,
                                       attributes:
                                        [NSAttributedString.Key.font:
                                            VisualConstants.rockStarRegularfont!,
                                         NSAttributedString.Key.foregroundColor:
                                            UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)])
        searchButton.layer.cornerRadius = VisualConstants.cornerRadius
        searchButton.backgroundColor = .white
        searchButton.setAttributedTitle(title, for: .normal)

        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(toggleAnimationButtonColor(button:)), for: .touchUpInside)
        searchButton.snp.makeConstraints { (make) in
            make.top.equalTo(searchField.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(VisualConstants.verticalMargins)
            make.trailing.equalToSuperview().offset(-1 * VisualConstants.verticalMargins)
            make.height.equalTo(52)
        }
    }
    
    private func setupSearchField() {
        view.addSubview(searchField)
        let placeholder = NSAttributedString(string: RootViewController.labels!.searchBarPlaceholder,
                                       attributes:
                                        [NSAttributedString.Key.font:
                                            VisualConstants.rockStarRegularfont!,
                                         NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        searchField.attributedPlaceholder = placeholder
        searchField.layer.cornerRadius = VisualConstants.cornerRadius
        searchField.backgroundColor = VisualConstants.textFieldBackgroundColor
        searchField.textAlignment = .center
        searchField.font = VisualConstants.rockStarRegularfont
        searchField.textColor = .white
        searchField.returnKeyType = .search
        searchField.clearButtonMode = .whileEditing
        searchField.delegate = self
    
        searchField.snp.makeConstraints { contsraint in
            contsraint.top.equalTo(logoView.snp.bottom).offset(24)
            contsraint.height.equalTo(52)
            contsraint.leading.equalToSuperview().offset(VisualConstants.verticalMargins)
            contsraint.trailing.equalToSuperview().offset(-1 * VisualConstants.verticalMargins)
        }
    }
    
    private func setupHistoryButton() {
        view.addSubview(historyButton)
        let title = NSAttributedString(string: RootViewController.labels!.searchHistoryButtonTitle,
                                      attributes:
                                       [NSAttributedString.Key.font:
                                           VisualConstants.rockStarRegularfont12!,
                                        NSAttributedString.Key.foregroundColor:
                                            UIColor.white])
        historyButton.setAttributedTitle(title, for: .normal)
        historyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchButton.snp.bottom).offset(16)
        }
    }
    
}

// MARK: - Private methods

extension SearchScreenViewController {
    
    @objc private func search() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.toggleAnimationButtonColor(button: self?.searchButton)
        }
        guard let searchText = searchField.text else { return }
        presenter.findFlyghtInfo(flyghtNumber: searchText)
    }
    
    @objc private func toggleAnimationButtonColor(button: UIButton?) {
        guard let button else { return }
        var animator = UIViewPropertyAnimator()
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut, animations: { [unowned self] in
            button.backgroundColor = self.searchButtonPressed ? VisualConstants.textFieldBackgroundColor : .white
            button.layer.borderColor = self.searchButtonPressed ? UIColor.white.cgColor : VisualConstants.textFieldBackgroundColor.cgColor
            button.setTitleColor(self.searchButtonPressed ? UIColor.white : VisualConstants.textFieldBackgroundColor, for: .highlighted)
        })
        searchButtonPressed = !searchButtonPressed
        animator.startAnimation()
    }
    
}

extension SearchScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchBarText = textField.text else { return false}
        presenter.findFlyghtInfo(flyghtNumber: searchBarText)
        return true
    }
    
}

extension SearchScreenViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setupSwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
}


extension SearchScreenViewController: ISearchScreenViewController {
    
    func toggleActivityIndicator() {
        activityIndicator.isAnimating ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
    func showFoundFlyght(foundFlyghtView: FoundFlyghtViewController) {
        present(foundFlyghtView, animated: true, completion: nil)
    }
    
}
