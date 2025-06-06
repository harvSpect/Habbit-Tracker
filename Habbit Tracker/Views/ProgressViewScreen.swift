import SwiftUI

struct ProgressViewScreen: View {
    @ObservedObject var viewModel: HabitViewModel
    
    let dayCount = 21
    let dayColumnWidth: CGFloat = 60
    let habitCellSize: CGFloat = 60
    let spacing: CGFloat = 16
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading, spacing: spacing) {
                
                // HEADER ROW
                HStack(spacing: spacing) {
                    Text("Day")
                        .font(.headline)
                        .frame(width: dayColumnWidth, alignment: .leading)
                    
                    ForEach(viewModel.habits, id: \.id) { habit in
                        Text(habit.name)
                            .font(.headline)
                            .frame(width: habitCellSize, height: habitCellSize)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Divider()
                
                // MATRIX ROWS
                ForEach(1...viewModel.day, id: \.self) { day in
                    HStack {
                        Text("Day \(day)")
                            .font(.body.monospacedDigit())
                            .frame(width: dayColumnWidth, alignment: .leading)
                        
                        HStack(spacing: spacing) {
                            ForEach(0..<viewModel.habits.count, id: \.self) { habitIndex in
                                let completed = viewModel.isCompleted(habitIndex: habitIndex, day: day)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(completed ? Color.green : Color.gray.opacity(0.2))
                                        .frame(width: habitCellSize, height: habitCellSize)
                                    
                                    Image(systemName: completed ? "checkmark" : "xmark")
                                        .foregroundColor(completed ? .white : .gray)
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                        }
                    }
                }
                
                Spacer() // Push everything to top if fewer rows
            }
            .padding()
            Spacer()
        }
        .navigationTitle("📊 Progress")
        .navigationBarTitleDisplayMode(.inline)
        Spacer()
    }
}

struct ProgressViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock view model for preview
        let mockViewModel = HabitViewModel()
        
        // Manually set mock habits
        mockViewModel.habits = [
            Habit(name: "Physical Activity", duration: "1 hr", isCompleted: false),
            Habit(name: "Study", duration: "1.5 hr", isCompleted: false),
            Habit(name: "Mental Peace", duration: "30 min", isCompleted: false),
            Habit(name: "Reading", duration: "15 min", isCompleted: false)
        ]
        
        // Initialize progress with mock data
        mockViewModel.progress = Array(repeating: Array(repeating: false, count: mockViewModel.habits.count), count: 21)
        
        // Example: mark some cells as completed
        mockViewModel.progress[0][0] = true  // Day 1, Habit 1
        mockViewModel.progress[0][1] = true  // Day 1, Habit 2
        mockViewModel.progress[1][2] = true  // Day 2, Habit 3
        mockViewModel.progress[2][0] = true  // Day 3, Habit 1
        mockViewModel.progress[2][3] = true  // Day 3, Habit 4
        
        return NavigationView {
            ProgressViewScreen(viewModel: mockViewModel)
        }
        .previewDevice("iPhone 15 Pro")
    }
}
