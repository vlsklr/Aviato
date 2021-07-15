//
//  FavoriteViewController.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import UIKit
import SnapKit

class FavoriteViewController: UIViewController {
    
    let flyghtNumberLabel: UILabel = UILabel()
    let flyghtStatusLabel: UILabel = UILabel()
    let departureAirportLabel: UILabel = UILabel()
    let departureDateLabel: UILabel = UILabel()
    let departureDateLocalLabel: UILabel = UILabel()
    let arrivalAirportLabel: UILabel = UILabel()
    let arrivalDateLabel: UILabel = UILabel()
    let arrivalDateLocalLabel: UILabel = UILabel()
    let aircraftLabel: UILabel = UILabel()
    var flyghtViewInfo: FlyghtViewModel
    var scrollView: UIScrollView = UIScrollView()
    
    let scrollViewContainer: UIStackView = {
           let view = UIStackView()

           view.axis = .vertical
           view.spacing = 10

           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
    
    init(flyghtViewInfo: FlyghtViewModel) {
        self.flyghtViewInfo = flyghtViewInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        setupScrollView()
        setupFlyghtNumberLabel()
        setupFlyghtStatusLabel()
        setupDepartureAirportLabel()
        setupDepartureDateLabel()
        setupDeartureDateLocalLabel()
        setupArrivalAirportLabel()
        setupArrivalDateLabel()
        setupArrivalDateLocalLabel()
        setupAircraftLabel()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()

        }
        scrollViewContainer.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-43)
        }
    }
    
    func setupFlyghtNumberLabel() {
        self.scrollViewContainer.addArrangedSubview(flyghtNumberLabel)
        flyghtNumberLabel.text = "Номер рейса \(flyghtViewInfo.airline) \(flyghtViewInfo.flyghtNumber)"
        flyghtNumberLabel.backgroundColor = .white
        flyghtNumberLabel.layer.cornerRadius = 25
        flyghtNumberLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        flyghtNumberLabel.clipsToBounds = true
        flyghtNumberLabel.textAlignment = .center
        flyghtNumberLabel.numberOfLines = 0

        flyghtNumberLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupFlyghtStatusLabel() {
        self.scrollViewContainer.addArrangedSubview(flyghtStatusLabel)
        flyghtStatusLabel.text = "Статус рейса: \(flyghtViewInfo.status)"
        flyghtStatusLabel.backgroundColor = .white
        flyghtStatusLabel.numberOfLines = 0
        flyghtStatusLabel.clipsToBounds = true
        flyghtStatusLabel.textAlignment = .center
        flyghtStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flyghtNumberLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }

    
    func setupDepartureAirportLabel() {
        self.scrollViewContainer.addArrangedSubview(departureAirportLabel)
        departureAirportLabel.text = "Аэропорт отбытия \(flyghtViewInfo.departureAirport)"
        departureAirportLabel.numberOfLines = 0
        departureAirportLabel.backgroundColor = .white
        departureAirportLabel.textAlignment = .center
        departureAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flyghtStatusLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupDepartureDateLabel() {
        self.scrollViewContainer.addArrangedSubview(departureDateLabel)
        departureDateLabel.text = "Время отбытия UTC \(flyghtViewInfo.departureDate)"
        departureDateLabel.numberOfLines = 0
        departureDateLabel.backgroundColor = .white
        departureDateLabel.textAlignment = .center
        departureDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureAirportLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupDeartureDateLocalLabel() {
        self.scrollViewContainer.addArrangedSubview(departureDateLocalLabel)
        departureDateLocalLabel.text = "Время отбытия местное \(flyghtViewInfo.departureDateLocal)"
        departureDateLocalLabel.numberOfLines = 0
        departureDateLocalLabel.backgroundColor = .white
        departureDateLocalLabel.textAlignment = .center
        departureDateLocalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureDateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalAirportLabel() {
        self.scrollViewContainer.addArrangedSubview(arrivalAirportLabel)
        arrivalAirportLabel.text = "Аэропорт прибытия \(flyghtViewInfo.arrivalAirport)"
        arrivalAirportLabel.numberOfLines = 0
        arrivalAirportLabel.backgroundColor = .white
        arrivalAirportLabel.textAlignment = .center
        arrivalAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureDateLocalLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalDateLabel() {
        self.scrollViewContainer.addArrangedSubview(arrivalDateLabel)
        arrivalDateLabel.text = "Время прибытия UTC \(flyghtViewInfo.arrivalDate)"
        arrivalDateLabel.numberOfLines = 0
        arrivalDateLabel.backgroundColor = .white
        arrivalDateLabel.textAlignment = .center
        arrivalDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalAirportLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalDateLocalLabel() {
        self.scrollViewContainer.addArrangedSubview(arrivalDateLocalLabel)
        arrivalDateLocalLabel.text = "Время прибытия местное \(flyghtViewInfo.arrivalDateLocal)"
        arrivalDateLocalLabel.numberOfLines = 0
        arrivalDateLocalLabel.backgroundColor = .white
        arrivalDateLocalLabel.textAlignment = .center
        arrivalDateLocalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalDateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupAircraftLabel() {
        self.scrollViewContainer.addArrangedSubview(aircraftLabel)
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
            make.height.equalTo(75)
        }
    }
}