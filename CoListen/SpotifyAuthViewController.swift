//
//  SpotifyAuthViewController.swift
//  CoListen
//
//  Created by Michael Stewart on 2/26/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit

import SafariServices

class SpotifyAuthViewController: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("DidFinish")
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
