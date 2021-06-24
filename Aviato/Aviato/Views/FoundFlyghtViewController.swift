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
    let departureDateLocalLabel: UILabel = UILabel()
    let arrivalAirportLabel: UILabel = UILabel()
    let arrivalDateLabel: UILabel = UILabel()
    let arrivalDateLocalLabel: UILabel = UILabel()
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
        self.view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        setupFlyghtNumberLabel()
        setupDepartureAirportLabel()
        setupDepartureDateLabel()
        setupDeartureDateLocalLabel()
        setupArrivalAirportLabel()
        setupArrivalDateLabel()
        setupArrivalDateLocalLabel()
        setupAircraftLabel()
        setupButton()

    }
    
    func setupFlyghtNumberLabel() {
        self.view.addSubview(flyghtNumberLabel)
        flyghtNumberLabel.text = "Номер рейса \(flyghtViewInfo.airline) \(flyghtViewInfo.flyghtNumber)"
        flyghtNumberLabel.backgroundColor = .white
        flyghtNumberLabel.layer.cornerRadius = 25
        flyghtNumberLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        flyghtNumberLabel.clipsToBounds = true
        flyghtNumberLabel.textAlignment = .center
        flyghtNumberLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
    }
    
    func setupDepartureAirportLabel() {
        self.view.addSubview(departureAirportLabel)
        departureAirportLabel.text = "Аэропорт отбытия \(flyghtViewInfo.departureAirport)"
        departureAirportLabel.numberOfLines = 0
        departureAirportLabel.backgroundColor = .white
        departureAirportLabel.textAlignment = .center
        departureAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flyghtNumberLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
    }
    
    func setupDepartureDateLabel() {
        self.view.addSubview(departureDateLabel)
        departureDateLabel.text = "Время отбытия UTC \(flyghtViewInfo.departureDate)"
        departureDateLabel.numberOfLines = 0
        departureDateLabel.backgroundColor = .white
        departureDateLabel.textAlignment = .center
        departureDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureAirportLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
    }
    
    func setupDeartureDateLocalLabel() {
        self.view.addSubview(departureDateLocalLabel)
        departureDateLocalLabel.text = "Время отбытия местное \(flyghtViewInfo.departureDateLocal)"
        departureDateLocalLabel.numberOfLines = 0
        departureDateLocalLabel.backgroundColor = .white
        departureDateLocalLabel.textAlignment = .center
        departureDateLocalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureDateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalAirportLabel() {
        self.view.addSubview(arrivalAirportLabel)
        arrivalAirportLabel.text = "Аэропорт прибытия \(flyghtViewInfo.arrivalAirport)"
        arrivalAirportLabel.numberOfLines = 0
        arrivalAirportLabel.backgroundColor = .white
        arrivalAirportLabel.textAlignment = .center
        arrivalAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureDateLocalLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalDateLabel() {
        self.view.addSubview(arrivalDateLabel)
        arrivalDateLabel.text = "Время прибытия UTC \(flyghtViewInfo.arrivalDate)"
        arrivalDateLabel.numberOfLines = 0
        arrivalDateLabel.backgroundColor = .white
        arrivalDateLabel.textAlignment = .center
        arrivalDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalAirportLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalDateLocalLabel() {
        self.view.addSubview(arrivalDateLocalLabel)
        arrivalDateLocalLabel.text = "Время прибытия местное \(flyghtViewInfo.arrivalDateLocal)"
        arrivalDateLocalLabel.numberOfLines = 0
        arrivalDateLocalLabel.backgroundColor = .white
        arrivalDateLocalLabel.textAlignment = .center
        arrivalDateLocalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalDateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
    }
    
    func setupAircraftLabel() {
        self.view.addSubview(aircraftLabel)
        aircraftLabel.text = "Самолет \(flyghtViewInfo.aircraft)"
        aircraftLabel.numberOfLines = 0
        aircraftLabel.clipsToBounds = true
        aircraftLabel.backgroundColor = .white
        aircraftLabel.layer.cornerRadius = 25
        aircraftLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        aircraftLabel.textAlignment = .center
        aircraftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalDateLocalLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(75)
        }
        
    }
    
    func setupButton() {
        self.view.addSubview(saveButton)
        saveButton.setTitle("Добавить в избранное", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.borderWidth = 3
        
        saveButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        saveButton.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-50)
            make.top.equalTo(aircraftLabel.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(43)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func addToFavorite() {
        presenter.addToFavorite(flyght: self.flyghtViewInfo)
        self.dismiss(animated: true, completion: nil)
    }
}

