//
//  ForecastVC.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastVC: BaseViewController {
    // MARK: - OUTLETS
    //
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var searchByLabel: UILabel!
    @IBOutlet private weak var firstTextField: UITextField!
    @IBOutlet private weak var secondTextField: UITextField!
    @IBOutlet private weak var searchLabel: UILabel!
    @IBOutlet private weak var searchFiltersButton: UIButton!
    @IBOutlet private weak var historyButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    //
    let viewModel: ForecastViewModelContract
    
    // MARK: - LIFECYCLE
    //
    init(
        viewModel: ForecastViewModelContract
    ) {
        self.viewModel = viewModel
        
        super.init(nibName: Self.classNameWithoutNamespaces, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupTextFields()
        configureLoadingAndAlertViews()
        subscribeOnForecastSubject()
        subscribeOnNavigationSubject()
        subscribeOnSearchTypeSubjectSubject()
        subscribeOnSearchFiltersButton()
        subscribeOnHistoryButton()
        subscribeOnHistorySubject()
        viewModel.didLoad()
    }
}

// MARK: - PRIVATE METHODS
//
private extension ForecastVC {
    func setupUI() {
        title = "Forecast"
        searchLabel.isHidden = true
        secondTextField.isHidden = true
    }
    
    func setupTextFields() {
        firstTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 0))
        firstTextField.leftViewMode = .always
        firstTextField.rightView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 0))
        firstTextField.rightViewMode = .always
        
        secondTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 0))
        secondTextField.leftViewMode = .always
        secondTextField.rightView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 0))
        secondTextField.rightViewMode = .always
        
        firstTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.firstTextFieldRelay)
            .disposed(by: disposeBag)
        
        secondTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.secondTextFieldRelay)
            .disposed(by: disposeBag)
        
        firstTextField
            .rx
            .controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.search()
            }
            .disposed(by: disposeBag)
        
        secondTextField
            .rx
            .controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.search()
            }
            .disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.registerCellNib(ForecastCell.self)
        
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
                let cell: ForecastCell = tableView.dequeue()
                cell.configure(using: data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnForecastSubject() {
        viewModel
            .forecastSubject
            .asObserver()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                guard let data = event.element else { return }
                self.nameLabel.text = data.name
            }
            .disposed(by: disposeBag)
    }
        
    func subscribeOnSearchFiltersButton() {
        searchFiltersButton
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didTapSearchFiltersButton()
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnHistoryButton() {
        historyButton
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.didTapHistoryButton()
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
                case .history(let viewModel):
                    let vc = HistoryVC(viewModel: viewModel)
                    self.go(to: vc, navigationType: .present(fullScreen: false))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func subscribeOnHistorySubject() {
        viewModel
            .historySubject
            .asObserver()
            .subscribe { [weak self] event in
                guard let self = self else { return }
                guard let item = event.element else { return }
                
                self.handleHistoryVCCallBack(item)
            }
            .disposed(by: disposeBag)
    }
    
    func handleHistoryVCCallBack(_ item: ForecastHistoryItem) {
        switch item.type {
        case .cityName:
            viewModel.searchTypeRelay.accept(.cityName)
            viewModel.firstTextFieldRelay.accept(item.data.name ?? "")
            
        case .zipCode:
            viewModel.searchTypeRelay.accept(.zipcode)
            viewModel.firstTextFieldRelay.accept(item.zipcode ?? "")
            
        case .coordinates:
            viewModel.searchTypeRelay.accept(.zipcode)
            viewModel.firstTextFieldRelay.accept("\(item.coordinates?.lat ?? 0)")
            viewModel.secondTextFieldRelay.accept("\(item.coordinates?.lon ?? 0)")
            
        case .currentLocation:
            viewModel.searchTypeRelay.accept(.currentLocation(coordinates: "\(item.coordinates?.lat ?? 0) \(item.coordinates?.lon ?? 0)"))
        }
        
        viewModel.search()
    }
    
    func subscribeOnSearchTypeSubjectSubject() {
        viewModel
            .searchTypeRelay
            .subscribe { [weak self] event in
                guard let self = self else { return }
                guard let type = event.element, let safeType = type else { return }
                
                switch safeType {
                case .cityName:
                    self.searchByLabel.text = "Search by city name"
                    self.firstTextField.isHidden = false
                    self.firstTextField.placeholder = "Enter city name"
                    self.firstTextField.keyboardType = .asciiCapable
                    self.secondTextField.isHidden = true
                    self.searchLabel.isHidden = true
                    
                case .zipcode:
                    self.searchByLabel.text = "Search by zipcode"
                    self.firstTextField.isHidden = false
                    self.firstTextField.placeholder = "Enter zipcode"
                    self.firstTextField.keyboardType = .asciiCapableNumberPad
                    self.secondTextField.isHidden = true
                    self.searchLabel.isHidden = true
                    
                case .coordinates:
                    self.searchByLabel.text = "Search by coordinates"
                    self.firstTextField.isHidden = false
                    self.firstTextField.placeholder = "Enter latitude"
                    self.firstTextField.keyboardType = .asciiCapableNumberPad
                    self.secondTextField.isHidden = false
                    self.secondTextField.placeholder = "Enter longitude"
                    self.secondTextField.keyboardType = .asciiCapableNumberPad
                    self.searchLabel.isHidden = true
                    
                case .currentLocation(let coordinates):
                    self.view.endEditing(true)
                    self.searchByLabel.text = "Search by current location"
                    self.firstTextField.isHidden = true
                    self.secondTextField.isHidden = true
                    self.searchLabel.text = coordinates
                    self.searchLabel.isHidden = false
                }
                
                UIView.animate(withDuration: 0.5, animations: { self.view.layoutIfNeeded() })
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - UITableViewDelegate
//
extension ForecastVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ForecastCell.height
    }
}

// MARK: - AlertDisplayer & LoadingDisplayer
//
extension ForecastVC: AlertDisplayerProtocol, LoadingDisplayerProtocol {
    func configureLoadingAndAlertViews() {
        bindLoadingIndicator(to: viewModel.stateRelay)
        bindAlert(to: viewModel.alertItemRelay)
    }
}
