//
//  FavoriteFlyghtListViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

class FavoriteFlyghtListViewController: UIViewController {
    
    let tableView: UITableView = UITableView()
    let presenter: IPresenter
    
    init(presenter: IPresenter) {
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        
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
        tableView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview().offset(50)
            constraint.leading.equalToSuperview().offset(16)
            constraint.trailing.equalToSuperview().offset(-16)
            constraint.bottom.equalToSuperview().offset(-100)
        }
    }
}

extension FavoriteFlyghtListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
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
            presenter.getFavorite(view: self, flyghtID: entityID)
            
        }
    }
}

extension FavoriteFlyghtListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getFlyghts()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlyghtViewCell
        cell.backgroundColor = UIColor.clear
        
        if let getter:[FlyghtViewModel] = presenter.getFlyghts() {
            if indexPath.row < getter.count {
                cell.setupCell(id: getter[indexPath.row].flyghtID)
                cell.flyghtNumberLabel.text = "Рейс \(getter[indexPath.row].flyghtNumber)"
                cell.departireTimeLabel.text = "Отбывает в \(getter[indexPath.row].departureDate)"
            }
        }
        return cell
    }
}

extension FavoriteFlyghtListViewController: IFavoriteFlyghtViewController {
    func showFavoriteFlyght(flyghtViewInfo: FlyghtViewModel) {
        let popViewController = FavoriteViewController(flyghtViewInfo: flyghtViewInfo)
        self.present(popViewController, animated: true, completion: nil)
    }
}
