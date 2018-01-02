//
//  personVC.swift
//  青黄不接
//
//  Created by Mr.Ace on 2017/12/10.
//  Copyright © 2017年 Mr.Ace. All rights reserved.
//

import UIKit
import CoreData

class personVC: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func Note(_ sender: Any) {
        let alert = UIAlertController(title: "敬请期待！",message: "",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel) { (action: UIAlertAction) in
            
        }
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    @IBAction func Note2(_ sender: Any) {
        let alert = UIAlertController(title: "敬请期待！",message: "",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel) { (action: UIAlertAction) in
            
        }
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    @IBAction func Note3(_ sender: Any) {
        let alert = UIAlertController(title: "敬请期待！",message: "",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel) { (action: UIAlertAction) in
            
        }
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
/*       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedObjectContext)
        
        fetchRequest.entity = entity
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                if (results.count != 0){
                    managedObjectContext.delete(results[0])
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
*/
        let alert = UIAlertController(title: "仅供体验，暂未开放正式用户资格",message: "",preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action: UIAlertAction) in
            
        }
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedObjectContext)
        
        fetchRequest.entity = entity
        do{
            let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults{
                if (results.count == 0){
                    let alert = UIAlertController(title: "需要登录才能进行操作",message: "",preferredStyle: .alert)
                    present(alert,animated: true,completion: nil)
                }else{
                    self.userName.text = results[0].value(forKey: "userName") as? String
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
