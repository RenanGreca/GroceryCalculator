//
//  GroceryList.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import WatchConnectivity

struct GroceryNavigationView: View {
    
    @ObservedObject var keyboard = KeyboardResponder()
    
    @Environment(\.locale) var locale
    @FetchRequest(entity: Grocery.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)],
                  predicate: NSPredicate(format: "visible = %d", true),
                  animation: .spring())
    var fetchedGroceries: FetchedResults<Grocery>
    
    var body: some View {
        let total = fetchedGroceries.reduce(0) { $0 + $1.price }
        let totalPrice = Formatter().currency.string(for: total) ?? "0"
        
        return ZStack {
            // NavigationView including the list of groceries
            NavigationView {
                VStack {
                    GroceryList()
                    if (keyboard.currentHeight == 0) {
                        // Row showing total value of purchase
                        TotalRow(totalPrice: totalPrice)
                    }
                }
                .navigationBarTitle(Text("Grocery List"))
                .navigationBarItems(leading: LeadingButtons(),
                                    trailing: EditButton())
                    .padding(.bottom,
                             (keyboard.currentHeight > 0 ? keyboard.currentHeight-35 : 0))
                    .animation(.easeInOut(duration: 0.16))
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
}

// MARK: - Additional subviews
extension GroceryNavigationView {
    
    struct LeadingButtons: View {
        
        var body: some View {
            HStack {
                SettingsButton()
                    .padding(.trailing, 10)
                ClearButton()
            }
        }
        
        struct SettingsButton: View {
            @State var pushed: Bool = false
            
            var body: some View {
                Button(action: {
                    self.pushed = true
                }, label: {
                    Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 22, height: 22)
                    
                })
                    .sheet(isPresented: $pushed) {
                        Settings(pushed: self.$pushed)
                }
            }
        }
        
        struct ClearButton: View {
            @FetchRequest(entity: Grocery.entity(),
                          sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)],
                          predicate: NSPredicate(format: "visible = %d", true),
                          animation: .spring())
            var groceries: FetchedResults<Grocery>
            
            @State var showingAlert: Bool = false
            
            var body: some View {
                Button(action: {
                    self.showingAlert = true
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }).alert(isPresented: $showingAlert) {
                    Alert(title: Text("Warning"),
                          message: Text("Are you sure you want to clear your list?"),
                          primaryButton: .cancel(Text("Cancel")),
                          secondaryButton: .destructive(Text("Confirm")) {
                            self.deleteAll()
                            self.showingAlert = false
                        })
                }
            }
            
            func deleteAll() {
                for item in self.groceries {
                    item.visible = false
                }
                CoreDataHelper.saveContext()
            }
        }
    }
    
    
    
    struct GroceryList: View {
        @FetchRequest(entity: Grocery.entity(),
                      sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)],
                      predicate: NSPredicate(format: "visible = %d", true),
                      animation: .spring())
        var groceries: FetchedResults<Grocery>
        
        var body: some View {
            List {
                ForEach(groceries, id: \.self) { grocery in
                    GroceryRow(grocery: grocery, isEditing: false)
                }
                .onDelete() { indexSet in
                    let grocery = self.groceries[indexSet.first!]
                    grocery.visible = false
                    CoreDataHelper.saveContext()
                }
                .onMove() { source, destination in
                    self.groceries.move(fromOffsets: source, toOffset: destination)
                    
                    CoreDataHelper.saveContext()
                }
                
                // Blank row for adding new grocery
                NewGroceryRow(position: self.groceries.count)
            }
        }
    }
}

// MARK: - Preview
struct GroceryList_Previews: PreviewProvider {
    
    static var previews: some View {
        return Group {
            GroceryNavigationView()
                .environment(\.managedObjectContext, CoreDataHelper.context)
                .environment(\.colorScheme, .dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
                .environment(\.locale, .init(identifier: "en"))
            
            GroceryNavigationView()
                .environment(\.managedObjectContext, CoreDataHelper.context)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
                .previewDisplayName("iPhone SE")
                .environment(\.locale, .init(identifier: "pt-br"))
        }
    }
}


// MARK: - Methods to get the keyboard status and size
final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height// - 110
        }
    }
    
    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
