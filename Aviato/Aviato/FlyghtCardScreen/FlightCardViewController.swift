//
//  FavoriteViewController.swift
//  Aviato
//
//  Created by Vlad on 16.06.2021.
//

import UIKit
import SnapKit

class FlightCardViewController: UIViewController {
    
    // MARK: - Visual Constants
    
    private enum VisualConstants {
        static let closeButtonSize = 24.0
        static let closeButtonHorizontalMargin = -24.0
        static let closeButtonVerticalMargin = 20.0
        static let lagreHorizontalMargin = 32.0
        static let extraLagreHorizontalMargin = 62.0
        static let mediumHorizontalMargin = 16.0
        static let extraLargeVerticalMargin = 36.0
        static let largeVerticalMargin = 32.0
        static let mediumVerticalMargin = 16.0
        static let smallVerticalMargin = 8.0
        static let extraSmallVerticalMargin = 4.0
        static let ticketImageSize = 80.0
        static let flyghtInfoCornerRadius = 20.0
        static let customViewSectionSize = 10.0
        static let customViewWidth = 1.0
        static let favoriteButtonHeight = 52.0
        
        static let backgroundColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        static let flyghtInfoBackgroundColor = UIColor(red: 1, green: 0.8, blue: 1, alpha: 0.1)
        static let customViewColor = UIColor.white.withAlphaComponent(0.5)
        static let textColor = UIColor.white
        static let addToFavoriteTitleColor = UIColor(red: 0, green: 0, blue: 102 / 255, alpha: 1)
        static let removeFromFavoriteTitleColor = UIColor(red: 204 / 255, green: 0, blue: 153 / 255, alpha: 1)
        
        static let titleLabelFont = UIFont(name: "Wadik", size: 20.0)
        static let rockStarRegularFont = UIFont(name: "RockStar", size: 14.0)
        static let rockStarLightFont = UIFont(name: "RockStar-ExtraLight", size: 14.0)
        static let rockStarExtraLightFont = UIFont(name: "RockStar-ExtraLight", size: 12.0)
    }
    
    // MARK: - Properties
    
    private let presenter: FlightCardPresenter
    
    private lazy var closeButton = UIButton()
    private lazy var flightNumberLabel = UILabel()
    private lazy var flightStatusLabel = UILabel()
    private lazy var airlinesImageView = UIImageView()
    private lazy var airLinesNameLabel = UILabel()
    private lazy var aircraftLabel = UILabel()
    private lazy var enrouteTimeLabel = UILabel()
    private lazy var ticketImageView = UIImageView()
    private lazy var flyghtInfoView = UIView()
    private lazy var departureTitleLabel = UILabel()
    private lazy var departureTimeLabel = UILabel()
    private lazy var departureCityLabel = UILabel()
    private lazy var departureDateLabel = UILabel()
    private lazy var departureAirportLabel = UILabel()
    private lazy var arrivalTitleLabel = UILabel()
    private lazy var arrivalTimeLabel = UILabel()
    private lazy var arrivalCityLabel = UILabel()
    private lazy var arrivalDateLabel = UILabel()
    private lazy var arrivalAirportLabel = UILabel()
    private lazy var aircraftImageView = UIView()
    private lazy var favoriteButton = AviatoButton()
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    // MARK: - Initializer
    
    init(presenter: FlightCardPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = VisualConstants.backgroundColor
        setupScrollView()
        setupCloseButton()
        setupFlyghtNumberLabel()
        setupFlyghtStatusLabel()
        setupTicketImageView()
        setupAirlinesImageView()
        setupAirlinesNameLabel()
        setupAircraftLabel()
        setupEnrouteTimeLabel()
        setupFlyghtInfoView()
        setupAircraftImageView()
        setupFavoriteButton()
        setupLabelsText()
    }
}

// MARK: - UIManagement

private extension FlightCardViewController {
    
