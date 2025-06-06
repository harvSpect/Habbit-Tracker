import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HabitViewModel()
    @State private var showingAddHabitSheet = false
    @State private var showDeleteConfirmation = false
    @State private var indexToDelete: Int?

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    // Header with Progress button inline
                    HStack {
                        Text("🌟 My Habit Tracker")
                            .font(.title2)
                            .bold()

                        Spacer()

                        NavigationLink(destination: ProgressViewScreen(viewModel: viewModel)) {
                            HStack(spacing: 4) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                                Text("Progress")
                                    .foregroundColor(.blue)
                                    .fontWeight(.semibold)
                            }
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    Text("Day \(viewModel.day) of 21")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    // Habit List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(viewModel.habits.enumerated()), id: \.element.id) { index, habit in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(habit.name)
                                            .font(.headline)
                                        Text("\(habit.duration)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    // Completion toggle
                                    Button(action: {
                                        viewModel.toggleCompletion(habit: habit)
                                    }) {
                                        Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.title2)
                                            .foregroundColor(habit.isCompleted ? .green : .gray)
                                    }

                                    // Delete button (back inline)
                                    Button(action: {
                                        indexToDelete = index
                                        showDeleteConfirmation = true
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 150) // Space for FAB and Next Day button
                    }

                    // Progress View
                    VStack(spacing: 8) {
                        Text("Progress: \(viewModel.totalCompletionPercentage)% complete")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        ProgressView(value: Float(viewModel.totalCompletionPercentage), total: 100)
                            .padding(.horizontal)
                    }

                    // Next Day Button
                    Button(action: {
                        viewModel.nextDay()
                    }) {
                        Text("Next Day")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }

                // Floating Add Habit Button — Higher up now!
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddHabitSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .frame(width: 56, height: 56)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.bottom, 150) // More upwards → does NOT overlap Next Day button
                        .padding(.trailing, 16)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabitSheet) {
                AddHabitSheet(viewModel: viewModel)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Habit"),
                    message: Text("Are you sure you want to delete this habit?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let index = indexToDelete {
                            viewModel.deleteHabit(at: IndexSet(integer: index))
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My Habits")
        }
    }
}

#Preview {
    ContentView()
}
