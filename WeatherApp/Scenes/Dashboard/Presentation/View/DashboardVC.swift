//
//  DashboardVC.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardVC: BaseViewController {
    // MARK: - OUTLETS
    //
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var currentTempValueLabel: UILabel!
    @IBOutlet private weak var minTempValueLabel: UILabel!
    @IBOutlet private weak var maxTempValueLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var forecastButton: UIButton!
    @IBOutlet private weak var currentWeatherButton: UIButton!
    
    // MARK: - PROPERTIES
    //
    let viewModel: DashboardViewModelContract
    
    // MARK: - LIFECYCLE
    //
    init(
        viewModel: DashboardViewModelContract
    ) {
        self.viewModel = viewModel
        
        super.init(nibName: Self.classNameWithoutNamespaces, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        setupTableView()
        configureLoadingAndAlertViews()
        subscribeOnWeatherSubject()
        subscribeOnForecastButton()
        subscribeOnCurrentWeatherButton()
        subscribeOnNavigationSubject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCurrentWeather()
    }
}

// MARK: - PRIVATE METHODS
//
private extension DashboardVC {
    func setupTableView() {
        tableView.registerCellNib(WeatherCell.self)
        
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        bindTableViewCellsToData()
    }
    
    func bindTableViewCellsToData() {
        viewModel
            .dataSourceSubject
            .asObservable()
            .bind(to: tableView.rx.items) { (tableView, _, data) in
                let cell: WeatherCell = tableView.dequeue()
                cell.configure(using: data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnWeatherSubject() {
        viewModel
            .weatherSubject
            .asObserver()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                guard let data = event.element else { return }
                
                self.nameLabel.text = data.name.value
                self.currentTempValueLabel.text = data.temp
                self.minTempValueLabel.text = data.minTemp
                self.maxTempValueLabel.text = data.maxTemp
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnForecastButton() {
        forecastButton
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didTapForecastButton()
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnCurrentWeatherButton() {
        currentWeatherButton
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didTapCurrentWeatherButton()
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnNavigationSubject() {
        viewModel
            .navigationSubject
            .asObserver()
            .subscribe { [weak self] event in
                guard let self = self else { return }
                guard let navigation = event.element else { return }
                
                switch navigation {
                case .currentWeather(let viewModel):
                    let vc = CurrentWeatherVC(viewModel: viewModel)
                    self.go(to: vc, navigationType: .push)
                    
                case .forecast(let viewModel):
                    let vc = ForecastVC(viewModel: viewModel)
                    self.go(to: vc, navigationType: .push)
                }
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - UITableViewDelegate
//
extension DashboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        WeatherCell.height
    }
}

// MARK: - AlertDisplayer & LoadingDisplayer
//
extension DashboardVC: AlertDisplayerProtocol, LoadingDisplayerProtocol {
    func configureLoadingAndAlertViews() {
        bindLoadingIndicator(to: viewModel.stateRelay)
        bindAlert(to: viewModel.alertItemRelay)
    }
}
