//
//  LoversTableViewController.swift
//  Demo
//
//  Created by Peter Pan on 13/12/2016.
//  Copyright © 2016 Peter Pan. All rights reserved.
//

import UIKit

class DeathTableViewController: UITableViewController {

  
    var isAddLover = false
    
    var lovers = [[String:String]]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        if isAddLover {
            isAddLover = false
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            
        }
    }
    
    func updateFile() {
        let fileManager = FileManager.default
        let docUrls =
            fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("lovers.txt")
        let result = (lovers as NSArray).write(to: url!, atomically: true)
        
        print("result \(result)")
    }
    
    func addLoverNoti(noti:Notification) {
        let dic = noti.userInfo as! [String:String]
        lovers.insert(dic, at: 0)
        
        updateFile()
        
        isAddLover = true
        
       
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let fileManager = FileManager.default
        let docUrls =
            fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("lovers.txt")
        let array = NSArray(contentsOf: url!)
        if array != nil {
            lovers = array as! [[String:String]]
            
        }
        
        
        let notiName = Notification.Name("addLover")
        NotificationCenter.default.addObserver(self, selector: #selector(DeathTableViewController.addLoverNoti(noti:)), name: notiName, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lovers.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeathCell", for: indexPath) as! DeathTableViewCell
        let dic = lovers[indexPath.row]

        let fileManager = FileManager.default
        let docUrls =
            fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("\(dic["name"]!).png")
        

        
        cell.photo.image = UIImage(contentsOfFile: url!.path)
        
        cell.name.text = dic["name"]
        cell.time.text = dic["death_time"]
        //cell.starImageView.image = UIImage(named: dic["name"]!)
        
        
        

        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let controller = UIAlertController(title: "確定刪除?", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            self.lovers.remove(at: indexPath.row)
            self.updateFile()
            
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            
        }
        
        controller.addAction(action)
        
        let action2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
        controller.addAction(action2)

        present(controller, animated: true, completion: nil)
        
        
        

       
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Detail" {
            let controller = segue.destination as! DeathDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            controller.loverInfoDic = lovers[indexPath!.row]
        }
        
       

       
    }
    

}