    func setupCloseButton() {
        contentView.addSubview(closeButton)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .allEvents)
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(VisualConstants.closeButtonHorizontalMargin)
            make.top.equalToSuperview().offset(VisualConstants.closeButtonVerticalMargin)
            make.width.equalTo(VisualConstants.closeButtonSize)
            make.height.equalTo(VisualConstants.closeButtonSize)
        }
    }
    
    func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
    }
    
    func setupFlyghtNumberLabel() {
        contentView.addSubview(flightNumberLabel)
        flightNumberLabel.textColor = VisualConstants.textColor
        flightNumberLabel.font = VisualConstants.titleLabelFont
        flightNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(VisualConstants.mediumVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.lagreHorizontalMargin)
        }
    }
    
    func setupFlyghtStatusLabel() {
        contentView.addSubview(flightStatusLabel)
        flightStatusLabel.textColor = VisualConstants.textColor
        flightStatusLabel.font = VisualConstants.rockStarRegularFont
        flightStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(flightNumberLabel.snp.bottom).offset(VisualConstants.smallVerticalMargin)
            make.leading.equalTo(flightNumberLabel.snp.leading)
        }
    }
    
    func setupTicketImageView() {
        contentView.addSubview(ticketImageView)
        ticketImageView.image = UIImage(named: "ticketImage")
        ticketImageView.snp.makeConstraints { make in
            make.top.equalTo(flightStatusLabel.snp.bottom).offset(VisualConstants.largeVerticalMargin)
            make.trailing.equalToSuperview().offset(-VisualConstants.largeVerticalMargin)
            make.height.equalTo(VisualConstants.ticketImageSize)
            make.width.equalTo(VisualConstants.ticketImageSize)
        }
    }
    
    func setupAirlinesImageView() {
        contentView.addSubview(airlinesImageView)
        // TODO: - Will be changed
        airlinesImageView.image = UIImage(named: "s7")
        airlinesImageView.snp.makeConstraints { make in
            make.top.equalTo(flightStatusLabel.snp.bottom).offset(VisualConstants.largeVerticalMargin)
            make.leading.equalTo(flightStatusLabel.snp.leading)
            make.width.equalTo(VisualConstants.closeButtonSize)
            make.height.equalTo(VisualConstants.closeButtonSize)
            
        }
    }
    
    func setupAirlinesNameLabel() {
        contentView.addSubview(airLinesNameLabel)
        airLinesNameLabel.textColor = VisualConstants.textColor
        airLinesNameLabel.font = VisualConstants.rockStarRegularFont
        airLinesNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(airlinesImageView.snp.trailing).offset(VisualConstants.smallVerticalMargin)
            make.top.equalTo(flightStatusLabel.snp.bottom).offset(VisualConstants.extraLargeVerticalMargin)
            make.trailing.equalTo(ticketImageView.snp.leading).offset(-VisualConstants.largeVerticalMargin)
        }
        
    }
    
    func setupAircraftLabel() {
        contentView.addSubview(aircraftLabel)
        aircraftLabel.textColor = VisualConstants.textColor
        aircraftLabel.font = VisualConstants.rockStarRegularFont
        aircraftLabel.snp.makeConstraints { make in
            make.top.equalTo(airlinesImageView.snp.bottom).offset(VisualConstants.smallVerticalMargin)
            make.leading.equalTo(flightStatusLabel.snp.leading)
            make.trailing.equalTo(ticketImageView.snp.leading).offset(-VisualConstants.largeVerticalMargin)
        }
    }
    
    func setupEnrouteTimeLabel() {
        contentView.addSubview(enrouteTimeLabel)
        enrouteTimeLabel.textColor = VisualConstants.textColor
        enrouteTimeLabel.font = VisualConstants.rockStarRegularFont
        enrouteTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(aircraftLabel.snp.bottom).offset(VisualConstants.smallVerticalMargin)
            make.leading.equalTo(flightStatusLabel.snp.leading)
            make.trailing.equalTo(ticketImageView.snp.leading).offset(-VisualConstants.largeVerticalMargin)
        }
    }
    
    func setupFlyghtInfoView() {
        contentView.addSubview(flyghtInfoView)
        flyghtInfoView.backgroundColor = VisualConstants.flyghtInfoBackgroundColor
        flyghtInfoView.layer.cornerRadius = VisualConstants.flyghtInfoCornerRadius
        flyghtInfoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(VisualConstants.lagreHorizontalMargin)
            make.trailing.equalToSuperview().inset(VisualConstants.lagreHorizontalMargin)
            make.top.equalTo(enrouteTimeLabel.snp.bottom).offset(VisualConstants.lagreHorizontalMargin)
        }
        
        setupDepartureTitleLabel()
        setupDepartureTimeLabel()
        setupDepartureDateLabel()
        setupDepartureCityLabel()
        setupDepartureAirportLabel()
        setupArrivalTitleLabel()
        setupArrivalTimeLabel()
        setupArrivalDateLabel()
        setupArrivalCityLabel()
        setupArrivalAirportLabel()
        setupCustomViewForFlyghtInfoView()
    }
    
    func setupDepartureTitleLabel() {
        flyghtInfoView.addSubview(departureTitleLabel)
        departureTitleLabel.textColor = VisualConstants.textColor
        departureTitleLabel.font = VisualConstants.rockStarRegularFont
        departureTitleLabel.text = RootViewController.labels.departureTitle
        departureTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(VisualConstants.mediumVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.extraLagreHorizontalMargin)
            make.trailing.equalToSuperview().inset(VisualConstants.largeVerticalMargin)
        }
        
    }
    
    func setupDepartureTimeLabel() {
        flyghtInfoView.addSubview(departureTimeLabel)
        departureTimeLabel.textColor = VisualConstants.textColor
        departureTimeLabel.font = VisualConstants.rockStarLightFont
        departureTimeLabel.text = presenter.departureTime
        departureTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(departureTitleLabel.snp.bottom).offset(VisualConstants.smallVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.extraLagreHorizontalMargin)
        }
    }
    
    func setupDepartureCityLabel() {
        flyghtInfoView.addSubview(departureCityLabel)
        departureCityLabel.textColor = VisualConstants.textColor
        departureCityLabel.font = VisualConstants.rockStarLightFont
        departureCityLabel.text = presenter.departureCity
        departureCityLabel.snp.makeConstraints { make in
            make.top.equalTo(departureTitleLabel.snp.bottom).offset(VisualConstants.smallVerticalMargin)
            make.leading.equalTo(departureDateLabel.snp.trailing).offset(VisualConstants.mediumHorizontalMargin)
            make.trailing.lessThanOrEqualToSuperview().inset(VisualConstants.largeVerticalMargin)
        }
    }
    
    func setupDepartureDateLabel() {
        flyghtInfoView.addSubview(departureDateLabel)
        departureDateLabel.textColor = VisualConstants.textColor
        departureDateLabel.font = VisualConstants.rockStarExtraLightFont
        departureDateLabel.text = presenter.departureDate
        departureDateLabel.snp.makeConstraints { make in
            make.top.equalTo(departureTimeLabel.snp.bottom).offset(VisualConstants.extraSmallVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.extraLagreHorizontalMargin)
        }
    }
    
    
    func setupDepartureAirportLabel() {
        flyghtInfoView.addSubview(departureAirportLabel)
        departureAirportLabel.textColor = VisualConstants.textColor
        departureAirportLabel.font = VisualConstants.rockStarExtraLightFont
        departureAirportLabel.snp.makeConstraints { make in
            make.top.equalTo(departureCityLabel.snp.bottom).offset(VisualConstants.extraSmallVerticalMargin)
            make.leading.equalTo(departureDateLabel.snp.trailing).offset(VisualConstants.mediumHorizontalMargin)
            make.trailing.lessThanOrEqualToSuperview().inset(VisualConstants.largeVerticalMargin)
        }
    }
    
    func setupArrivalTitleLabel() {
        flyghtInfoView.addSubview(arrivalTitleLabel)
        arrivalTitleLabel.textColor = VisualConstants.textColor
        arrivalTitleLabel.font = VisualConstants.rockStarRegularFont
        arrivalTitleLabel.text = RootViewController.labels.arrivalTitle
        arrivalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(departureAirportLabel.snp.bottom).offset(VisualConstants.largeVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.extraLagreHorizontalMargin)
            make.trailing.equalToSuperview().inset(VisualConstants.largeVerticalMargin)
        }
    }
    
    func setupArrivalTimeLabel() {
        flyghtInfoView.addSubview(arrivalTimeLabel)
        arrivalTimeLabel.textColor = VisualConstants.textColor
        arrivalTimeLabel.font = VisualConstants.rockStarLightFont
        arrivalTimeLabel.text = presenter.arrivalTime
        arrivalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalTitleLabel.snp.bottom).offset(VisualConstants.smallVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.extraLagreHorizontalMargin)
        }
    }
    
    func setupArrivalCityLabel() {
        flyghtInfoView.addSubview(arrivalCityLabel)
        arrivalCityLabel.textColor = VisualConstants.textColor
        arrivalCityLabel.font = VisualConstants.rockStarLightFont
        arrivalCityLabel.text = presenter.arrivalCity
        arrivalCityLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalTitleLabel.snp.bottom).offset(VisualConstants.smallVerticalMargin)
            make.leading.equalTo(arrivalDateLabel.snp.trailing).offset(VisualConstants.mediumHorizontalMargin)
            make.trailing.lessThanOrEqualToSuperview().inset(VisualConstants.largeVerticalMargin)
        }
    }
    
    func setupArrivalDateLabel() {
        flyghtInfoView.addSubview(arrivalDateLabel)
        arrivalDateLabel.textColor = VisualConstants.textColor
        arrivalDateLabel.font = VisualConstants.rockStarExtraLightFont
        arrivalDateLabel.text = presenter.arrivalDate
        arrivalDateLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalTimeLabel.snp.bottom).offset(VisualConstants.extraSmallVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.extraLagreHorizontalMargin)
        }
    }
    
    func setupArrivalAirportLabel() {
        flyghtInfoView.addSubview(arrivalAirportLabel)
        arrivalAirportLabel.textColor = VisualConstants.textColor
        arrivalAirportLabel.font = VisualConstants.rockStarExtraLightFont
        arrivalAirportLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalCityLabel.snp.bottom).offset(VisualConstants.extraSmallVerticalMargin)
            make.leading.equalTo(arrivalDateLabel.snp.trailing).offset(VisualConstants.mediumHorizontalMargin)
            make.trailing.lessThanOrEqualToSuperview().inset(VisualConstants.largeVerticalMargin)
            make.bottom.equalToSuperview().offset(-VisualConstants.mediumVerticalMargin)
        }
    }
    
    func setupCustomViewForFlyghtInfoView() {
        let departureView = UIView()
        departureView.backgroundColor = .white
        departureView.layer.cornerRadius = VisualConstants.customViewSectionSize / 2
        flyghtInfoView.addSubview(departureView)
        departureView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(VisualConstants.lagreHorizontalMargin)
            make.top.equalTo(departureTitleLabel.snp.bottom)
            make.width.equalTo(VisualConstants.customViewSectionSize)
            make.height.equalTo(VisualConstants.customViewSectionSize)
        }
        
        let arrivalView = UIView()
        arrivalView.backgroundColor = .white
        flyghtInfoView.addSubview(arrivalView)
        arrivalView.layer.cornerRadius = VisualConstants.customViewSectionSize / 2
        arrivalView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(VisualConstants.lagreHorizontalMargin)
            make.top.equalTo(arrivalTitleLabel.snp.bottom)
            make.width.equalTo(VisualConstants.customViewSectionSize)
            make.height.equalTo(VisualConstants.customViewSectionSize)
        }
       
        
        let connectionView = UIView()
        connectionView.backgroundColor = VisualConstants.customViewColor
        flyghtInfoView.addSubview(connectionView)
        connectionView.snp.makeConstraints { make in
            make.leading.equalTo(departureView.snp.leading).offset(VisualConstants.customViewSectionSize / 2)
            make.top.equalTo(departureView.snp.bottom)
            make.bottom.equalTo(arrivalView.snp.top)
            make.width.equalTo(VisualConstants.customViewWidth)
        }
    }
    
    func setupAircraftImageView() {
        guard let image = presenter.aircraftImage else { return }
        contentView.addSubview(aircraftImageView)
        aircraftImageView.backgroundColor = .white
        aircraftImageView.contentMode = .scaleAspectFit
        aircraftImageView.layer.masksToBounds = true
        aircraftImageView.layer.cornerRadius = 20
        aircraftImageView.clipsToBounds = true

        aircraftImageView.snp.makeConstraints { make in
            make.top.equalTo(flyghtInfoView.snp.bottom).offset(VisualConstants.largeVerticalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.lagreHorizontalMargin)
            make.trailing.equalToSuperview().inset(VisualConstants.lagreHorizontalMargin)
            make.height.equalTo(view.frame.width * 0.55)
        }
        
        let imageView = UIImageView()
        imageView.image = image
        aircraftImageView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupFavoriteButton() {
        contentView.addSubview(favoriteButton)
        updateButtonState()
        favoriteButton.buttonAction = { [weak self] in
            self?.addToFavorite()
        }
        favoriteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(VisualConstants.extraLagreHorizontalMargin)
            make.leading.equalToSuperview().offset(VisualConstants.lagreHorizontalMargin)
            make.trailing.equalToSuperview().inset(VisualConstants.lagreHorizontalMargin)
            make.height.equalTo(VisualConstants.favoriteButtonHeight)
        }
    }
    
    func setupLabelsText() {
        flightNumberLabel.text = presenter.flyghtNumber
        arrivalAirportLabel.text = presenter.arrivalAirport
        flightStatusLabel.text = presenter.flyghtStatus
        departureAirportLabel.text = presenter.departureAirport
        departureDateLabel.text = presenter.departureDate
        arrivalDateLabel.text = presenter.arrivalDate
        airLinesNameLabel.text = presenter.airline
        aircraftLabel.text = presenter.aircraft
        enrouteTimeLabel.text = presenter.enrouteTime
    }
    
    func updateButtonState() {
        favoriteButton.setTitle(presenter.isFavorite
                                ? RootViewController.labels.removeFromFavorite
                                : RootViewController.labels.addToFavorite,
                                for: .normal)
        favoriteButton.setTitleColor(presenter.isFavorite
                                     ? VisualConstants.removeFromFavoriteTitleColor
                                     : VisualConstants.addToFavoriteTitleColor,
                                     for: .normal)
    }
}

// MARK: - Actions

private extension FlightCardViewController {

    @objc func closeScreen() {
        dismiss(animated: true)
    }
    
    func addToFavorite() {
        presenter.addToFavorite()
        updateButtonState()
    }
    
}
