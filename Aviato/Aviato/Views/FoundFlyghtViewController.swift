//
//  FoundFlyghtViewController.swift
//  Aviato
//
//  Created by user188734 on 6/15/21.
//

import UIKit
import SnapKit

class FoundFlyghtViewController: UIViewController {
    let flyghtNumberLabel: UILabel = UILabel()
    let departureAirportLabel: UILabel = UILabel()
    let departureDateLabel: UILabel = UILabel()
    let arrivalAirportLabel: UILabel = UILabel()
    let arrivalDateLabel: UILabel = UILabel()
    let aircraftLabel: UILabel = UILabel()
    let saveButton: UIButton = UIButton()
    let flyghtViewInfo: FlyghtViewModel
    let presenter: IPresenter
    
    init(flyghtViewInfo: FlyghtViewModel, presenter: IPresenter) {
        self.presenter = presenter
        self.flyghtViewInfo = flyghtViewInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        setupButton()
        setupFlyghtNumberLabel()
        setupDepartureAirportLabel()
        setupDepartureDateLabel()
        setupArrivalAirportLabel()
        setupArrivalDateLabel()
        setupAircraftLabel()
    }
    
    func setupFlyghtNumberLabel() {
        self.view.addSubview(flyghtNumberLabel)
        flyghtNumberLabel.text = "Номер рейса \(flyghtViewInfo.airline) \(flyghtViewInfo.flyghtNumber)"
        flyghtNumberLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func setupDepartureAirportLabel() {
        self.view.addSubview(departureAirportLabel)
        departureAirportLabel.text = "Аэропорт отбытия \(flyghtViewInfo.departureAirport)"
        departureAirportLabel.numberOfLines = 0
        departureAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flyghtNumberLabel).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupDepartureDateLabel() {
        self.view.addSubview(departureDateLabel)
        departureDateLabel.text = "Время отбытия \(flyghtViewInfo.departureDate)"
        departureDateLabel.numberOfLines = 0
        departureDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureAirportLabel).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalToSuperview().offset(16)
            make.height.equalTo(50)
        }
    }
    
    func setupArrivalAirportLabel() {
        self.view.addSubview(arrivalAirportLabel)
        arrivalAirportLabel.text = "Аэропорт прибытия \(flyghtViewInfo.arrivalAirport)"
        arrivalAirportLabel.numberOfLines = 0
        arrivalAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureDateLabel).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func setupArrivalDateLabel() {
        self.view.addSubview(arrivalDateLabel)
        arrivalDateLabel.text = "Время прибытия \(flyghtViewInfo.arrivalDate)"
        arrivalDateLabel.numberOfLines = 0
        arrivalDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalAirportLabel).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalToSuperview().offset(16)
            make.height.equalTo(50)
        }
    }
    
    func setupAircraftLabel() {
        self.view.addSubview(aircraftLabel)
        aircraftLabel.text = "Самолет \(flyghtViewInfo.aircraft)"
        aircraftLabel.numberOfLines = 0
        aircraftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalDateLabel).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalToSuperview().offset(16)
            make.height.equalTo(50)
        }
        
    }
    
    func setupButton() {
        self.view.addSubview(saveButton)
        saveButton.setTitle("Добавить в избранное", for: .normal)
        saveButton.backgroundColor = .yellow
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func addToFavorite() {
        presenter.addToFavorite(flyght: self.flyghtViewInfo)
        self.dismiss(animated: true, completion: nil)
    }
}

