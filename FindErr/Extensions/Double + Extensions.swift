//
//  Double + Extensions.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation

//to convert duration in correct format of time based on hour and minute
extension Double {
    func toDisplayString() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds / 60) % 60
        let seconds = totalSeconds % 60
        if totalSeconds < 3600 {
            return String(format: "%02dm %02ds", minutes, seconds)
        } else {
            return String(format: "%02dh %02dm %02d s", hours, minutes, seconds)
        }
    }
}


