//
//  chapVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class chapVC: UIViewController {
    var essayId:String = ""
    var chapIndex:Int = 0
    var op:String = ""
    @IBOutlet weak var chapTitle: UITextField!
    @IBOutlet weak var chapContent: UITextView!
    
    @IBAction func Save(_ sender: Any) {
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
                if let title = self.chapTitle.text {
                    var titles:[String] = (results[0].value(forKey: "chapTitles") as? [String])!
                    if(op == "add"){
                        titles.append(title)
                    }else if(op == "modify"){
                        titles[chapIndex] = title
                    }
                    results[0].setValue(titles,forKey: "chapTitles")
                }
                
                if let content = self.chapContent.text {
                    let fileManager = FileManager.default
                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let myDirect = documentsDirectory.appendingPathComponent(essayId)
                    let filePath = myDirect.appendingPathComponent("\(chapIndex).txt")
                    let data:String = content
                    
                    if(op == "add"){
                        try! data.write(to: filePath,atomically: true, encoding:String.Encoding.utf8)
                    }else if(op == "modify"){
                        try! data.write(to: filePath,atomically: true, encoding:String.Encoding.utf8)
                    }
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
                if(op == "add"){
                    self.chapTitle.text = "请在此处输入标题"
                    self.chapContent.text = "请在此处输入正文"
                }else if(op == "modify"){
                    let titles:[String] = (results[0].value(forKey: "chapTitles") as? [String])!
                    self.chapTitle.text = titles[chapIndex]
                    
                    let fileManager = FileManager.default
                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let myDirect = documentsDirectory.appendingPathComponent(essayId)
                    let filePath = myDirect.appendingPathComponent("\(chapIndex).txt")
                    let data = try NSString(contentsOfFile: (filePath.path), encoding:String.Encoding.utf8.rawValue)
                    self.chapContent.text = data as String
                }
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
    @IBAction func MyUnwind(unwindSegue:UIStoryboardSegue){
        print(unwindSegue.identifier)
        print(unwindSegue.destination)
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
