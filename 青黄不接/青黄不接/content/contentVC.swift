//
//  contentVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class contentVC: UIViewController {
    var essayId:String = ""
    @IBOutlet weak var content: UITextView!
    
    @IBAction func AddConcern(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedObjectContext)
        
        fetchRequest.entity = entity
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                var concerns:[String] = (results[0].value(forKey: "concerns") as? [String])!
                if(concerns.contains(essayId) == false){
                    concerns.append(essayId)
                    results[0].setValue(concerns, forKey: "concerns")
                }
            }
        }catch{
            fatalError("Fetch Failed")
        }
        
        do{
            try managedObjectContext.save()
        }catch {
            fatalError("Can't Save")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Essays", in: managedObjectContext)
        let condition :String = "id == \(essayId)"
        let predicate :NSPredicate = NSPredicate(format: condition)

        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                let chapNum = (results[0].value(forKey:"chapNum") as? Int)
                let fileManager = FileManager.default
                let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let myDirect = documentsDirectory.appendingPathComponent(essayId)
                let chapIndex = chapNum! - 1
                let filePath = myDirect.appendingPathComponent("\(chapIndex).txt")
                let data = try NSString(contentsOfFile: (filePath.path), encoding:String.Encoding.utf8.rawValue)
                self.content.text = data as String
            }
        }catch{
            fatalError("Fetch Failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
