//
//  AccountTableViewController.swift
//  Phobit
//
//  Created by 73 on 16.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController, UIAlertViewDelegate {
    
    
    @IBOutlet weak var verwendenCell: UITableViewCell!
    @IBOutlet weak var choosenToggle: UISwitch!
    @IBOutlet weak var firstLoginLable: UILabel!
    @IBOutlet weak var lastLoginLable: UILabel!
    
    var finalArr: [UserData] = [];
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        //THE NEXT BLOCKS WILL SET THE DATAS TO THE CELLS//
        
        /////////
        //TITLE//
        /////////
        
        let indexNumber = UserDefaults.standard.value(forKey: "clickedTabLoginScreen") as! Int;
        
        var thisArray: [UserData] = [];
        
        if var data = UserDefaults.standard.data(forKey: "UserData"),
            var test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue with reading the User Defaults / USER STRUCTURE")
        }
        
        finalArr = thisArray;
        
        self.title = thisArray[indexNumber].name;
        
        
        
        ///////////////
        //Ausgewaehlt//
        ///////////////
        if(indexNumber == 0){
            choosenToggle.isHidden = true;
            choosenToggle.setOn(true, animated: false);
            verwendenCell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else{
            choosenToggle.isHidden = false;
            
            choosenToggle.setOn(false, animated: false);
        }
        
        ///////////////////
        //Erste Anmeldung//
        ///////////////////
        //        let firstLogin =  thisArray[indexNumber].loginDate.description;
        //        var textLogin = firstLogin.split(separator: " ");
        //        firstLoginLable.text = "" + textLogin[0];
        
        //Gangl Version
        let firstLogin =  thisArray[indexNumber].loginDate
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "d.M.yyyy";
        let date = dateFormatter.string(from: firstLogin);
        firstLoginLable.text = date;
        
        ////////////////////
        //letzte Anmeldung//
        ////////////////////
        
        let lastlogin = thisArray[indexNumber].loginDate
        
        let date2 = dateFormatter.string(from: lastlogin)
        lastLoginLable.text = date2;
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mehtod clicked is for activating an User!
    @IBAction func clicked(_ sender: Any) {
        
        let indexNumber = UserDefaults.standard.value(forKey: "clickedTabLoginScreen") as! Int;
        if(choosenToggle.isOn == true){
            let user = finalArr.remove(at: indexNumber)
            finalArr.insert(user, at: 0);
            
            
            
        }
        else{
            let user = finalArr.remove(at: 0)
            finalArr.insert(user, at: indexNumber);
            
        }
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: finalArr)
        UserDefaults.standard.set(encodedData, forKey: "UserData");
        
        //NotificationCenter.default.post(name: Notification.Name("loadTableView"), object: nil)
        
    }
    @IBAction func clearPressed(_ sender: Any) {
        //ENCODING ARRAY START//
        var thisArray: [UserData] = [];
        if var data = UserDefaults.standard.data(forKey: "UserData"),
            var test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue with reading the User Defaults / USER STRUCTURE")
        }
        //ENCODING ARRAY END//
        
        //Presentig Alert View Start//
        let alertController = UIAlertController(title: "Löschen", message:
            "Willst du diesen Account wirklich löschen?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Nein", style: UIAlertActionStyle.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Ja", style: UIAlertActionStyle.cancel,handler: {action in let indexNumber = UserDefaults.standard.value(forKey: "clickedTabLoginScreen") as! Int;
            UserData.deleteUser(index: indexNumber);
            self.navigationController?.popViewController(animated: true);
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        //Presenting Alert View End//
        
        
        //Use the alertView Method to delete an Object from the Array!
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    //
    //
    //        return cell
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
