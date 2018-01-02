//
//  homeVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class homeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var ids:[String] = []
    private var entries:[NSManagedObject] = []
    private let entryId = "homeCell"
    @IBOutlet weak var tableCT: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: entryId, for: indexPath) as! homeCell
        
        cell.title = (entries[indexPath.row].value(forKey: "title") as? String)!
        cell.author = (entries[indexPath.row].value(forKey: "author") as? String)!
        let essayId = entries[indexPath.row].value(forKey: "id") as? String
        let chapNum = entries[indexPath.row].value(forKey: "chapNum") as? Int
        let chapIndex = chapNum! - 1
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let myDirect = documentsDirectory.appendingPathComponent(essayId!)
        let filePath = myDirect.appendingPathComponent("\(chapIndex).txt")
        let data = try! NSString(contentsOfFile: (filePath.path), encoding:String.Encoding.utf8.rawValue)
        cell.digest = data as String
        cell.introduction = (entries[indexPath.row].value(forKey: "introduction") as? String)!
        let titles:[String] = (entries[indexPath.row].value(forKey: "chapTitles") as? [String])!
        cell.newestChapTitle = titles[chapIndex]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableCT.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "content", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "content"){
            let indexPath = sender as! IndexPath//tableCT.indexPath(for: sender as! homeCell)
            let VC = segue.destination as! contentVC
            
            // deal code after
            let index = indexPath.row
            VC.essayId = (entries[index].value(forKey: "id") as? String)!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        var entity = NSEntityDescription.entity(forEntityName: "HomeList", in: managedObjectContext)
        
        fetchRequest.entity = entity
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                ids.removeAll()
                for one in results{
                    ids.append((one.value(forKey: "id") as? String)!)
                }
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
        tableCT.register(homeCell.self, forCellReuseIdentifier: entryId)
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tableCT.register(nib, forCellReuseIdentifier: entryId)
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
