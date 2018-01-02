//
//  kindVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class kindVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var entries:[String:[NSManagedObject]] = [:]
    private let entryId = "entry"
    @IBOutlet weak var tableCT: UITableView!

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            return "短篇"
        case 1:
            return "长篇"
        default:
            return "Others"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var category:String
        switch(section){
        case 0:
            category = "短篇"
        case 1:
            category = "长篇"
        default:
            category = "Others"
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Essays", in: managedObjectContext)
        let condition = "category == '\(category)'"
        let predicate = NSPredicate(format: condition)
        
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                return results.count
            }
        }catch{
            fatalError("Fetch Failed")
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: entryId)
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:entryId)
        }
        var category:String
        switch(indexPath.section){
        case 0:
            category = "短篇"
        case 1:
            category = "长篇"
        default:
            category = "Others"
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Essays", in: managedObjectContext)
        let condition = "category == '\(category)'"
        let predicate = NSPredicate(format: condition)
        let titleSortDesc :NSSortDescriptor = {
            let sd = NSSortDescriptor(key: "title", ascending: true)
            return sd
        }()
        
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [titleSortDesc]
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                cell!.textLabel?.text = results[indexPath.row].value(forKey: "title") as? String
            }
        }catch{
            fatalError("Fetch Failed")
        }
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "content"){
            let indexPath = tableCT.indexPath(for: sender as! UITableViewCell)
            let VC = segue.destination as! contentVC
            
            // deal code after
            var category:String
            switch(indexPath?.section){
            case 0?:
                category = "短篇"
            case 1?:
                category = "长篇"
            default:
                category = "Others"
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let entity = NSEntityDescription.entity(forEntityName: "Essays", in: managedObjectContext)
            let condition = "category == '\(category)'"
            let predicate = NSPredicate(format: condition)
            let titleSortDesc :NSSortDescriptor = {
                let sd = NSSortDescriptor(key: "title", ascending: true)
                return sd
            }()
            
            fetchRequest.entity = entity
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [titleSortDesc]
            do{
                let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResults{
                    VC.essayId = (results[(indexPath?.row)!].value(forKey: "id") as? String)!
                }
            }catch{
                fatalError("Fetch Failed")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MyUnwind(unwindSegue:UIStoryboardSegue){
        
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
