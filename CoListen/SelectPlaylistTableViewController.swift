//
//  SelectPlaylistTableViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 3/21/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit

class SelectPlaylistTableViewController: UITableViewController
{
    
    var tempLabel : UILabel?

   let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.view.backgroundColor = .purple
        
        tableView.register(playlistSongCell.self, forCellReuseIdentifier: cellID)
        
        if let current = SpotifyService.shared.currentPlaylist {
        SpotifyService.shared.loadSongsForPlaylist(uri: current.uri, cb:{()->Void in
            print("reload data")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print("Number of songs \(SpotifyService.shared.playlistSongDictionary.count)")
        
        return SpotifyService.shared.playlistSongDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = SpotifyService.shared.playlistSongDictionary[indexPath.row].name
        print("cell label \(String(describing: cell.textLabel?.text))")
        //tempLabel?.text = cell.textLabel?.text
        return cell
    }
    
    //When a row is selected, we transition to the nowPlayingController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SpotifyService.shared.selectedTrack = SpotifyService.shared.playlistSongDictionary[indexPath.row]
        performSegue(withIdentifier: "PlayingMusicController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
        if let DestVC = segue.destination as? PlayingMusicController
        {
           //DestVC.imageView =
             DestVC.songName.text = SpotifyService.shared.selectedTrack?.name
           // print("Song Name \(DestVC.songName.text)")
        }

    }
}

class playlistSongCell: UITableViewCell
{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCells()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCells()
    {
        
    }
    
    
}
