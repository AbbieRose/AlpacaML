//
//  Videos.swift
//  LPC Wearable Toolkit
//
//  Created by Abigail Zimmermann-Niefield on 7/20/18.
//  Copyright © 2018 Varun Narayanswamy LPC. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Videos {
    
    var managedVideos: [NSManagedObject] = []
    
    func countAll() -> Int {
        return fetchAll().count
    }
    
    func fetch(sport: String) -> [Video] {
        var videos: [Video] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return []
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Video")
        
        let sportPredicate = NSPredicate(format: "sport = %@", sport)
        fetchRequest.predicate = sportPredicate
        
        //3
        do {
            videos = try managedContext.fetch(fetchRequest) as? [Video] ?? []
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return videos
    }
    
    func fetchAll() -> [NSManagedObject] {
        var fetchedSports: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return []
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Video")
        
        //3
        do {
            fetchedSports = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchedSports
    }
    
    func save(name: String, url: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Video", in: managedContext)!
        let video = NSManagedObject(entity: entity, insertInto: managedContext)
        video.setValue(1, forKeyPath: "id")
        video.setValue(name, forKeyPath: "sport")
        video.setValue(url, forKey: "url")
        
        do {
            try managedContext.save()
            managedVideos.append(video)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
