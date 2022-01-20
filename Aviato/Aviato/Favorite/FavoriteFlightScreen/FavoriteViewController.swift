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
    let aircraftImage: UIImageView = UIImageView()
    var scrollView: UIScrollView = UIScrollView()
    let alertController = AlertController()
    let textColor: UIColor = .black
    let labelBackgroundColor: UIColor = .white
    
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(aircraftImage: UIImage) {
        self.aircraftImage.image = aircraftImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.243, green: 0.776, blue: 1, alpha: 1)
        alertController.view = self
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
        setupAircraftImageView()
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
        flyghtNumberLabel.backgroundColor = labelBackgroundColor
        flyghtNumberLabel.textColor = textColor
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
        flyghtStatusLabel.backgroundColor = labelBackgroundColor
        flyghtStatusLabel.textColor = textColor
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
        departureAirportLabel.numberOfLines = 0
        departureAirportLabel.backgroundColor = labelBackgroundColor
        departureAirportLabel.textColor = textColor
        departureAirportLabel.textAlignment = .center
        departureAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flyghtStatusLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupDepartureDateLabel() {
        self.scrollViewContainer.addArrangedSubview(departureDateLabel)
        departureDateLabel.numberOfLines = 0
        departureDateLabel.backgroundColor = labelBackgroundColor
        departureDateLabel.textColor = textColor
        departureDateLabel.textAlignment = .center
        departureDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureAirportLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupDeartureDateLocalLabel() {
        self.scrollViewContainer.addArrangedSubview(departureDateLocalLabel)
        departureDateLocalLabel.numberOfLines = 0
        departureDateLocalLabel.backgroundColor = labelBackgroundColor
        departureDateLocalLabel.textColor = textColor
        departureDateLocalLabel.textAlignment = .center
        departureDateLocalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureDateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalAirportLabel() {
        self.scrollViewContainer.addArrangedSubview(arrivalAirportLabel)
        arrivalAirportLabel.numberOfLines = 0
        arrivalAirportLabel.backgroundColor = labelBackgroundColor
        arrivalAirportLabel.textColor = textColor
        arrivalAirportLabel.textAlignment = .center
        arrivalAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(departureDateLocalLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalDateLabel() {
        self.scrollViewContainer.addArrangedSubview(arrivalDateLabel)
        arrivalDateLabel.numberOfLines = 0
        arrivalDateLabel.backgroundColor = labelBackgroundColor
        arrivalDateLabel.textColor = textColor
        arrivalDateLabel.textAlignment = .center
        arrivalDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalAirportLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupArrivalDateLocalLabel() {
        self.scrollViewContainer.addArrangedSubview(arrivalDateLocalLabel)
        arrivalDateLocalLabel.numberOfLines = 0
        arrivalDateLocalLabel.backgroundColor = labelBackgroundColor
        arrivalDateLocalLabel.textColor = textColor
        arrivalDateLocalLabel.textAlignment = .center
        arrivalDateLocalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalDateLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupAircraftLabel() {
        self.scrollViewContainer.addArrangedSubview(aircraftLabel)
        aircraftLabel.numberOfLines = 0
        aircraftLabel.clipsToBounds = true
        aircraftLabel.backgroundColor = labelBackgroundColor
        aircraftLabel.textColor = textColor
        aircraftLabel.textAlignment = .center
        aircraftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arrivalDateLocalLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.height.equalTo(75)
        }
    }
    
    func setupLabelsText(flyghtViewInfo: FlyghtViewModel) {
        flyghtNumberLabel.text = "\(RootViewController.labels!.flyghtNumber) \(flyghtViewInfo.airline) \(flyghtViewInfo.flyghtNumber)"
        arrivalDateLocalLabel.text = "\(RootViewController.labels!.arriveTimeLocal)  \(flyghtViewInfo.arrivalDateLocal)"
        arrivalAirportLabel.text = "\(RootViewController.labels!.arriveAirport) \(flyghtViewInfo.arrivalAirport)"
        departureDateLocalLabel.text = "\(RootViewController.labels!.departureTimeLocal)  \(RootViewController.labels!.departureTimeLocal) \(flyghtViewInfo.departureDateLocal)"
        flyghtStatusLabel.text = "\(RootViewController.labels!.flyghtStatus) \(flyghtViewInfo.status)"
        departureAirportLabel.text = "\(RootViewController.labels!.departureAirport)  \(flyghtViewInfo.departureAirport)"
        departureDateLabel.text = "\(RootViewController.labels!.departureTimeUTC)  \(flyghtViewInfo.departureDate)"
        arrivalDateLabel.text = "\(RootViewController.labels!.arriveTimeUTC) \(flyghtViewInfo.arrivalDate)"
        aircraftLabel.text = "\(RootViewController.labels!.aircraft) \(flyghtViewInfo.aircraft)"
        
    }
    
    func setupAircraftImageView() {
        self.scrollViewContainer.addArrangedSubview(aircraftImage)
        aircraftImage.backgroundColor = .white
        //        aircraftImage.layer.cornerRadius = 125
        aircraftImage.layer.cornerRadius = 25
        aircraftImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        aircraftImage.clipsToBounds = true
        aircraftImage.contentMode = .scaleAspectFit
        aircraftImage.snp.makeConstraints { (make) in
            make.top.equalTo(aircraftLabel.snp.bottom)
            make.leading.equalToSuperview().offset(43)
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
        //увеличиваем scrollView на высоту картинки
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + 250)        
    }
}
