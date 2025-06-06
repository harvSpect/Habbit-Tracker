//
//  Habit.swift
//  Habbit Tracker
//
//  Created by Yadnyesh Khakal on 06/06/25.
//

import Foundation

struct Habit: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var duration: String
    var isCompleted: Bool
    var completionHistory: [Int: Bool] = [:] // Store day-wise completion
    
    func isCompletedOnDay(_ day: Int) -> Bool {
        // Return whether this habit was completed on this day
        return completionHistory[day] ?? false
    }
}
