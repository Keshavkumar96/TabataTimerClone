//
//  TTExtensions.swift
//  TabattaTimer
//
//  Created by apple on 02/02/21.
//

import UIKit


class TTUtilities: NSObject {
       
    static var ttCornerRadius: CGFloat = 15

    // UserDefault keys
    static var prepareDurationKey: String = "prepareDuration"
    static var workDurationKey: String = "workDuration"
    static var restDurationKey: String = "restDuration"
    static var cyclesCountKey: String = "cyclesCount"
    static var tabattaCountKey: String = "tabattaCount"
    
    static func timeString(_ time: Int) -> String {
        let minutes = (time / 60) % 60
        let seconds = time % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    static func countString(_ count: Int) -> String {
        String(format: "%02i", count)
    }
    
    static var isPortrait: Bool {
        UIDevice.current.orientation.isPortrait
    }
    
    static var isLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }
    
}

