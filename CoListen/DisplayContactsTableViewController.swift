//
//  DisplayContactsTableViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 3/27/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class DisplayContactsTableViewController: UITableViewController {

    let contactCell = "contactCell"
    var contactsArray : [CNContact]?
    var selectedContact : CNContact?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupButton()
        
        print("In the contacts TableViewController")
        
        self.view.backgroundColor = .blue
        tableView.register(ContactsCell.self, forCellReuseIdentifier: contactCell)
        
        
        if let count = contactsArray
        {
            print("Contacts count: \(count.count)")
        }
    }
    
    func setupButton()
    {
        //let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: 10), size: CGSize(width: self.view.frame.width / 5, height: self.view.frame.width / 8)))
        
        //button.backgroundColor = UIColor.darkGray
       // self.navigationController?.view.addSubview(button)
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.contactsArray?.count ?? 0
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactCell, for: indexPath)

        if let contact = contactsArray
        {
             cell.textLabel?.text = contact[indexPath.row].givenName + " "
                + contact[indexPath.row].familyName
        }
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedContact = contactsArray?[indexPath.row]
        self.navigationController?.popViewController(animated: true)
        
        let previousViewController = self.navigationController?.viewControllers.last as! AddFriendsView
        
        previousViewController.contactName = selectedContact
        previousViewController.createTextFormat()
    }

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ContactsCell : UITableViewCell
{
    let contactsLabel : UILabel =
    {
        let label = UILabel()
        return label
    }()
}
