//
//  SearchViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/6/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit

//UI - IB Outlets


class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UICollectionViewDelegate  {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentSearchesLabel: UILabel!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var genreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*var contacts = [CNContact]()
        // the parts of the contact we want to fetch: name & phone number
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        
        // for testing
        print(contacts.count)
        
        do {
            try self.contactStore.enumerateContactsWithFetchRequest(request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }*/
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
