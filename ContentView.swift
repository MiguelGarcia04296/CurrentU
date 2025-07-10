//import SwiftUI
//
//// MARK: - Checklist Item
//struct ChecklistItem: Identifiable, Codable, Equatable {
//    var id = UUID()
//    var title: String
//    var isCompleted: Bool = false
//}
//
//// MARK: - ViewModel
//class ContentViewModel: ObservableObject {
//    @Published var items: [ChecklistItem] = [] {
//        didSet { saveItems() }
//    }
//    
//    let storageKey = "ChecklistItems"
//    
//    init() {
//        loadItems()
//    }
//    
//    func addItem(title: String) {
//        items.append(ChecklistItem(title: title))
//    }
//    
//    func toggle(item: ChecklistItem) {
//        if let index = items.firstIndex(where: { $0.id == item.id }) {
//            items[index].isCompleted.toggle()
//        }
//    }
//    
//    func update(item: ChecklistItem, title: String) {
//        if let index = items.firstIndex(where: { $0.id == item.id }) {
//            items[index].title = title
//        }
//    }
//    
//    func delete(item: ChecklistItem) {
//        items.removeAll { $0 == item }
//    }
//    
//    func saveItems() {
//        if let encoded = try? JSONEncoder().encode(items) {
//            UserDefaults.standard.set(encoded, forKey: storageKey)
//        }
//    }
//    
//    func loadItems() {
//        if let data = UserDefaults.standard.data(forKey: storageKey),
//           let decoded = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
//            items = decoded
//        }
//    }
//}
//
//// Toast
//extension View {
//    func toast(isShowing: Binding<Bool>, message: String) -> some View {
//        ZStack {
//            self
//            if isShowing.wrappedValue {
//                Text(message)
//                    .padding()
//                    .background(Color.black.opacity(0.8))
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .transition(.opacity)//fades in and out pop up
//                    .zIndex(1) //always on top of everything else
//                    .frame(maxWidth: .infinity, maxHeight: .infinity) //center of screen
//                    .background(Color.clear) // fills screen ensuring it's centered
//            }
//        }
//        .animation(.easeInOut, value: isShowing.wrappedValue)
//    }
//}
//
//// MARK: - View
//struct ContentView: View {
//    @StateObject private var viewModel = ContentViewModel()
//    @State private var newItem = ""
//    @State private var itemToDelete: ChecklistItem? = nil
//    @State private var showDeleteConfirmation = false
//    @State private var showSuccessToast = false
//    @State private var itemJustCompleted: ChecklistItem?
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                
//                //Adding a goal
//                HStack {
//                    TextField("New Goal", text: $newItem)
//                        .textFieldStyle(.roundedBorder)
//                    
//                    Button("+") {
//                        let trimmed = newItem.trimmingCharacters(in: .whitespaces)
//                        guard !trimmed.isEmpty else { return }
//                        viewModel.addItem(title: trimmed)
//                        newItem = ""
//                    }
//                }
//                .padding()
//                
//                List {
//                    ForEach(viewModel.items) { item in
//                        HStack {
//                            Button(action: {
//                                // Mark as completed
//                                viewModel.toggle(item: item)
//                                
//                                // Goal is completed
//                                if let updatedItem = viewModel.items.first(where: { $0.id == item.id }), updatedItem.isCompleted {
//                                    withAnimation {
//                                        showSuccessToast = true
//                                        itemJustCompleted = updatedItem
//                                    }
//
//                                    // Goal is copmleted "animation"
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { //toast shows for 3 seconds
//                                        withAnimation {
//                                            showSuccessToast = false
//                                            if let itemToRemove = itemJustCompleted {
//                                                viewModel.delete(item: itemToRemove) //after 3 seconds, toast disappears & goal deletes
//                                                itemJustCompleted = nil
//                                            }
//                                        }
//                                    }
//                                }
//                            }) {
//                                //gray -> blue check circle
//                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
//                                    .foregroundColor(item.isCompleted ? .blue : .gray)
//                            }
//
//                            
//                            TextField("Item", text: Binding(
//                                get: { item.title },
//                                set: { viewModel.update(item: item, title: $0) }
//                            ))
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                itemToDelete = item
//                                showDeleteConfirmation = true
//                            }) {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray)
//                            }
//                            .buttonStyle(BorderlessButtonStyle())
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Goals")
//            .alert("Are you sure you want to delete this goal?\nYou can do it!", isPresented: $showDeleteConfirmation, presenting: itemToDelete) { item in
//                Button("Cancel", role: .cancel) {}
//                Button("Delete", role: .destructive) {
//                    withAnimation {
//                        viewModel.delete(item: item)
//                    }
//                }
//            }
//        }
//        .toast(isShowing: $showSuccessToast, message: "Way to go!")
//    }
//}

import SwiftUI

// MARK: - Checklist Item
struct ChecklistItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
}

