//
//  FriendsViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/4/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit
import Contacts

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Class properties
    
//    var myFriend : Friend?
//    var myFriends : [Friend] = [] // Friends Array : no friends to start
    
    //IB Outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var friendsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Is it assumed I only have one section?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myFriends.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
        //Set the elements of the cell:
        //  - Profile Picture
        //  - UserName
        //  - Button?
        
        //Should have some defaults if a user does not set these(i.e never adds a profile picture)
//        cell.friendCellUserName.text = myFriends[indexPath.row].name
//        cell.friendCellProfilePicture.image = myFriends[indexPath.row].profilePic
        
        return cell
    }

}

/********************************
 Customize your Friends cell here
 ********************************/
class FriendCell: UITableViewCell {
    @IBOutlet weak var friendCellProfilePicture: UIImageView!
    @IBOutlet weak var friendCellUserName: UILabel!
    @IBOutlet weak var moreOptionsButton: UIButton!
    
    
}
