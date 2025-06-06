import SwiftUI

struct AddHabitSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HabitViewModel
    @State private var newHabitName = ""
    @State private var newHabitDuration = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Habit Name", text: $newHabitName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Duration (e.g. 30 min)", text: $newHabitDuration)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Add Habit") {
                    if !newHabitName.isEmpty && !newHabitDuration.isEmpty {
                        viewModel.addHabit(name: newHabitName, duration: newHabitDuration)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Add Habit")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
