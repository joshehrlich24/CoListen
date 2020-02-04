//
//  BrowseViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/6/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit

class PersonButtonViewController: UIViewController {

    let cellID = "onlineCell"
    
    @IBOutlet weak var onlineFriendsCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

class onlineFriendsCollectionView: UICollectionView, UICollectionViewDelegate {
    
}
