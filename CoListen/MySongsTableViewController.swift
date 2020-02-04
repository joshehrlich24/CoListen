//
//  MySongsTableViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/14/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit



class MySongsTableViewController: UITableViewController {
    
    let songIdentifier = "SongID"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .blue
        print("In mySongs TableViewController")

       tableView.register(mySongCell.self, forCellReuseIdentifier: songIdentifier)
        
        
        //If you have a valid access token/session load your music
        if SpotifyService.shared.session?.isValid() == true
        {
            print("Valid session")
            
           
            SpotifyService.shared.loadSavedSongs
            {
                print("reload data")
                
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
        }
            
        
//            SpotifyService.shared.loadYourMusic(cb:{()->Void in
//                self.tableView.reloadData() // When loadYourMusic is finished on success it should run this line
//                print("Just reloaded data in LoadYourMusic callback")
//            })
//
//        }
//        else
//        {
//            print("NOT VALID")
//        }
    
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //self.tableView.reloadData()
        return SpotifyService.shared.mySavedSongs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: songIdentifier, for: indexPath)

        if let mySongsCell = cell as? mySongCell
        {
            mySongsCell.songNameLabel.text = SpotifyService.shared.mySavedSongs[indexPath.row].name

        }

        return cell
    }
    
    //Probably need to pass the song URL
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SpotifyService.shared.selectedSong = SpotifyService.shared.mySavedSongs[indexPath.row].name
        SpotifyService.shared.selectedTrack = SpotifyService.shared.mySavedSongs[indexPath.row]
        performSegue(withIdentifier: "PlayingMusicController2", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let queue = queueAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [queue])
    }
    
    func queueAction(at indexPath: IndexPath) -> UIContextualAction
    {
        //let todo = indexPath.row
        let action = UIContextualAction(style: .normal, title: "Queue Song") { (action, view, completion) in
            SpotifyService.shared.player?.queueSpotifyURI(SpotifyService.shared.mySavedSongs[indexPath.row].uri, callback: { (error) in
                if error != nil
                {
                    print("error grabbing queued song uri")
                }
                
                else
                {
                    print("Song Queued")
                }
            })
            completion(true)
        }
        
        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PlayingMusicController
        {
            
        }
    }

}

class mySongCell : UITableViewCell
{
   
    
    
    let songNameLabel: UILabel = {
        let label = UILabel()
        label.text = "SongCell"
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCells()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupCells()
    {
        self.addSubview(songNameLabel)
        
        //Setup Anchors
        
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        songNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        songNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        songNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        songNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
