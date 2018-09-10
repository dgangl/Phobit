//
//  LoginTableViewController.swift
//  Phobit
//
//  Created by 73 on 08.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class LoginTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData();
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let thisArray = UserData.getWholeArray()
        
        return thisArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let thisArray = UserData.getWholeArray()
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as!
        MGSwipeTableCell
        cell.textLabel!.text = thisArray[indexPath.row].name
        
        cell.rightButtons = [
            MGSwipeButton(title: "Löschen", backgroundColor: UIColor.APPLE_red){
                (sender: MGSwipeTableCell!) -> Bool in
                self.clearFromArray(stelle: indexPath.row)
                print("Gelöscht")
                
                return true
            },
            MGSwipeButton(title: "Auswählen",backgroundColor: UIColor.APPLE_tealBlue){
                (sender: MGSwipeTableCell!) -> Bool in
                print("Ausgewählt")
                self.chooseIt(stelle: indexPath.row);
//                tableView.reloadData();
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)

                self.tableView.reloadSections(sections as IndexSet, with: .top)
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                return true
            }
            
        ]
        cell.rightSwipeSettings.transition = .clipCenter
        
        if(indexPath.row != 0){
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else if(indexPath.row == 0){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        UserDefaults.standard.set(indexPath, forKey: "clickedTabLoginScreen");
        let varia = indexPath.row
        
        UserDefaults.standard.set(varia, forKey: "clickedTabLoginScreen");
        
        performSegue(withIdentifier: "toAccount", sender: self);
        
        
    }
    func clearFromArray(stelle: Int){
        var thisArray = UserData.getWholeArray()
        
        //Presentig Alert View Start//
        let alertController = UIAlertController(title: "Löschen", message:
            "Willst du diesen Account wirklich löschen?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Nein", style: UIAlertActionStyle.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.cancel,handler: {action in let indexNumber = stelle as! Int;
            UserData.deleteUser(index: indexNumber);
            
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            
            self.tableView.reloadSections(sections as IndexSet, with: .left)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        //Presenting Alert View End//
        
        
        //Use the alertView Method to delete an Object from the Array!
    }
    
    func chooseIt(stelle: Int) {
        //Put it to the top!
        
        //ENCODING ARRAY START//
        var thisArray: [UserData] = [];
        if let data = UserDefaults.standard.data(forKey: "UserData"),
            let test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue with reading the User Defaults / USER STRUCTURE")
        }
        //ENCODING ARRAY END//
        
        let user = thisArray.remove(at: stelle)
        thisArray.insert(user, at: 0);
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: thisArray)
        UserDefaults.standard.set(encodedData, forKey: "UserData");
        //NotificationCenter.default.post(name: Notification.Name("loadTableView"), object: nil)
        print("RELOADING TABLE DATA")
        
    }
    
    //    @IBAction func deletePressed(_ sender: Any) {
    //        var thisArray: [UserStructure] = [];
    //
    //        if var data = UserDefaults.standard.data(forKey: "UserData"),
    //            var test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserStructure] {
    //            thisArray = test;
    //        } else {
    //            print("There is an issue")
    //        }
    //
    //
    //
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

