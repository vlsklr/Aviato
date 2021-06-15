//
//  FavoriteFlyghtListViewController.swift
//  Aviato
//
//  Created by Vlad on 14.06.2021.
//

import UIKit
import SnapKit

class FavoriteFlyghtListViewController: UIViewController {
    
    let userID: UUID
    let tableView: UITableView = UITableView()
    
    let tmpStorage: IStorageManager = StorageManager()
    
    
    
    init(userID: UUID) {
        self.userID = userID
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
            let flyghtID = self.tmpStorage.getFlyghts(userID: self.userID)![indexPath.row]

            self.tmpStorage.removeFlyght(flyghtID: flyghtID.flyghtID, completion: {
                tableView.reloadData()

            })
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flyght: FlyghtViewModel = tmpStorage.getFlyghts(userID: userID)![indexPath.row]
        let popViewController = FavoriteViewController(flyghtID: flyght.flyghtID)
        self.present(popViewController, animated: true, completion: nil)
        
    }
}

extension FavoriteFlyghtListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpStorage.getFlyghts(userID: userID)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FlyghtViewCell
        cell.setupCell()
        let getter:[FlyghtViewModel] = tmpStorage.getFlyghts(userID: userID)!
        cell.flyghtNumberLabel.text = getter[indexPath.row].flyghtNumber
        return cell
    }
    
    
}
