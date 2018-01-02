//
//  listVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class listVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var ids:[String] = []
    private var entries:[NSManagedObject] = []
    private let entryId = "entry"
    @IBOutlet weak var tableCT: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: entryId)
        if(cell == nil){
            cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:entryId)
        }
        
        cell!.textLabel?.text = entries[indexPath.row].value(forKey: "title") as? String
        
        return cell!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "essay"){
            let indexPath = tableCT.indexPath(for: sender as! UITableViewCell)
            let VC = segue.destination as! essayVC
            
            // deal code after
            if let index = indexPath?.row{
                VC.essayId = (entries[index].value(forKey: "id")  as? String)!
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        var entity = NSEntityDescription.entity(forEntityName: "Users", in: managedObjectContext)
        
        fetchRequest.entity = entity
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                ids.removeAll()
                ids = (results[0].value(forKey: "essays") as? [String])!
            }
        }catch{
            fatalError("Fetch Failed")
        }
        
        entity = NSEntityDescription.entity(forEntityName: "Essays", in: managedObjectContext)
        let titleSortDesc :NSSortDescriptor = {
            let sd = NSSortDescriptor(key: "title", ascending: true)
            return sd
        }()
        var condition:String = "id IN {"
        for i in ids{
            condition += "'" + i + "'"
            if (i != ids.last){
                condition += ","
            }
        }
        condition += "}"
        let predicate = NSPredicate(format: condition)
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = [titleSortDesc]
        fetchRequest.predicate = predicate
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                entries = results
                
                tableCT.reloadData()
            }
        }catch {
            fatalError("Fetch Failed")
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
