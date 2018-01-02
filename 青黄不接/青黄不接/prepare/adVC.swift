//
//  adVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class adVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var essayList :[String] = []
        
        let urlPath:String = "https://raw.githubusercontent.com/Mr-Ace-1997/appData/master"
        let session = URLSession.shared
        
        // load homeList
        var homeList :[String] = []
        var homeListLoaded:Bool = false
        var url = URL(string:urlPath)
        url = url?.appendingPathComponent("homeList.json")
        var urlRequest = URLRequest(url:url!)
        var task = session.downloadTask(with: urlRequest, completionHandler:{(location:URL?, response: URLResponse?, error: Error?) -> Void in
            do{
                let data = try Data(contentsOf: location!)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                homeList = json["ids"] as! [String]
                homeListLoaded = true
            }catch{
                fatalError("JSON ERROR")
            }
        })
        task.resume()
        
        while(homeListLoaded == false){
        }
//output
        print(homeList)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        var condition :String
        var predicate :NSPredicate
        
        var entity = NSEntityDescription.entity(forEntityName: "HomeList", in: managedObjectContext)
        for id in homeList {
            condition = "id == '\(id)'"
            predicate = NSPredicate(format: condition)
            fetchRequest.entity = entity
            fetchRequest.predicate = predicate
            do{
                let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
                if let result = fetchedResults{
                    if(result.count == 0){
                        let essay = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                        essay.setValue(id, forKey: "id")
                    
                        essayList.append(id)
                    }
                }
            }catch{
                fatalError("Fetch Failed")
            }
            
        }
        
        // load userinfo
        var userId:String = ""
        var passwd:String = ""
        var userName:String = ""
        var concerns :[String] = []
        var essays :[String] = []
        var userInfoLoaded:Bool = false
        url = URL(string:urlPath)
        url = url?.appendingPathComponent("user.json")
        urlRequest = URLRequest(url:url!)
        task = session.downloadTask(with: urlRequest, completionHandler:{(location:URL?, response: URLResponse?, error: Error?) -> Void in
            do{
                let data = try Data(contentsOf: location!)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                userId = json["id"] as! String
                passwd = json["passwd"] as! String
                userName = json["userName"] as! String
                concerns = json["concerns"] as! [String]
                essays = json["essays"] as! [String]
                userInfoLoaded = true
            }catch{
                fatalError("JSON ERROR")
            }
        })
        task.resume()
        
        while(userInfoLoaded == false){
        }
// output
        print(userId)
        entity = NSEntityDescription.entity(forEntityName: "Users", in: managedObjectContext)
        condition = "id == '\(userId)'"
        predicate = NSPredicate(format: condition)
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let result = fetchedResults{
                if(result.count == 0){
                    let user = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                    user.setValue(userId, forKey: "id")
                    user.setValue(passwd, forKey: "passwd")
                    user.setValue(userName, forKey: "userName")
                    user.setValue(concerns, forKey: "concerns")
                    user.setValue(essays, forKey: "essays")
                }
            }
        }catch{
            fatalError("Fetch Failed")
        }
        
        for id in concerns {
            essayList.append(id)
        }
        
        for id in essays {
            essayList.append(id)
        }

        entity = NSEntityDescription.entity(forEntityName: "Essays", in: managedObjectContext)
        for id in essayList {
            condition = "id == '\(id)'"
            predicate = NSPredicate(format: condition)
            fetchRequest.entity = entity
            fetchRequest.predicate = predicate
            do{
                let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
                if let result = fetchedResults{
                    if(result.count == 0){
                        // download files needed
                        let essay = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                        url = URL(string:urlPath)
                        url = url?.appendingPathComponent("\(id).json")
                        urlRequest = URLRequest(url:url!)
                        var num:Int = 0
                        task = session.downloadTask(with: urlRequest, completionHandler:{(location:URL?, response: URLResponse?, error: Error?) -> Void in
                            do{
                                let data = try Data(contentsOf: location!)
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                                print(json)
                                essay.setValue(json["id"] as! String, forKey: "id")
                                essay.setValue(json["title"] as! String, forKey: "title")
                                essay.setValue(json["author"] as! String, forKey: "author")
                                essay.setValue(json["introduction"] as! String, forKey: "introduction")
                                essay.setValue(json["category"] as! String, forKey: "category")
                                essay.setValue(json["chapNum"] as! Int, forKey: "chapNum")
                                essay.setValue(json["chapTitles"] as! [String], forKey: "chapTitles")
                                num = json["chapNum"] as! Int
                            }catch{
                                fatalError("JSON ERROR")
                            }
                        })
                        task.resume()
                        
                        let fileManager = FileManager.default
                        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let myDirect = documentsDirectory.appendingPathComponent(id)
                        try! fileManager.createDirectory(atPath: myDirect.path, withIntermediateDirectories: true, attributes: nil)
                        
                        while(num == 0){
                            
                        }
                        
                        for i in 0..<num {
                            url = URL(string:urlPath)
                            url = url?.appendingPathComponent("\(id)/\(i).txt")
                            urlRequest = URLRequest(url:url!)
                            task = session.downloadTask(with: urlRequest, completionHandler:{(location:URL?, response: URLResponse?, error: Error?) -> Void in
                                    let locationPath = location
                                    let destinationPath = myDirect.appendingPathComponent("\(i).txt")
                                    print(destinationPath.path)
                                    try! fileManager.moveItem(at: locationPath!, to: destinationPath)
                            })
                            task.resume()
                        }
                    }
                }
            }catch{
                fatalError("Fetch Failed")
            }
        }
        
        //load contents
/*        for id in essayList{
            condition = "id == '\(id)'"
            predicate = NSPredicate(format: condition)
            fetchRequest.entity = entity
            fetchRequest.predicate = predicate
            do{
                let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
                if let result = fetchedResults{
                    let essay = result[0]
                    var contents:[String] = []
                    
                    let num = essay.value(forKey: "chapNum") as! Int
                    let fileManager = FileManager.default
                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let myDirect = documentsDirectory.appendingPathComponent(id)
                    
                    for i in 0..<num {
                        let filePath = myDirect.appendingPathComponent("\(i).txt")
                        let data = try NSString(contentsOfFile: (filePath.path), encoding:String.Encoding.utf8.rawValue)
                        print(data)
                        contents.append(data as String)
                    }
                    print(contents)
                    essay.setValue(contents, forKey: "chapContents")
                }
            }catch{
                fatalError("Fetch Failed")
            }
        }
  */
        do{
            try managedObjectContext.save()
        }catch {
            fatalError("Can't Save")
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
