//
//  HabitViewModel.swift
//  Habbit Tracker
//
//  Created by Yadnyesh Khakal on 06/06/25.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var day: Int = 1
    @Published var progress: [[Bool]] = []

    private let habitsKey = "habitsKey"
    private let progressKey = "progressKey"
    private let dayKey = "dayKey"

    init() {
        loadData()
    }

    func toggleCompletion(habit: Habit) {
        if let index = habits.firstIndex(of: habit) {
            habits[index].isCompleted.toggle()
            progress[day - 1][index] = habits[index].isCompleted

            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()

            saveData()
        }
    }

    func addHabit(name: String, duration: String) {
        habits.append(Habit(name: name, duration: duration, isCompleted: false))
        
        // Add a new column to each row in progress
        for i in 0..<progress.count {
            progress[i].append(false)
        }
        
        // If no progress yet (fresh app), initialize
        if progress.isEmpty {
            progress = Array(repeating: Array(repeating: false, count: habits.count), count: 21)
        }

        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()

        saveData()
    }

    func deleteHabit(at offsets: IndexSet) {
        offsets.forEach { index in
            for i in 0..<progress.count {
                if index < progress[i].count {
                    progress[i].remove(at: index)
                }
            }
        }

        habits.remove(atOffsets: offsets)

        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()

        saveData()
    }

    func nextDay() {
        if day < 21 {
            day += 1
            // Reset current day's habit completion
            habits.indices.forEach { habits[$0].isCompleted = false }

            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)
            saveData()
        }
    }

    func previousDay() {
        if day > 1 {
            day -= 1
            habits.indices.forEach { habits[$0].isCompleted = progress[day - 1][$0] }

            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)

            saveData()
        }
    }

    var currentStreak: Int {
        progress[day - 1].filter { $0 }.count
    }

    var totalCompletionPercentage: Int {
        let total = progress.flatMap { $0 }.count
        let completed = progress.flatMap { $0 }.filter { $0 }.count
        return total == 0 ? 0 : Int(Double(completed) / Double(total) * 100)
    }

    // MARK: - ProgressView compatibility helpers

    func isCompleted(habitIndex: Int, day: Int) -> Bool {
        guard progress.indices.contains(day - 1),
              progress[day - 1].indices.contains(habitIndex) else {
            return false
        }
        return progress[day - 1][habitIndex]
    }

    func progressArrayForHabit(habitIndex: Int) -> [Bool] {
        progress.map { row in
            row.indices.contains(habitIndex) ? row[habitIndex] : false
        }
    }

    // MARK: - Persistence

    func saveData() {
        do {
            let habitsData = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(habitsData, forKey: habitsKey)

            let progressData = try JSONEncoder().encode(progress)
            UserDefaults.standard.set(progressData, forKey: progressKey)

            UserDefaults.standard.set(day, forKey: dayKey)

        } catch {
            print("Error saving data: \(error)")
        }
    }

    func loadData() {
        do {
            if let habitsData = UserDefaults.standard.data(forKey: habitsKey),
               let savedHabits = try? JSONDecoder().decode([Habit].self, from: habitsData) {
                self.habits = savedHabits
            } else {
                // Default habits if none saved yet
                self.habits = [
                    Habit(name: "Physical Activity", duration: "1 hr", isCompleted: false),
                    Habit(name: "Study", duration: "1.5 hr", isCompleted: false),
                    Habit(name: "Mental Peace", duration: "30 min", isCompleted: false),
                    Habit(name: "Reading", duration: "15 min", isCompleted: false)
                ]
            }

            if let progressData = UserDefaults.standard.data(forKey: progressKey),
               let savedProgress = try? JSONDecoder().decode([[Bool]].self, from: progressData) {
                self.progress = savedProgress
            } else {
                self.progress = Array(repeating: Array(repeating: false, count: habits.count), count: 21)
            }

            self.day = UserDefaults.standard.integer(forKey: dayKey)
            if self.day == 0 { self.day = 1 }

            // Ensure progress matrix is consistent with current habits
            normalizeProgressMatrix()

        } catch {
            print("Error loading data: \(error)")
            self.habits = []
            self.progress = []
            self.day = 1
        }
    }

    private func normalizeProgressMatrix() {
        // If habits changed but progress matrix has wrong size, adjust it safely
        for i in 0..<progress.count {
            while progress[i].count < habits.count {
                progress[i].append(false)
            }
            while progress[i].count > habits.count {
                progress[i].removeLast()
            }
        }
    }
}
