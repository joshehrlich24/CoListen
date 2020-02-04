//
//  AddFriendsView.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/4/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class AddFriendsView: UIViewController, MFMessageComposeViewControllerDelegate {
    
    
    //IB Outlets
    @IBOutlet weak var openContactsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addFriendSearchBar: UISearchBar!
    @IBOutlet weak var saveButton: UIButton!
    var text : String?
    var results: [CNContact] = []
    var searchBarText:String?
    var contactName:CNContact?
    let composeVC : MFMessageComposeViewController? = nil

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
        
        print("yo")
        
        // fetchContacts()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFriendsSegue"
        {
            let _ = segue.destination as! FriendsViewController
        }
        
        if segue.identifier == "DisplayContactsSegue"
        {
            let destVC = segue.destination as! DisplayContactsTableViewController
            destVC.contactsArray = results
            
        }
    }
    
    func fetchContacts() {
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
           
            
            if let err = err
            {
                print("Failed to request access\(err.localizedDescription)")
                return
            }
            
            if ( granted )
            {
                // now we can get the contacts
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do
                {
                    try store.enumerateContacts(with: request, usingBlock:
                    {
                        (contact, stopPointerToStopEnumerating) in
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        self.results.append(contact)
                    })
                }
               
                catch let err
                {
                    print("Failed to return contacts", err)
                }
                
            }
            else
            {
                print("Access denied")
            }
            
        } //Close in
         //print("Contacts count: \(results.count)")
    }
    
    
    func setupView()
    {
        addFriendSearchBar.placeholder = "Enter Name or Phone Number"
        
        saveButton.backgroundColor = UIColor(displayP3Red: 0, green: 254, blue: 0, alpha: 1)
        cancelButton.backgroundColor = UIColor(displayP3Red: 254, green: 0, blue: 0, alpha: 1)
        
    }
 

    @IBAction func contactsButtonPressed(_ sender: Any) {
        fetchContacts()
        
        if(results.count > 0)
        {
            performSegue(withIdentifier: "DisplayContactsSegue", sender: self)
        }
   
    }
    
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton)
    {
        
        if (addFriendSearchBar.text != nil && (addFriendSearchBar.text?.count)! >= 7) // sloppy unwrap
        {
            
            // checking for phone numbers
            searchBarText = addFriendSearchBar.text
            for contact in results
            {
                if (searchBarText == contact.phoneNumbers.first?.value.stringValue)
                {
                    contactName = contact
                }
            }
        }
        
        // pop up saying send text to ______
        
        // send text and go back to screen
        
    }
    
    func createTextFormat()
    {
        print("Hello")
        if MFMessageComposeViewController.canSendText()
        {
            print("We can send texts")
            let controller = MFMessageComposeViewController()
        controller.body = "Message from CoListen, be my friend :)"
            controller.recipients = [self.contactName?.phoneNumbers.first?.value.stringValue] as? [String]
            controller.messageComposeDelegate = self
        }
        else
        {
            print("We cannot send texts")
        }
    }
    
//    @IBAction func unwindFromContacts(_ sender: UIStoryboardSegue)
//    {
//        if sender.source is DisplayContactsTableViewController
//        {
//            if let senderVC = sender.source as? DisplayContactsTableViewController
//            {
//                contactName = senderVC.selectedContact
//            }
//        }
//    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
//        if ( composeVC.canSendText() ) {
//
//            composeVC.messageComposeDelegate = self
//
//            // Configure the fields of the interface.
//            composeVC.recipients = [contactName!.phoneNumbers.first?.value.stringValue] as? [String]
//            composeVC.body = "Invite blah to CoListen?"
//
//            // Present the view controller modally.
//            self.present(composeVC, animated: true, completion: nil)
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // add IBOUtlet thing for adding a friend
    // if selected, have a search bar able to be typed in with search button
//    func searchContacts( keywords: String ) -> Array {
//        if ( hasContacts ) {
//            // create the contact
//            let store = CNContactStore()
//            
//            var contactsFound: Array
//            var wordsToSearch = split(keywords) {$0 == " "}
//            
//            // search through contacts with each name provided
//            for name in wordsToSearch {
//                
//                let num:Int? = Int(name) // is it an int
//                if ( num != nil ) {
//                    // search for phone number store.unifiedContactsMatchingPredicate(CNContact.predicateForContactsMatchingName(name), keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey])
//                }
//                
//                let contacts = try store.unifiedContactsMatchingPredicate(CNContact.predicateForContactsMatchingName(name), keysToFetch:[CNContactGivenNameKey, CNContactFamilyNameKey])
//                
//                if ( contacts != nil ) {
//                    contactsFound.append(contentsOf:contacts);
//                }
//            }
//            
//        } else {
//            // pop up to ask for permission
//            // if user selects yes, search the contacts
//            // if no, exit this method
//        }
//        
//        return contactsFound;
//    }


}
