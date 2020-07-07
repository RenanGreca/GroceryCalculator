//
//  Settings.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 07/07/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import SwiftUI
import Social
import Foundation

struct Settings: View {
    @Binding var pushed: Bool
    @State var tweeting = false
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y"
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("About this app")
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                
                List {
                    HStack {
                        Color.primary.mask(
                            Image("github-logo")
                                .resizable()
                                .scaledToFit()
                        )
                        .frame(width: 25, height: 25)
                        Text("GitHub")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(Color(UIColor.secondarySystemBackground))
                    .onTapGesture {
                        let url = URL(string: "github://RenanGreca/GroceryCalculator")!
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            let url = URL(string: "https://github.com/RenanGreca/GroceryCalculator")!
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                    HStack {
                        Color.primary.mask(
                            Image("twitter-logo")
                                .resizable()
                                .scaledToFit()
                        )
                        .frame(width: 25, height: 25)
                        Text("Twitter")
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(Color(UIColor.secondarySystemBackground))
                    .onTapGesture {
                        let url = URL(string: "twitter://user?screen_name=RenanGreca")!
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            let url = URL(string: "https://twitter.com/RenanGreca")!
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }

                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.primary)
                        Text("Email")
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(Color(UIColor.secondarySystemBackground))
                    
                }
                .frame(height: 140)
//                .disabled(true)
                
                
                
                Spacer()
                Text("GPL v3.0 \(year) Renan Greca")
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                self.pushed.toggle()
            }) {
                Text("Done").fontWeight(.bold)
            })
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(pushed: .constant(false))
            .environment(\.colorScheme, .dark)
    }
}
