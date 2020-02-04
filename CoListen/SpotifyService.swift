//
//  SpotifyService.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/19/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import Foundation

import SafariServices
import UIKit

//APPError enum which shows all possible errors
enum APPError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
}

//Result enum to show success or failure
enum Result {
    case success()
    case failure(APPError)
}

struct Keys
{
    static let lastPlayedTrackURL = "lastPlayedTrackURL"
    static let lastPlayedTrackName = "lastPlayedTrackName"
    static let lastPlayedTrackArtistName = "lastPlayedTrackArtistName"
    //static let lastPlayedTrackURL = "lastPlayedTrackURL"
    
}

struct Track : Codable
{
    var href : String
    var id : String
    var track_number : Int
    var name : String
    var type : String
    var uri : String
    var is_local : Bool
    var artistName: String
    var duration : TimeInterval
    var imageUrl : String
    
}

struct TrackResult : Codable
{
    var items: [Track]
}


struct Album : Codable
{
    var name : String
    var total_tracks: Int
    var type : String
    var uri : String
    
}

struct Artist
{
    var href : String
    var id : String
    var name : String
    var uri : String
}

struct SavedSong
{
    var songName : String
    var artistName : String
    var ID : Int
    
    init (json: [String : Any])
    {
        ID = json["id"] as? Int ?? -1
        songName = json["name"] as? String ?? ""
        artistName = json["name"] as? String ?? ""
    }
}

//dataRequest which sends request to given URL and convert to Decodable Object

//http://localhost:1234/swap
// https://sheltered-bayou-37875.herokuapp.com:1234/swap
final class SpotifyService {
    
    // Authentication variables:
    var sfController : SFSafariViewController?
    let clientID: String = "303f6d8630224d01aa9d0504ce5b769d"
    let callbackURL = "spotifyiossdkexample://" // eventually should be changed to Colisten and then also on the spotify dashboard
    let tokenSwapURL = "https://colisten-token-swap.herokuapp.com/api/token"
    var session : SPTSession?
    var playlists: SPTPlaylistList?
    var playlistPage : SPTListPage?
    var user : SPTUser?
    var authDelegate: SFSafariViewControllerDelegate?
    var playlistArray : [SPTPartialPlaylist] = []
    var playlistSongDictionary : [Track] = []
    var currentPlaylist : SPTPartialPlaylist?
    //var currentSong : SPTListPage?
    var selectedSong : String?
    var selectedTrack : Track?
    var mySavedSongs : [Track] = []
    var player : SPTAudioStreamingController?
    
   static let shared = SpotifyService()
    
    private init() {
       
        self.authDelegate = SpotifyAuthViewController()
    }
    
    func printHello()
    {
        print("Hello")
    }
    
    private func isAuthed() -> Bool {
     return self.session != nil
    }
    
    func setupAuthentication(vc:UIViewController)
    {
        let auth : SPTAuth = SPTAuth.defaultInstance()
        auth.clientID = clientID
        
        //Informs the user of the features CoListen would like to have access to
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope,SPTAuthUserReadPrivateScope, SPTAuthUserReadEmailScope ,SPTAuthUserReadEmailScope, "playlist-read-collaborative", "playlist-read-private", "user-top-read", "user-read-recently-played", "user-library-read"];
        // Added playlist-read-private --> could be wrong
        
        auth.redirectURL = URL(string: callbackURL) // Is this wrong?
       
        if let theActualRedirectUrl = auth.redirectURL {
            print("Redirect URL -->> \(theActualRedirectUrl)")
        }
        
        auth.tokenSwapURL = URL(string: tokenSwapURL)
        
        
        if let url = URL(string: "\(auth.spotifyWebAuthenticationURL())") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            //print("Printing URL: \(url) \n End URL")
            
            self.sfController = SFSafariViewController(url: url) // ????
            
            if let authView = self.sfController // present the authentication view controller
            {
                authView.delegate = self.authDelegate
                authView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                authView.definesPresentationContext = true
                vc.present(authView, animated: true, completion: nil)
            }
        }
    }
    // I dont think we enter this function ever
    func getUserData(vc:UIViewController, callback:(User, NSError)->()) { //why does this take a view controller??
        print("Is authed --> \(isAuthed())")
        if (isAuthed()) {
        
            if let actualSession = self.session{ // Dont think we get here
                print("IN session do we have user?")
               
                SPTUser.requestCurrentUser(withAccessToken: actualSession.accessToken, callback: { (someError, currentUser) in
                    if let actualCurrentUser = currentUser as? SPTUser {
                        print(actualCurrentUser.emailAddress!) // forced unwrapped
                        
                    }
                })
            }
        }
        else
        {
            setupAuthentication(vc:vc)
        }
    }
    //Called when the User logs in and has a valid session
    func authenticationViewController(_ authenticationViewController: SFSafariViewController, didLoginWith session: SPTSession) {
        
        //When the STPSession is working save it into a var
        
        self.session = session
        
    }
    
    func authenticationViewController(_ authenticationViewController: SFSafariViewController, didFailToLogin error: Error) {
        print("didFailToLogin")
    }
    
    func authenticationViewControllerDidCancelLogin(_ authenticationViewController: SFSafariViewController) {
        print("authenticationViewControllerDidCancelLogin")
    }
    
    
