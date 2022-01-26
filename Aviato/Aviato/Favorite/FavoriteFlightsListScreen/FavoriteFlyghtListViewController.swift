//
//  FavoriteFlyghtListViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

protocol IFavoriteFlyghtListViewController: AnyObject {
    var alertController: IAlert { get set }
    func getNumberOfSections() -> Int
    func getNumbersOfRowsInSection(section: Int) -> Int
    func getCell(at indexPath: IndexPath) -> IFlyghtViewCell
    func reloadTable()
    func toggleActivityIndicator()
    func showFlyght(flyghtVC: FavoriteViewController)
}

class FavoriteFlyghtListViewController: UIViewController, IFavoriteFlyghtListViewController {
  
    let tableView: UITableView = UITableView()
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private let presenter: IFavoriteFlyghtListPresenter
    private let refreshControll: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshFlyghts(sender:)), for: .valueChanged)
        return refresh
    }()
    var alertController: IAlert = AlertController()
    
    init(presenter: IFavoriteFlyghtListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initTableView()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertController.view = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.refreshControl = refreshControll
        initActivityIndicator()
    }
    
    @objc func refreshFlyghts(sender: UIRefreshControl) {
        presenter.updateFlyghtInfo()
        sender.endRefreshing()
    }
    
    func toggleActivityIndicator() {
        activityIndicator.isAnimating ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
    func initActivityIndicator() {
        tableView.addSubview(activityIndicator)
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
    }
    
    func initTableView() {
        view.addSubview(tableView)
        if let airportImage = UIImage(named: "airport_bgc") {
            self.view.backgroundColor = UIColor(patternImage: airportImage)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FlyghtViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 25
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview().offset(50)
            constraint.leading.equalToSuperview().offset(16)
            constraint.trailing.equalToSuperview().offset(-16)
            constraint.bottom.equalToSuperview().offset(-100)
        }
    }
    
    func getNumberOfSections() -> Int {
        return tableView.numberOfSections
    }
    
    func getNumbersOfRowsInSection(section: Int) -> Int {
        return tableView.numberOfRows(inSection: section)
    }
    
    func getCell(at indexPath: IndexPath) -> IFlyghtViewCell {
        return tableView.cellForRow(at: indexPath) as! IFlyghtViewCell
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showFlyght(flyghtVC: FavoriteViewController) {
        present(flyghtVC, animated: true, completion: nil)
    }
    
}

extension FavoriteFlyghtListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: RootViewController.labels?.deleteFlyghtButton) {[unowned self] _, _, complete in
            let cell = tableView.cellForRow(at: indexPath) as! FlyghtViewCell
            if let flyghtID = cell.entityID {
                self.presenter.removeFlyght(flyghtID: flyghtID)
                tableView.reloadData()
            }
            complete(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FlyghtViewCell
        if let entityID = cell.entityID {
            presenter.getFavorite(flyghtID: entityID)
            
        }
    }
}
extension FavoriteFlyghtListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getFlyghtsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlyghtViewCell
        cell.backgroundColor = UIColor.clear
        if let getter:[FlyghtViewModel] = presenter.getFlyghts() {
            if indexPath.row < getter.count {
                cell.setupCell(id: getter[indexPath.row].flyghtID)
                cell.flyghtNumberLabel.text = "\(RootViewController.labels!.favoriteCellFlyghtNumber)  \(getter[indexPath.row].flyghtNumber)"
                cell.departireTimeLabel.text = "\(RootViewController.labels!.favoriteCellDepartureDate)  \(getter[indexPath.row].departureDateLocal)"
            }
        }
        return cell
    }
}

