////
////  CloudKitHelper.swift
////  GroceryCalculator
////
////  Created by Renan Greca on 26/06/2020.
////  Copyright © 2020 Renan Greca. All rights reserved.
////
//
//import Foundation
//import CloudKit
//
//class CloudKitHelper {
//    
//    private static var subscriptionIsLocallyCached = false
//    private static var privateDBChangeToken: CKServerChangeToken?
//    private static let privateDB = CKContainer.default().privateCloudDatabase
//    
//    static let container = CKContainer.default()
//    static let zoneID = CKRecordZone.default().zoneID
//    static var createdCustomZone = false
//    
//    static let groceryItems = GroceryItems()
//
//    static func subscribeToCloudChanges() {
//        if (subscriptionIsLocallyCached) { return }
//        
//        let predicate = NSPredicate(value: true)
//        let subscription = CKQuerySubscription(recordType: "GroceryItem", predicate: predicate, subscriptionID: Bundle.main.bundleIdentifier!+".subscription.iCloud.GroceryCreate", options: CKQuerySubscription.Options.firesOnRecordCreation)
//        
//        let notificationInfo = CKSubscription.NotificationInfo()
//        notificationInfo.shouldSendContentAvailable = true
//        subscription.notificationInfo = notificationInfo
//        
//        privateDB.save(subscription, completionHandler: {
//            subscription, error in
//            if let error = error {
//                print (error.localizedDescription)
//            }
//        })
//        
//        self.subscribeToCloudDeletion()
//        
////        let subscription = CKDatabaseSubscription(subscriptionID: "private-changes")
////
////        let notificationInfo = CKSubscription.NotificationInfo()
////        notificationInfo.shouldSendContentAvailable = true
////        notificationInfo.alertBody = nil
////        subscription.notificationInfo = notificationInfo
////
////        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
////        operation.modifySubscriptionsCompletionBlock = {
////            subscription, subscriptionID, error in
////            if let error = error {
////                print(error.localizedDescription)
////            } else {
////                subscriptionIsLocallyCached = true
////            }
////        }
////        operation.qualityOfService = .utility
////        privateDB.add(operation)
//        
//    }
//    
//    static func subscribeToCloudDeletion() {
//        
//        let predicate = NSPredicate(value: true)
//        let subscription = CKQuerySubscription(recordType: "GroceryItem", predicate: predicate, subscriptionID: Bundle.main.bundleIdentifier!+".subscription.iCloud.GroceryDelete", options: CKQuerySubscription.Options.firesOnRecordDeletion)
//        
//        let notificationInfo = CKSubscription.NotificationInfo()
//        notificationInfo.shouldSendContentAvailable = true
//        subscription.notificationInfo = notificationInfo
//        
//        privateDB.save(subscription, completionHandler: {
//            subscription, error in
//            if let error = error {
//                print (error.localizedDescription)
//            }
//        })
//        
//    }
//    
//    static func fetchPrivateChanges(_ callback: @escaping () -> Void) {
//        var changedZones:[CKRecordZone.ID] = []
//        
//        let changesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: privateDBChangeToken)
//        
//        changesOperation.fetchAllChanges = true
//        changesOperation.recordZoneWithIDChangedBlock = {
//            (recordZoneID: CKRecordZone.ID) -> Void in
//            changedZones.append(recordZoneID)
//        }
//        changesOperation.recordZoneWithIDWasDeletedBlock = {
//            (recordZoneID: CKRecordZone.ID) -> Void in
//        }
//        changesOperation.changeTokenUpdatedBlock = {
//            (newToken: CKServerChangeToken?) -> Void in
//            privateDBChangeToken = newToken
//        }
//        
//        changesOperation.fetchDatabaseChangesCompletionBlock = {
//            (newToken: CKServerChangeToken?, more: Bool, error: Error?) -> Void in
//
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                privateDBChangeToken = newToken
////                self.fetchZoneChanges(changedZones: changedZones, callback)
//                DispatchQueue.main.async {
//                    groceryItems.refresh()
//                }
//            }
//        }
//        privateDB.add(changesOperation)
//    }
//    
//    static func fetchZoneChanges(database: CKDatabase, databaseTokenKey: String, zoneIDs: [CKRecordZone.ID], completion: @escaping () -> Void) {
//        
//        // Look up the previous change token for each zone
//        var optionsByRecordZoneID = [CKRecordZone.ID: CKFetchRecordZoneChangesOperation.ZoneConfiguration]()
//        for zoneID in zoneIDs {
//            let options = CKFetchRecordZoneChangesOperation.ZoneConfiguration()
//            //options.previousServerChangeToken = … // Read change token from disk
//                optionsByRecordZoneID[zoneID] = options
//        }
//        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: zoneIDs, configurationsByRecordZoneID: optionsByRecordZoneID)
//        
//        operation.recordChangedBlock = { (record) in
//            print("Record changed:", record)
//            // Write this record change to memory
//        }
//        
//        operation.recordWithIDWasDeletedBlock = { (recordId: CKRecord.ID, recordType: CKRecord.RecordType) -> Void in
//            print("Record deleted:", recordId)
//            // Write this record deletion to memory
//        }
//        
//        operation.recordZoneChangeTokensUpdatedBlock = { (zoneId, token, data) in
//            // Flush record changes and deletions for this zone to disk
//            // Write this new zone change token to disk
//        }
//        
//        operation.recordZoneFetchCompletionBlock = { (zoneId, changeToken, _, _, error) in
//            if let error = error {
//                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
//                return
//            }
//            // Flush record changes and deletions for this zone to disk
//            // Write this new zone change token to disk
//        }
//        
//        operation.fetchRecordZoneChangesCompletionBlock = { (error) in
//            if let error = error {
//                print("Error fetching zone changes for \(databaseTokenKey) database:", error)
//            }
//            completion()
//        }
//        
//        database.add(operation)
//    }
//    
//    static func createCustomZones() {
//        
//        let createZoneGroup = DispatchGroup()
//         
//        if !createdCustomZone {
//            createZoneGroup.enter()
//            
//            let customZone = CKRecordZone(zoneID: zoneID)
//            
//            let createZoneOperation = CKModifyRecordZonesOperation(recordZonesToSave: [customZone], recordZoneIDsToDelete: [] )
//            
//            createZoneOperation.modifyRecordZonesCompletionBlock = { (saved, deleted, error) in
//                if (error == nil) { self.createdCustomZone = true }
//                // else custom error handling
//                createZoneGroup.leave()
//            }
//            createZoneOperation.qualityOfService = .userInitiated
//            
//            privateDB.add(createZoneOperation)
//        }
//        
////        createZoneGroup.notify(queue: DispatchQueue.global(), work: nil)
//
//
//    }
//}
