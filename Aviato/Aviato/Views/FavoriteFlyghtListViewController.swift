//
//  FavoriteFlyghtListViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

class FavoriteFlyghtListViewController: UIViewController {
    
    //    let userID: UUID
    let tableView: UITableView = UITableView()
    let presenter: IPresenter
    
    init(presenter: IPresenter) {
        //        self.userID = userID
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
        self.view.backgroundColor = .cyan
        
        // Do any additional setup after loading the view.
    }
    func initTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FlyghtViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview()
            constraint.width.equalToSuperview()
            constraint.height.equalToSuperview()
        }
    }
}

extension FavoriteFlyghtListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            if let flyghtID = self.presenter.getFlyghts()?[indexPath.row] {
                self.presenter.removeFlyght(flyghtID: flyghtID.flyghtID, completion: {
                    tableView.reloadData()
                })
            }
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.getFavorite(view: self, indexPath: indexPath)
        
    }
}

extension FavoriteFlyghtListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getFlyghts()?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlyghtViewCell
        cell.setupCell()
        if let getter:[FlyghtViewModel] = presenter.getFlyghts() {
            if indexPath.row < getter.count {
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
