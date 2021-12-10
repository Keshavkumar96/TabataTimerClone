//
//  TTTimerViewModel.swift
//  TabattaTimer
//
//  Created by apple on 08/02/21.
//

import UIKit

class TTTimerViewModel: NSObject {
    
    var timerSetData: [SetNames] = [.prepare,.work,.rest,.cycles,.tabatta]
    
    var tableViewCellHeight: CGFloat {
        90
    }
    
    // Adding 1 to add save button as last cell with timer cells.
    var tableViewCellCount: Int {
        timerSetData.count + 1
    }
    
    func saveData() {
        UserDefaults.standard.set(TTTimerValues.shared.prepareDurationInSec, forKey: TTUtilities.prepareDurationKey)
        UserDefaults.standard.set(TTTimerValues.shared.workDurationInSec, forKey: TTUtilities.workDurationKey)
        UserDefaults.standard.set(TTTimerValues.shared.restDurationInSec, forKey: TTUtilities.restDurationKey)
        UserDefaults.standard.set(TTTimerValues.shared.numberOfCycles, forKey: TTUtilities.cyclesCountKey)
        UserDefaults.standard.set(TTTimerValues.shared.numberOfTabatta, forKey: TTUtilities.tabattaCountKey)
    }
    
}

