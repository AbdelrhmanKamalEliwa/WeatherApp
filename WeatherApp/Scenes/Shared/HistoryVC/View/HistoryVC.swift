//
//  HistoryVC.swift
//  WeatherApp
//
//  Created by Abdelrhman Eliwa on 07/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryVC: BaseViewController, UITableViewDelegate {
    // MARK: - OUTLES
    //
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    //
    private let viewModel: HistoryViewModel
    
    // MARK: - LIFECYCLE
    //
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        
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
            .itemSelected
            .subscribe { [weak self] event in
                guard let self = self else { return }
                guard let indexPath = event.element else { return }
                self.viewModel.didSelectItem(at: indexPath.row)
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
    
    func getTextTitleForHistoryCell(
        using data: HistoryItemRepresentableModelContract
    ) -> String {
        switch data.type {
        case .cityName:
            return data.name ?? ""
            
        case .zipCode:
            return data.name ?? ""
            
        case .coordinates:
            return data.name ?? ""
            
        case .currentLocation:
            return data.name ?? ""
        }
    }
}