// MARK: - ViewModel
class ContentViewModel: ObservableObject {
    @Published var items: [ChecklistItem] = [] {
        didSet { saveItems() }
    }

    let storageKey = "ChecklistItems"

    init() {
        loadItems()
    }

    func addItem(title: String, description: String) {
        items.append(ChecklistItem(title: title, description: description))
    }

    func toggle(item: ChecklistItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }

    func update(item: ChecklistItem, title: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].title = title
        }
    }

    func delete(item: ChecklistItem) {
        items.removeAll { $0 == item }
    }

    func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    func loadItems() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
            items = decoded
        }
    }
}

// MARK: - Toast Extension
extension View {
    func toast(isShowing: Binding<Bool>, message: String) -> some View {
        ZStack {
            self
            if isShowing.wrappedValue {
                Text(message)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity)
                    .zIndex(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
            }
        }
        .animation(.easeInOut, value: isShowing.wrappedValue)
    }
}

// MARK: - ContentView
struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showPopup = false
    @State private var goalTitle = ""
    @State private var goalDescription = ""
    @State private var showDeleteConfirmation = false
    @State private var itemToDelete: ChecklistItem? = nil
    @State private var showSuccessToast = false
    @State private var itemJustCompleted: ChecklistItem?

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List {
                        ForEach(viewModel.items) { item in
                            VStack(alignment: .leading) {
                                HStack {
                                    Button(action: {
                                        viewModel.toggle(item: item)
                                        if let updatedItem = viewModel.items.first(where: { $0.id == item.id }),
                                           updatedItem.isCompleted {
                                            withAnimation {
                                                showSuccessToast = true
                                                itemJustCompleted = updatedItem
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                withAnimation {
                                                    showSuccessToast = false
                                                    if let itemToRemove = itemJustCompleted {
                                                        viewModel.delete(item: itemToRemove)
                                                        itemJustCompleted = nil
                                                    }
                                                }
                                            }
                                        }
                                    }) {
                                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(item.isCompleted ? .blue : .gray)
                                    }

                                    Text(item.title)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                    Spacer()

                                    Button(action: {
                                        itemToDelete = item
                                        showDeleteConfirmation = true
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }

                                if !item.description.isEmpty {
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Spacer()

                    Button(action: {
                        showPopup = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 24, weight: .bold))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                }

                if showPopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 16) {
                        HStack {
                            Spacer()
                            Button(action: {
                                showPopup = false
                                goalTitle = ""
                                goalDescription = ""
                            }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .padding()
                            }
                        }

                        TextField("Goal Title", text: $goalTitle)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("Description", text: $goalDescription)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Button(action: {
                            let trimmed = goalTitle.trimmingCharacters(in: .whitespaces)
                            guard !trimmed.isEmpty else { return }
                            viewModel.addItem(title: trimmed, description: goalDescription)
                            goalTitle = ""
                            goalDescription = ""
                            showPopup = false
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.green)
                                .padding(.top, 8)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
                }
            }
            .navigationTitle("Goals")
            .alert("Are you sure you want to delete this goal?\nYou can do it!", isPresented: $showDeleteConfirmation, presenting: itemToDelete) { item in
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    withAnimation {
                        viewModel.delete(item: item)
                    }
                }
            }
        }
        .toast(isShowing: $showSuccessToast, message: "Way to go!")
    }
}
