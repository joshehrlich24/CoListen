//
//  ViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 1/26/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit
import SafariServices
import Security


class HomeController: UITabBarController {


    //var appDelegate:AppDelegate?
    var session : SPTSession?
    var user : SPTUser?
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SpotifyService.shared.printHello()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        SpotifyService.shared.getUserData(vc:self,callback:{(user, getUserError) in
            print("user(In HomeController) \(user)")
        })
    }
    
}