/**
 This function I believe gets called when the user accepts the scope stuff for the app
     therefore accepting the spotify terms thus starting the User session
 **/
    func openURLCallback(url:URL)->Bool {
        
        //let userDefaults = UserDefaults.standard // Use this to save logins
        //UserDefaults.bool("isAuthed") //
        
        if (SPTAuth.defaultInstance().canHandle(url)) {
            SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) -> Void in
                if let actualError = error
                {
                    NSLog("*** Auth error: \(actualError)")
                    return
                }
                
                if let actualSession = session
                {
                    self.session = actualSession
                    print("GOT A SESSION!!!!!!! \(actualSession as SPTSession)")
                   
                    SPTUser.requestCurrentUser(withAccessToken: actualSession.accessToken, callback: { (someError, currentUser) in
                        if let actualCurrentUser = currentUser as? SPTUser {
                             self.user = actualCurrentUser
                            print(actualCurrentUser.emailAddress!) // forced unwrapped
                            
                           
                        }
                    })
                    
                   
                  self.sfController?.dismiss(animated: true, completion: nil)
                    
                }
            })
            
            return true
        }
        
        return false
    }
    
    
    //In old code updatePlaylists(lists:SPTListPage) has the names of the playlists.
    // 1) How did you get the name
    // 2) The playlist variable is declared in PlaylistTableViewController, how is it accessed in the singleton class
    
    
    func loadPlaylists(cb:@escaping ()->Void)
    {

        // playlists contains a SPTPlaylistList object. This call sets handlePagedListing as the callback which is how it is called.
        SPTPlaylistList.playlists(forUser: ((user?.displayName)!), withAccessToken: (SpotifyService.shared.session?.accessToken)!,callback: handlePagedListing(cb:cb))
 
    }
    
    func loadYourMusic(cb:@escaping ()->Void)
    {
        print("Loading your music")
        // Get the tracks for the user and handle it in mySongsListing
        SPTYourMusic.savedTracksForUser(withAccessToken:(SpotifyService.shared.session?.accessToken)!, callback: handleMySongsListing(cb:cb))
       
    }
    
    private func handleMySongsListing (cb:@escaping ()->Void) -> (Optional<Error>, Optional<Any>) -> Void
    {
        return { (error, songs) -> Void in
            print("Getting my songs")
            
            if (error != nil)
            {
                NSLog("error loading mySongs, \(String(describing: error))")
            }
            else
            {
                    if let mySongsList = songs as? SPTListPage // I dont think its a playlist list
                    {
                        print("mySongsList length is : \(mySongsList.totalListLength)")
                       
                        print("Songs: \(mySongsList.items.count)")
                        for song in mySongsList.items
                        {
                           // print("Do we get here")
                            if let mySong = song as? SPTPartialTrack
                            {
                                 print(mySong.name)
                            }
                        }
                        if mySongsList.hasNextPage
                        {
                            print("Still more pages")
                            
                            mySongsList.requestNextPage(withAccessToken: self.session?.accessToken, callback: self.handleMySongsListing(cb: cb))
                        }
                        else
                        {
                            print("All Songs have been fetched")
                            cb()
                            //SpotifyService.shared.loadSavedSongs(cb: cb)
                        }
                    }
            }
        }
    }
    

    private func handlePagedListing(cb:@escaping ()->Void) -> (Optional<Error>, Optional<Any>) -> Void
    {
        return { (error, playlists) -> Void in
            print("At the top of the function")
            
            if (error != nil)
            {
                NSLog("error loading library, \(String(describing: error))")
            }
            else
            {
                if let playListList = playlists as? SPTPlaylistList
                {
                    for playlist in playListList.items
                    {
                        if let partialPlaylist = playlist as? SPTPartialPlaylist
                        {
                            self.playlistArray.append(partialPlaylist)
                            print("Printing all playlist names: \(partialPlaylist.name)")
                        }
                        
                    }
                    print("After first loop")
                    
                  
                    if (playListList.hasNextPage)
                    {
                        print("Still more pages")
                        
                        // Page contains a SPTListPage object --> is this a child of SPTPlaylistList(NO)
                        // This class represents a page within a paginated list. How do I specify it is a playlist list?
                        (playlists as! SPTListPage).requestNextPage(withAccessToken: self.session?.accessToken, callback: self.handlePagedListing(cb: cb))
                        
                       
                        print("There are \(self.playlistArray.count) playlists in the playlist array right now")
                    }
                    else
                    {
                        print("All playlists have been fetched")
                        cb()
                    }
                }
                else
                {
                    if let listpage = playlists as? SPTListPage {
                        for playlist in listpage.items
                        {
                            self.playlistArray.append(playlist as! SPTPartialPlaylist)
                           
                        }
                        
                        if (listpage.hasNextPage)
                        {
                            print("Still more pages")
                            
                            (playlists as! SPTListPage).requestNextPage(withAccessToken: self.session?.accessToken, callback: self.handlePagedListing(cb: cb))
                            
                            //THIS DUPLICATE SONGS EVERY TIME YOU GO BACK FOWARD ON THE APP
                            print("There are \(self.playlistArray.count) playlists in the playlist array right now")
                        }
                        else
                        {
                            print("All playlists have been fetched")
                            cb()
                           
                        }
                    }
                    
                    print("There are \(self.playlistArray.count) playlists in the playlist array right now")
                }
            }
        }
    }
    
    
    func loadSongsForPlaylist(uri: URL, cb:@escaping ()->Void)
    {
        playlistDataRequest(with: "https://api.spotify.com/v1/playlists/\(uriToId(uri:uri.absoluteString))/tracks") { (result: Result) in
            switch result {
            case .success(let object):
                print(object)
                cb()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadSavedSongs(cb:@escaping ()->Void) // does this need the URI(What does me do in this URL)
    {
        //https://api.spotify.com/v1/me/tracks
        mySongsDataRequest(with: "https://api.spotify.com/v1/me/tracks") { (result: Result) in
            
            switch result // We never get here???
            {
            case .success(let object):
                print(object)
                cb()
                print("Saved Songs Count:\(self.mySavedSongs.count)") // Not the correct number of songs
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //spotify:track:6FHUBs8P5qcjpj7C2QHdEq => 6FHUBs8P5qcjpj7C2QHdEq
   
    private func uriToId(uri:String) -> String
    {
        let uriComponents = uri.components(separatedBy: ":")
        return uriComponents[uriComponents.count-1]
    }
    
    // with thanks to https://stackoverflow.com/a/41082782/1449799
    
    
    func playlistDataRequest(with url: String, completion: @escaping (Result) -> Void) {
        
        //create the url with NSURL
        
        var artistName = ""
        var coverImage : String?
        let dataURL = URL(string: url)! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.setValue("Bearer \(self.session!.accessToken)", forHTTPHeaderField: "Authorization")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(Result.failure(APPError.networkError(error!)))
                return
            }
            
            
            do {
                
//                let tracks = try? JSONDecoder().decode(TrackResult.self, from: data!)
//                print(tracks)

                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                {
                    //print(json)
                    //print("number of key-value pairs \(json.count)")

                   for (key, value) in json
                   {
                        if(key == "items") // If the key is the items array
                        {
                            if let songsDict : [[String : Any]] = value as? [[String : Any]]
                            {
                                print("Array of dictionaries") // The items array should be an array of dictionaries


                                //Loop over the array to get the individual dictionaries
                                
                                for (index, dict) in songsDict.enumerated()
                                {
                                    for(key, value) in dict // grab the key-value pairs from each individual dictionary
                                    {
                                        if(key == "track")
                                        {
                                            if let trackDict : [String : Any] = value as? [String : Any]
                                            {
                                                if let trackName = trackDict["name"] as? String, let trackUri = trackDict["uri"] as? String,
                                                    let trackHref = trackDict["href"] as? String, let duration = trackDict["duration_ms"] as? TimeInterval
                                                {
                                                    
                                                    if let albumType : [String : Any] = trackDict["album"] as? [String : Any]
                                                    {
                                                        for(key, value) in albumType
                                                        {
                                                            if key == "artists"
                                                            {
                                                                if let artist = value as? [[String : Any]]
                                                                {
                                                                    artistName = artist[0]["name"] as! String
                                                                    //print("\(artistName)")
                                                                }
                                                            }
                                                            
                                                            if key == "images"
                                                            {
                                                                if let artist = value as? [[String : Any]]
                                                                {
                                                                    if let imageURLString = artist[0]["url"] as? String
                                                                    {
                                                                        coverImage = imageURLString
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    self.playlistSongDictionary.append(Track(href: trackHref, id: "", track_number: index, name: trackName, type: "", uri: trackUri, is_local: false, artistName : artistName, duration: duration, imageUrl: coverImage ?? ""))
                                                }
                                            }
                                        }
                                       
                                    }
                                }
                                print("Tracks: \(self.playlistSongDictionary)")
                                //print("Values: \(self.playlistSongDictionary.values)")
                            }
                        }
                   }
                    completion(Result.success())
                }

            }
            catch let error
            {
                print("Caught exception")
                completion(Result.failure(APPError.jsonParsingError(error as! DecodingError)))
            }
        })
        
        task.resume()
    }
    
    //Model Object for a saved song
    /**
     href
     id
     name(of artist)
     name(of song)
    */
    func mySongsDataRequest(with url: String, completion: @escaping (Result) -> Void)
    {
        //create the url with NSURL
        let dataURL = URL(string: url)! //change the url
        var artistName = ""
        var coverImage : String?
        
        
        
        
        //create the session object
        let session = URLSession.shared
        print("In the mySongsDataRequest")
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.setValue("Bearer \(self.session!.accessToken)", forHTTPHeaderField: "Authorization")
        
        print("Spotify URL: \(dataURL)")
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler:{ data, response, error in
            
            guard error == nil else
            {
                completion(Result.failure(APPError.networkError(error!)))
                return
            }
            
            do
            {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                    else
                {
                    return
                }
                
                      //print(json)
//                    let savedSong = SavedSong(json: json)
//                    print(savedSong.songName)
                
                //print(json)
                
                for(key, value) in json
                {
                    if(key == "items")
                    {
                        if let mySongsDict : [[String : Any]] = value as? [[String : Any]] // if the value is another nested dictionary
                        {
                            //Loop over the array to get the individual dictionaries
                            for (index, dict) in mySongsDict.enumerated()
                            {
                                //print("Index(Outer Loop) \(index)")
                                for(key, value) in dict // grab the key-value pairs from each individual dictionary
                                {
                                    if(key == "track")
                                    {
                                       // print("value for track \(value)")
                                        
                                        if let trackDict : [String : Any] = value as? [String : Any]
                                        {
                                            if let trackName = trackDict["name"] as? String, let trackUri = trackDict["uri"] as? String,
                                                let trackHref = trackDict["href"] as? String, let duration = trackDict["duration_ms"] as? TimeInterval
                                            {
                                                
                                                if let albumType : [String : Any] = trackDict["album"] as? [String : Any]
                                                {
                                                    for(key, value) in albumType
                                                    {
                                                        if key == "artists"
                                                        {
                                                            if let artist = value as? [[String : Any]]
                                                            {
                                                                artistName = artist[0]["name"] as! String
                                                                //print("\(artistName)")
                                                            }
                                                          
                                                            
                                                            
                                                        }
                                                        
                                                        if key == "images"
                                                        {
                                                            if let artist = value as? [[String : Any]]
                                                            {
                                                                if let imageURLString = artist[0]["url"] as? String
                                                                {
                                                                    coverImage = imageURLString
//                                                                    if let imageUrl = URL(string: imageURLString)
//                                                                    {
//                                                                        if let data = NSData(contentsOf: imageUrl)
//                                                                        {
//                                                                            coverImage?.image = UIImage(data: data as Data)
//                                                                        }
//
//                                                                    }
                                                                }
                                                                
                                                            }
                                                        }
                                                    }
                                                   
                                                }
                                                
                                                self.mySavedSongs.append(Track(href: trackHref, id: "", track_number: index, name: trackName, type: "", uri: trackUri, is_local: false, artistName : artistName, duration: duration, imageUrl: coverImage ?? ""))
                                            }
                                        }
                                    }
                                }
                            }
                            print("mySavedSongs length \(self.mySavedSongs.count)")
                        }
                    }
                }
                 completion(Result.success())
            }
        catch let error
        {
            print("Caught exception")
            completion(Result.failure(APPError.jsonParsingError(error as! DecodingError)))
        }
        
        })
        task.resume() // End of task
    }
    
    func loadLastPlayedSong()
    {
        //        let trackUri = defaults.url(forKey: Keys.lastPlayedTrackURL)
        //        let trackName = defaults.string(forKey: Keys.lastPlayedTrackName)
        //        let artistName = defaults.string(forKey: Keys.lastPlayedTrackArtistName)
        
        SpotifyService.shared.selectedTrack?.uri = UserDefaults.standard.string(forKey: Keys.lastPlayedTrackURL) ?? ""
        SpotifyService.shared.selectedTrack?.name = UserDefaults.standard.string(forKey: Keys.lastPlayedTrackName) ?? ""
        SpotifyService.shared.selectedTrack?.artistName = UserDefaults.standard.string(forKey: Keys.lastPlayedTrackArtistName) ?? ""
        
    }
}


