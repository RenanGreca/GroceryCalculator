//
//  CloudKitHelper.swift
//  GroceryCalculator
//
//  Created by Renan Greca on 26/06/2020.
//  Copyright © 2020 Renan Greca. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitHelper {
    
    private static var subscriptionIsLocallyCached = false
    private static var privateDBChangeToken: CKServerChangeToken?
    private static let privateDB = CKContainer.default().privateCloudDatabase
    
    static let groceryItems = GroceryItems()

    static func subscribeToCloudChanges() {
        if (subscriptionIsLocallyCached) { return }
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "GroceryItem", predicate: predicate, subscriptionID: Bundle.main.bundleIdentifier!+".subscription.iCloud.GroceryCreate", options: CKQuerySubscription.Options.firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        privateDB.save(subscription, completionHandler: {
            subscription, error in
            if let error = error {
                print (error.localizedDescription)
            }
        })
        
        self.subscribeToCloudDeletion()
        
//        let subscription = CKDatabaseSubscription(subscriptionID: "private-changes")
//
//        let notificationInfo = CKSubscription.NotificationInfo()
//        notificationInfo.shouldSendContentAvailable = true
//        notificationInfo.alertBody = nil
//        subscription.notificationInfo = notificationInfo
//
//        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
//        operation.modifySubscriptionsCompletionBlock = {
//            subscription, subscriptionID, error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                subscriptionIsLocallyCached = true
//            }
//        }
//        operation.qualityOfService = .utility
//        privateDB.add(operation)
        
    }
    
    static func subscribeToCloudDeletion() {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "GroceryItem", predicate: predicate, subscriptionID: Bundle.main.bundleIdentifier!+".subscription.iCloud.GroceryDelete", options: CKQuerySubscription.Options.firesOnRecordDeletion)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        privateDB.save(subscription, completionHandler: {
            subscription, error in
            if let error = error {
                print (error.localizedDescription)
            }
        })
        
    }
    
    static func fetchPrivateChanges(_ callback: @escaping () -> Void) {
        var changedZones:[CKRecordZone.ID] = []
        
        let changesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: privateDBChangeToken)
        
        changesOperation.fetchAllChanges = true
        changesOperation.recordZoneWithIDChangedBlock = {
            (recordZoneID: CKRecordZone.ID) -> Void in
            changedZones.append(recordZoneID)
        }
        changesOperation.recordZoneWithIDWasDeletedBlock = {
            (recordZoneID: CKRecordZone.ID) -> Void in
        }
        changesOperation.changeTokenUpdatedBlock = {
            (newToken: CKServerChangeToken?) -> Void in
            privateDBChangeToken = newToken
        }
        
        changesOperation.fetchDatabaseChangesCompletionBlock = {
            (newToken: CKServerChangeToken?, more: Bool, error: Error?) -> Void in

            if let error = error {
                print(error.localizedDescription)
            } else {
                privateDBChangeToken = newToken
//                self.fetchZoneChanges(changedZones: changedZones, callback)
                DispatchQueue.main.async {
                    groceryItems.refresh()
                }
            }
        }
        privateDB.add(changesOperation)
    }
    
    //    func fetchZoneChanges(changedZones: [CKRecordZone.ID], _ callback: () -> Void) {
    //        let changesOperation = CKFetchRecordZoneChangesOperation(recordZoneIDs: changedZones, configurationsByRecordZoneID: nil)
    //
    //        changesOperation.fetchAllChanges = true
    //        changesOperation.recordChangedBlock = {
    //            (record: CKRecord) -> Void in
    //        }
    //
    //    }
}
