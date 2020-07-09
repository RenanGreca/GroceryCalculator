//
//  GroceryList.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 10/01/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import WatchConnectivity

struct GroceryList: View {
    
    @ObservedObject var keyboard = KeyboardResponder()
    @State var showingAlert = false
    @State var pushed = false
    
    @Environment(\.managedObjectContext) var context
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
                    // Row showing total value of purchase
                    if (keyboard.currentHeight == 0) {
                        TotalRow(totalPrice: totalPrice)
                    }
                }
                .navigationBarTitle(Text("Grocery List"))
                .navigationBarItems(leading: leadingButton,
                                    trailing: EditButton())
                    .padding(.bottom, (keyboard.currentHeight > 0 ? keyboard.currentHeight-35 : 0))
                    .animation(.easeInOut(duration: 0.16))
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    var leadingButton: some View {
        HStack {
            Button(action: {
                self.pushed = true
            }, label: {
                Image(systemName: "gear")
            })
            .sheet(isPresented: $pushed) {
                Settings(pushed: self.$pushed)
            }
            .padding(.trailing, 10)

            Button(action: {
                self.showingAlert = true
            }, label: {
                Image(systemName: "trash")
                        .foregroundColor(.red)
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Warning"),
                      message: Text("Are you sure you want to clear your list?"),
                      primaryButton: .cancel(Text("Cancel")),
                      secondaryButton: .destructive(Text("Confirm")) {
                        self.deleteAll()
                        self.showingAlert = false
                    })
            }
        }
    }
    
    func deleteAll() {
        for item in self.fetchedGroceries {
            item.visible = false
        }
        CoreDataHelper.saveContext()
    }
    
}

extension GroceryList {
    
    struct ClearButton: View {
        
        @Binding var showingAlert: Bool
        var deleteAll: () -> Void
        
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
    }
    
    func GroceryList() -> some View {
        List {
            ForEach(fetchedGroceries, id: \.self) { grocery in
                ListRow(grocery: grocery, isEditing: false)
            }
            .onDelete() { indexSet in
                let grocery = self.fetchedGroceries[indexSet.first!]
                grocery.visible = false
                CoreDataHelper.saveContext()
            }
            .onMove() { source, destination in
                var list = self.fetchedGroceries.compactMap() { $0 }
                
                list.move(fromOffsets: source, toOffset: destination)
                
                for i in 0..<list.count {
                    list[i].updatePosition(index: i)
                }
                
                CoreDataHelper.saveContext()
            }
            
            // Blank row for adding new grocery
            NewGroceryRow(position: self.fetchedGroceries.count)
        }
    }
}

struct GroceryList_Previews: PreviewProvider {
    
    static var previews: some View {
        return Group {
            GroceryList()
                .environment(\.managedObjectContext, CoreDataHelper.context)
                .environment(\.colorScheme, .dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
                .environment(\.locale, .init(identifier: "en"))
            
            GroceryList()
                .environment(\.managedObjectContext, CoreDataHelper.context)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
                .previewDisplayName("iPhone SE")
                .environment(\.locale, .init(identifier: "pt-br"))
        }
    }
}

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
