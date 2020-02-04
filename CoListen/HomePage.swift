//
//  HomePage.swift
//  CoListen
//
//  Created by Josh Ehrlich on 1/26/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit
import SafariServices

class HomePage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //UI Elements:
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var homeTableView: UITableView!
    
    
    //Other Attributes
    var data = ["My Playlists", "My Songs", "Something Else"]
    let homeCell = "homeCell"
    var session : SPTSession?
    var user : SPTUser?
    
     let interactor = Interactor()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        //register Cell
        homeTableView.register(HomeTableCell.self, forCellReuseIdentifier: "homeCell")
        
        setupHomeTableView()
        chooseProfilePicture()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? PlayingMusicController {
            destinationViewController.transitioningDelegate = self
            //destinationViewController.interactor = interactor
        }
    }

//    func setupAuth()
//    {
//        print("Auth --> lol")
//    }
    
    func chooseProfilePicture()
    {
        if (UserDefaults.standard.object(forKey: "savedImage") as? NSData) != nil
        {
            setupProfilePicture()
        }
        else
        {
            setupDefaultProfilePicture()
        }
        
        ProfilePic.isUserInteractionEnabled = true
        ProfilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePictureTapped)))
        
        
    }
    
    func setupDefaultProfilePicture()
    {

        ProfilePic.image = UIImage(named: "Dude")
        ProfilePic.layer.borderWidth = 1
        ProfilePic.layer.masksToBounds = false
        ProfilePic.layer.borderColor = UIColor.black.cgColor
        ProfilePic.layer.cornerRadius = ProfilePic.frame.height/2
        ProfilePic.clipsToBounds = true
        ProfilePic.contentMode = .scaleAspectFill
    }
    
    func setupProfilePicture()
    {
        let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
        ProfilePic.image = UIImage(data: data as Data)
        ProfilePic.layer.borderWidth = 1
        ProfilePic.layer.masksToBounds = false
        ProfilePic.layer.borderColor = UIColor.black.cgColor
        ProfilePic.layer.cornerRadius = ProfilePic.frame.height/2
        ProfilePic.clipsToBounds = true
        ProfilePic.contentMode = .scaleToFill //.scaleAspectFill
    }
    
    @objc func profilePictureTapped()
    {
        print("Profile Picture Tapped")
        
        let imagePickerController = UIImagePickerController()

        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action : UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else
            {
                print("No camera detected")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action : UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        ProfilePic.image = image
       
        let imageData : NSData = ProfilePic.image!.pngData()! as NSData
        
        //Save image
        UserDefaults.standard.set(imageData, forKey: "savedImage")
        
        setupProfilePicture()
        
        picker.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension HomePage : UITableViewDelegate, UITableViewDataSource
{
    
    func  setupHomeTableView()
    {
        //Set Delegate and dataSource
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        //Set Color
        homeTableView.backgroundColor = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Now Playing", style: .plain, target: self, action: #selector(NowPlayingTapped))
        
    }
    
    @objc func NowPlayingTapped()
    {
        print("Now Playing")
        SpotifyService.shared.loadLastPlayedSong()
       // self.performSegue(withIdentifier: "PlayingMusicController3", sender: self)
       let vc = PlayingMusicController()
        vc.nowPlaying = true
        
       self.present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //Here you will get a reference to the tableView requesting this information, and the indexPath it is looking for it on.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: homeCell, for: indexPath) as! HomeTableCell
        let row = indexPath.row
        
        //Customize Cell --> IS this where I should do it (Probably not)
        myCell.textLabel?.text = data[row]
        myCell.backgroundColor = .black
        myCell.textLabel?.textColor = .lightGray
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch(indexPath.item)
        {
            
        case 0:
            print("My Playlist")
            
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let destinationVC = Storyboard.instantiateViewController(withIdentifier: "myPlaylistCollectionViewController") as? MyPlaylistCollectionViewController
            {
                destinationVC.session = self.session
                destinationVC.user = self.user
                navigationController?.pushViewController(destinationVC, animated: true)
            }
            
            break
            
        case 1:
            print("My Songs")
            
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let destinationVC = Storyboard.instantiateViewController(withIdentifier: "mySongsTableViewController") as? MySongsTableViewController
            {
                navigationController?.pushViewController(destinationVC, animated: true)
            }
            
            break
            
        case 2:
            print("Something")
            break
            
        default:
            break
        }
        
    }
    
    
}

extension HomePage: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

class HomeTableCell : UITableViewCell
{
    
}
