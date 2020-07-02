//
//  HostingController.swift
//  Shopping Extension
//
//  Created by Renan Greca on 08/05/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import CoreData

class HostingController: WKHostingController<AnyView> {
    private(set) var context: NSManagedObjectContext!
    
    override func awake(withContext context: Any?) {
        self.context = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    }
    
    override var body: AnyView {
        return AnyView(ContentView()
            .environment(\.managedObjectContext, context)
        )
    }
}
