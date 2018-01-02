//
//  essayVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class essayVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var essayId :String = ""
    private var entries:[String] = []
    private let entryId = "entry"
    @IBOutlet weak var tableCT: UITableView!
    @IBOutlet weak var introduction: UITextView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: entryId)
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:entryId)
        }
        
        cell!.textLabel?.text = entries[indexPath.row]
        return cell!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "add"){
            let VC = segue.destination as! chapVC
            VC.essayId = essayId
            VC.chapIndex = entries.count
            VC.op = "add"
        }else if(segue.identifier == "modify"){
            let VC = segue.destination as! chapVC
            let indexPath = tableCT.indexPath(for: sender as! UITableViewCell)
            
            // deal code after
            if let index = indexPath?.row {
                VC.essayId = essayId
                VC.chapIndex = index
                VC.op = "modify"
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                self.introduction.text = (results[0].value(forKey: "introduction") as? String)!
                self.entries = (results[0].value(forKey: "chapTitles") as? [String])!
            }
        }catch{
            fatalError("Fetch Failed")
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
                self.introduction.text = (results[0].value(forKey: "introduction") as? String)!
                self.entries = (results[0].value(forKey: "chapTitles") as? [String])!
            }
        }catch{
            fatalError("Fetch Failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func MyUnwind(unwindSegue:UIStoryboardSegue){
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
                self.introduction.text = (results[0].value(forKey: "introduction") as? String)!
                self.entries = (results[0].value(forKey: "chapTitles") as? [String])!
            }
        }catch{
            fatalError("Fetch Failed")
        }
        
        tableCT.reloadData()
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
