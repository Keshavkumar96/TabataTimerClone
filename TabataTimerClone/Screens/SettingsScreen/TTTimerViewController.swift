//
//  TTViewController.swift
//  TabattaTimer
//
//  Created by apple on 04/02/21.
//

import UIKit

class TTTimerViewController: UIViewController {

    // MARK: - PROPERITIES
    private var tableView = UITableView()
    private var viewModel = TTTimerViewModel()
        
    // MARK: - VIEWCONTROL LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configureTableView()
    }

    // MARK: - HELPER METHODS
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .lightGray
        tableView.pinToSuperViewSafeArea(to: view)
        tableView.delegate = self
        tableView.dataSource = self
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(TTTimerSettingCell.self, forCellReuseIdentifier: TTTimerSettingCell.reuseId)
        tableView.register(TTTimerSaveCell.self, forCellReuseIdentifier: TTTimerSaveCell.reuseId)
    }
}

// MARK: - DELEGATE AND DATA SOURCE
extension TTTimerViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableViewCellHeight
    }
}

extension TTTimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.row {
        
        case viewModel.timerSetData.count :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TTTimerSaveCell.reuseId, for: indexPath) as? TTTimerSaveCell else {
                return UITableViewCell()
            }
            cell.saveDelegate = self
            return cell
            
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TTTimerSettingCell.reuseId, for: indexPath) as? TTTimerSettingCell else {
                return UITableViewCell()
            }
        
            let currentSet = viewModel.timerSetData[indexPath.row]
            cell.stepperDelegate = self
            cell.titleLabel.text = currentSet.rawValue
            cell.stepperForTimer.value = stepperValue(set: currentSet)
            
            switch currentSet {
            case .prepare:
                cell.timerLabel.text = TTTimerValues.shared.prepareDurationSecInString
        
            case .work:
                cell.timerLabel.text = TTTimerValues.shared.workDurationSecInString
            
            case .rest:
                cell.timerLabel.text = TTTimerValues.shared.restDurationSecInString
            
            case .cycles:
                cell.timerLabel.text = TTTimerValues.shared.cyclesCountInString
                
            case .tabatta:
                cell.timerLabel.text = TTTimerValues.shared.tabattaCountInString
        
            }
            return cell
        }
        
    }
    
    private func stepperValue(set: SetNames) -> Double {
        switch set {
        case .prepare:
            return Double(TTTimerValues.shared.prepareDurationInSec)
            
        case .work:
            return Double(TTTimerValues.shared.workDurationInSec)
            
        case .rest:
            return Double(TTTimerValues.shared.restDurationInSec)
            
        case .cycles:
            return Double(TTTimerValues.shared.numberOfCycles)
            
        case .tabatta:
            return Double(TTTimerValues.shared.numberOfTabatta)
            
        }
       
    }
    
  
    
}

extension TTTimerViewController: TTSaveButtonActionDelegate {
    func saveAction() {
        if TTTimerValues.shared.numberOfCycles == 0 || TTTimerValues.shared.numberOfTabatta == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please update the cycles and tabatta count to proceed.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        else {
            viewModel.saveData()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension TTTimerViewController: TTStepperTimerDelegate {
    func updateStepper(stepperValue: Double, cell: UITableViewCell) {
        
        
        guard let index = tableView.indexPath(for: cell)?.row else {
            return
        }
        
        let set = viewModel.timerSetData[index]
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TTTimerSettingCell else {
            return
        }

        switch set {
        case .prepare:
            TTTimerValues.shared.prepareDurationInSec = Int(stepperValue)
            cell.timerLabel.text = TTUtilities.timeString(Int(stepperValue))
            
        case .work:
            TTTimerValues.shared.workDurationInSec = Int(stepperValue)
            cell.timerLabel.text = TTUtilities.timeString(Int(stepperValue))
            
        case .rest:
            TTTimerValues.shared.restDurationInSec = Int(stepperValue)
            cell.timerLabel.text = TTUtilities.timeString(Int(stepperValue))
            
        case .cycles:
            TTTimerValues.shared.numberOfCycles = Int(stepperValue)
            cell.timerLabel.text = TTUtilities.countString(Int(stepperValue))
            
        case .tabatta:
            TTTimerValues.shared.numberOfTabatta = Int(stepperValue)
            cell.timerLabel.text = TTUtilities.countString(Int(stepperValue))
            
        }
        
    }
}
