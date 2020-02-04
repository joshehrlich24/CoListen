
//
//  Playlist.swift
//  CoListen
//
//  Created by Josh Ehrlich on 2/14/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]


struct playlist {
    let data: Data?
    var name : String?
    var songs : [Song] = []
    var playlistArt : UIImageView?
}

extension playlist
{
    
//    init?(json : JSON)
//    {
//        guard let newName = json["name"] as? String // changed from id
//          else
//          {
//            return nil
//          }
//        name = newName
//        //self.songs = json["songs"] as? [String]
//        //self.name = json["name"] as? String
//        
//        // Transform raw JSON data to parsed JSON object using JSONSerializer (part of standard library)
//        //let userObject = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON
//        
//        // Create an instance of `User` structure from parsed JSON object
//       // let user = userObject.flatMap(playlist.init)
//    }
}
class Song {
    
     var title = ""
     var artist = ""
     var uri = ""
    
}

