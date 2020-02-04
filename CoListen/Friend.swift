////
////  Friend.swift
////  CoListen
////
////  Created by Josh Ehrlich on 2/1/19.
////  Copyright © 2019 Josh Ehrlich. All rights reserved.
////
//
//import Foundation
//
//class Friend
//{
//    private var colistenID : Int
//    private var name : String
//    private var profilePic: UIImage
//    private var isOnline : Bool
//    private var colistenUsername : String
//    private var spotifyUname : String
//    private var friendList : [Friend]
//    private var hasContacts : Bool
//
//    
//    init( cID: int, name: String, isOnline: Bool, colistenUsername: String) {
//        self.name = name
//        // self.profilePic = profilePic
//        self.isOnline = isOnline
//        self.colistenUsername = colistenUsername
//        self.colistenID = cID
//        // setting canonical name or spotify username
//         //SpotifyLibrary.defaultInstance.friendView?.userLib.friends.filter("canonical == %@", name).count == 0 && SpotifyLibrary.defaultInstance.friendView?.userLib.friends.filter("email == %@", name).count == 0
//    }
//    
//    func changeUsername( newUser:String ) {
//        // check if valid username format
//        // check if valid
//        self.colistenUsername = newUser
//    }
//    
//    func changeProfPic( newPic:UIImage ) {
//        // replace old pic with new one
//        self.profilePic = newPic
//    }
//    
//    func getFriendList() -> Array {
//        // return an array containing friends
//        return friendList
//    }
//    
//    // probably add IBOutlets for these from a contacts list
//    func addNewFriend( newFriend:Friend ) {
//        friendList.append(newFriend)
//    }
//    
//    func removeFriend( oldFriend:Friend ) {
//        friendList.remove(oldFriend)
//    }
//    
//    func hasContacts() -> boolean {
//        if ( !hasContacts ) {
//            // open pop-up bar to ask permission
//            // set hasContacts to true
//            hasContacts = true
//        }
//        
//        return hasContacts;
//    }
//    
//  }
//
