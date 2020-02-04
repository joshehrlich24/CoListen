//
//  MyPlaylistCollectionViewController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/14/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit

private let reuseIdentifier = "playlistCell"

class MyPlaylistCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{

    var session: SPTSession?
    var user: SPTUser?
    var playlistName : String?
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView?.backgroundColor = .green
        
        // Register cell classes
        collectionView?.register(playListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //UI stuff
        let width = view.frame.size.width / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        if SpotifyService.shared.session?.isValid() == true
        {
            print("User --> \(String(describing: SpotifyService.shared.user?.displayName))")
            print("Session2 --> \(String(describing: SpotifyService.shared.session))")
            
            SpotifyService.shared.loadPlaylists(cb:{()->Void in
                self.collectionView.reloadData()
            })
        }

    }
    

    
    
    // Collection View Cell Code Starts Here:
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .black
        
        if let playlistCell = cell as? playListCell
        {
            playlistCell.playlistNameLabel.text = SpotifyService.shared.playlistArray[indexPath.row].name

        }
        
        return cell
    }
   
    override func numberOfSections(in collectionView: UICollectionView) -> Int { // this is probably not correct
      
        return 1
       
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return SpotifyService.shared.playlistArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: (view.frame.height / 8))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.playlistName = SpotifyService.shared.playlistArray[indexPath.row].name
        print("Selected : \(SpotifyService.shared.playlistArray[indexPath.row].name)")
        

        SpotifyService.shared.currentPlaylist = SpotifyService.shared.playlistArray[indexPath.row]
  
        self.performSegue(withIdentifier: "SelectPaylistTableViewController", sender: self)
        
        
        
        
       
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let playlistVC = segue.destination as? SelectPlaylistTableViewController
        else
        {
            return
        }
        if(segue.identifier == "SelectPaylistTableViewController")
        {
            playlistVC.title = self.playlistName
        }
    }

}
class playListCell : UICollectionViewCell
{
    
    
    
    let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "playlistCell"
        label.textColor = .white
        return label
    }()
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupCells()
        
    }
    
    func setupCells()
    {
        addSubview(playlistNameLabel)
        
        //Setup Anchors
        
        playlistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playlistNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        playlistNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        playlistNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        playlistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setplaylistLabelName(name:String)
    {
        playlistNameLabel.text = name
    }
    
 
    
}
