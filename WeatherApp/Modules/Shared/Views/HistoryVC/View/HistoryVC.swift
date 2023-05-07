//
//  HistoryVC.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

struct HistoryItem: Codable {
    let data: GetCurrentWeatherResponse
    let type: SearchItem
    var zipcode: String? = nil
}

enum SearchItem: Codable {
    case cityName
    case zipCode
    case coordinates
    case currentLocation
}

class HistoryVC: BaseViewController, UITableViewDelegate {
    // MARK: - OUTLES
    //
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    //
    private let viewModel: HistoryViewModel
    private var onSelectItem: ((HistoryItem) -> Void)
    
    // MARK: - LIFECYCLE
    //
    init(
        viewModel: HistoryViewModel,
        onSelectItem: @escaping ((HistoryItem) -> Void)
    ) {
        self.viewModel = viewModel
        self.onSelectItem = onSelectItem
        
        super.init(nibName: Self.classNameWithoutNamespaces, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        setupTableView()
        viewModel.loadHistory()
    }
    
    func setupTableView() {
        tableView.registerCellNib(HistoryCell.self)
        
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        bindTableViewCellsToData()
        subscribeOnTableViewCellSelection()
    }
    
    func subscribeOnTableViewCellSelection() {
        tableView
            .rx
            .modelSelected(HistoryItem.self)
            .subscribe { [weak self] data in
                guard let self = self else { return }
                guard let item = data.element else { return }
                self.onSelectItem(item)
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindTableViewCellsToData() {
        viewModel
            .dataSourceSubject
            .asObservable()
            .bind(to: tableView.rx.items) { (tableView, _, data) in
                let cell: HistoryCell = tableView.dequeue()
                cell.textLabel?.text = self.getTextTitleForHistoryCell(using: data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func getTextTitleForHistoryCell(using data: HistoryItem) -> String {
        switch data.type {
        case .cityName:
            return data.data.name ?? ""
            
        case .zipCode:
            return data.zipcode ?? ""
            
        case .coordinates:
            return "\(data.data.coord.lat) \(data.data.coord.lon)"
            
        case .currentLocation:
            return "Current location"
        }
    }
}
