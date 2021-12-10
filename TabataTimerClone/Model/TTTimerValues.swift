//
//  TimerValues.swift
//  TabattaTimer
//
//  Created by apple on 02/02/21.
//

import Foundation

class TTTimerValues: NSObject {
    
    static let shared = TTTimerValues()
    
    private override init() {
        if let prepareDuration = UserDefaults.standard.value(forKey: TTUtilities.prepareDurationKey) as? Int {
            prepareDurationInSec = prepareDuration
        }
        
        if let workDuration = UserDefaults.standard.value(forKey: TTUtilities.workDurationKey) as? Int {
            workDurationInSec = workDuration
        }
        
        if let restDuration = UserDefaults.standard.value(forKey: TTUtilities.restDurationKey) as? Int {
            restDurationInSec = restDuration
        }
        
        if let cyclesCount = UserDefaults.standard.value(forKey: TTUtilities.cyclesCountKey) as? Int {
            numberOfCycles = cyclesCount
        }
        
        if let tabattaCount = UserDefaults.standard.value(forKey: TTUtilities.tabattaCountKey) as? Int {
            numberOfTabatta = tabattaCount
        }
    }
    
    // MARK: - Properities
    var prepareDurationInSec: Int = 0
    var workDurationInSec: Int = 0
    var restDurationInSec: Int = 0
    var numberOfCycles: Int = 0
    var numberOfTabatta: Int = 0
    
    // MARK: - Modifiers
    var prepareDurationSecInString: String {
        TTUtilities.timeString(prepareDurationInSec)
    }
    
    var workDurationSecInString: String {
        TTUtilities.timeString(workDurationInSec)
    }
    
    var restDurationSecInString: String {
        TTUtilities.timeString(restDurationInSec)
    }
    
    var cyclesCountInString: String {
        TTUtilities.countString(numberOfCycles)
    }
    
    var tabattaCountInString: String {
        TTUtilities.countString(numberOfTabatta)
    }
    
}
