//
//  PlayingMusicController.swift
//  CoListen
//
//  Created by Josh Ehrlich on 6/25/19.
//  Copyright © 2019 Josh Ehrlich. All rights reserved.
//

import UIKit

class PlayingMusicController : UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate
{
    var initialTouchPoint = CGPoint()
    
    
    //Stuff for User Defualt
    let defaults = UserDefaults.standard
    var UDtrackURL : String?
    var UDtrackName : String?
    var UDtrackArtist : String?
    var nowPlaying: Bool = false
    

    struct Keys
    {
        static let lastPlayedTrackURL = "lastPlayedTrackURL"
        static let lastPlayedTrackName = "lastPlayedTrackName"
        static let lastPlayedTrackArtistName = "lastPlayedTrackArtistName"
        //static let lastPlayedTrackURL = "lastPlayedTrackURL"
        
    }
    
    //End User Defualts
    
    //Closures
    
    let imageView : UIImageView =
    {
        let image = UIImageView()
        image.image = UIImage(named: "Dude")
        
        if let imageUrl = URL(string: SpotifyService.shared.selectedTrack?.imageUrl ?? "")
        {
            if let data = NSData(contentsOf: imageUrl)
            {
                image.image = UIImage(data: data as Data)
            }
        }
        
    
        
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let songName : UILabel =
    {
        let label = UILabel()
        label.text = SpotifyService.shared.selectedSong
        label.textColor = UIColor(displayP3Red: 55, green: 55, blue: 255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let songSlider : UISlider =
    {
        let slider = UISlider()
        
        slider.minimumValue = 0
        slider.maximumValue = Float(SpotifyService.shared.selectedTrack?.duration ?? -1.00)
        slider.isContinuous = false
        slider.tintColor = .black
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for:.valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let artistName : UILabel =
    {
        let label = UILabel()
        label.text = SpotifyService.shared.selectedTrack?.artistName
        label.textColor = UIColor(displayP3Red: 55, green: 55, blue: 255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let songBar : UIView =
    {
       let view = UIView()
        //view.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height/3)
       view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 205, alpha: 0.95)
       view.translatesAutoresizingMaskIntoConstraints = false
    
       return view
    }()
    
    let playButton : UIButton =
    {
        let button = UIButton()
        //button.setTitle("Play", for: .normal)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.addTarget(self, action: #selector(playPausePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //Icon by https://www.flaticon.com/authors/google"
    //licensed by http://creativecommons.org/licenses/by/3.0/"               
    let fowardButton : UIButton =
    {
        let button = UIButton()
       // button.setTitle("Skip", for: .normal)
         button.setImage(UIImage(named: "next"), for: .normal)
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton : UIButton =
    {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timePassed : UILabel =
    {
        let label = UILabel()
        label.text = "0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeRemaining : UILabel =
    {
        let label = UILabel()
        label.text = "\(SpotifyService.shared.selectedTrack?.duration.minuteSecondMS ?? "-1.00")"
       
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //End Closures
    
    
    override func viewDidLoad()
    {
        view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 1.0)
        print("In the playing music controller")
        SpotifyService.shared.player?.delegate = self
        SpotifyService.shared.player?.playbackDelegate = self
        setupViews()
        setupSwipeRecognizer()
        playMusicUsingSession(session: SpotifyService.shared.session!)
    }
    
    func setupSwipeRecognizer()
    {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        view.isUserInteractionEnabled = false // Does nothing
        
        if(nowPlaying == true)
        {
            view.isUserInteractionEnabled = true
            showHelperCircle()
        }
       
    }
    
    func setupViews()
    {
        view.addSubview(imageView)
        view.addSubview(songName)
        view.addSubview(artistName)
        view.addSubview(songBar)
        view.addSubview(songSlider)
        
        
        //Adding More to the SongBar View
        songBar.addSubview(playButton)
        songBar.addSubview(backButton)
        songBar.addSubview(fowardButton)
        songBar.addSubview(songSlider)
        songBar.addSubview(timePassed)
        songBar.addSubview(timeRemaining)
        
       // Play/Pause button
        playButton.centerXAnchor.constraint(equalTo: songBar.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: songBar.centerYAnchor).isActive = true
        playButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 14).isActive = true
        playButton.trailingAnchor.constraint(equalTo: fowardButton.leadingAnchor, constant: -14).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //Back Button
        backButton.centerYAnchor.constraint(equalTo: songBar.centerYAnchor).isActive = true
//        backButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -14).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        //Skip Button
        fowardButton.centerYAnchor.constraint(equalTo: songBar.centerYAnchor).isActive = true
        fowardButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 14).isActive = true
        fowardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fowardButton.widthAnchor.constraint(equalToConstant: 50).isActive = true



        //Image View
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/8).isActive = true

        // SongLabel
        songName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50).isActive = true
        songName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        songName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        songName.bottomAnchor.constraint(equalTo: artistName.bottomAnchor)

        //artistName
        artistName.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 14).isActive = true
        artistName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        artistName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true

        //Song Bar
        songBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        songBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        songBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        songBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6).isActive = true
        
        
        //Song Slider
        songSlider.leadingAnchor.constraint(equalTo: songBar.leadingAnchor, constant: 5).isActive = true
        songSlider.trailingAnchor.constraint(equalTo: songBar.trailingAnchor, constant: -5).isActive = true
        songSlider.topAnchor.constraint(equalTo: songBar.topAnchor, constant: 5).isActive = true
        
        // Time remaining label
        //timeRemaining.leadingAnchor.constraint(equalTo: songSlider.trailingAnchor).isActive = true
        timeRemaining.topAnchor.constraint(equalTo: songSlider.bottomAnchor).isActive = true
        timeRemaining.trailingAnchor.constraint(equalTo: songBar.trailingAnchor).isActive = true
        timeRemaining.centerYAnchor.constraint(equalTo: timePassed.centerYAnchor).isActive = true
        
        //Time passed Label
        timePassed.leadingAnchor.constraint(equalTo: songSlider.leadingAnchor).isActive = true
        timePassed.topAnchor.constraint(equalTo: songSlider.bottomAnchor).isActive = true
       
    }
    
    func playMusicUsingSession(session : SPTSession!)
    {
        print("In music")
       
        if SpotifyService.shared.player == nil
        {
            SpotifyService.shared.player = SPTAudioStreamingController.sharedInstance()
            SpotifyService.shared.player?.delegate = self
            SpotifyService.shared.player?.playbackDelegate = self
            
            try! SpotifyService.shared.player?.start(withClientId: SpotifyService.shared.clientID)
            SpotifyService.shared.player?.diskCache = SPTDiskCache(capacity: 1024 * 1024 * 64) // found online
            
            SpotifyService.shared.player?.login(withAccessToken: SpotifyService.shared.session!.accessToken)
            
        }
        
        SpotifyService.shared.player?.playSpotifyURI(SpotifyService.shared.selectedTrack!.uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            
            SpotifyService.shared.player?.setIsPlaying(true, callback: { (error) in
            })
        })
   }
    
    
    
    
    
    
    
    
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController)
    {
        print("Did Login to Audio Streaming")
        
        SpotifyService.shared.player?.playSpotifyURI(SpotifyService.shared.selectedTrack!.uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            
            SpotifyService.shared.player?.setIsPlaying(true, callback: { (error) in
            })
        })
    }

    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didReceiveError error: Error) {
        print("Error with audio Streaming")
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didStartPlayingTrack trackUri: String) {
        //print("Hello")
        
        saveLastPlayedSong()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePosition position: TimeInterval)
    {
        songSlider.setValue(Float((position.minute * 60) + position.second), animated: true)
//        timeRemaining.text = String(format: "%d:%02d", (SpotifyService.shared.selectedTrack?.duration.minute ?? -1) - Int(position.minute), Int(60 - Int(position.second)))
        timeRemaining.text = stringFromTimeInterval(interval: SpotifyService.shared.selectedTrack?.duration ?? 0.0)
        timePassed.text = String(format:"%d:%02d", position.minute, position.second)
    }
    
    
    @objc func playPausePressed()
    {
        if SpotifyService.shared.player?.playbackState.isPlaying ?? false
        {
            SpotifyService.shared.player?.setIsPlaying(false, callback: { (error) in
                print("Stopped")
            })
        }
        else
        {
            SpotifyService.shared.player?.setIsPlaying(true, callback: { (error) in
                print("Continued")
            })
        }
      
    }
    
    @objc func skipButtonPressed()
    {
         print("Skip")
        SpotifyService.shared.player?.skipNext({ (error) in
          
            print("Error getting next song in queue \(error?.localizedDescription ?? "")")
        })
    }
    
    @objc func backButtonPressed()
    {
         print("Back")
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) // When a user drags the UISlider
    {
        print("Did the value Change?")
        songSlider.value = sender.value // Change the position of the slider on the User interface
        
        SpotifyService.shared.player?.seek(to: TimeInterval(songSlider.value), callback: { (error) in
            if(error != nil)
            {
                print("We messed up")
            }
        })
    }
    
    func saveLastPlayedSong()
    {
        defaults.set(UDtrackURL, forKey: Keys.lastPlayedTrackURL)
        defaults.set(UDtrackName, forKey: Keys.lastPlayedTrackName)
        defaults.set(UDtrackArtist, forKey: Keys.lastPlayedTrackArtistName)
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
       // let ms = Int((interval % 1) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        //let hours = (ti / 3600)
        
        return String(format: "%d:%0.2d",minutes,seconds)
    }
    
//    func loadLastPlayedSong()
//    {
////        let trackUri = defaults.url(forKey: Keys.lastPlayedTrackURL)
////        let trackName = defaults.string(forKey: Keys.lastPlayedTrackName)
////        let artistName = defaults.string(forKey: Keys.lastPlayedTrackArtistName)
//        
//        SpotifyService.shared.selectedTrack?.uri = defaults.string(forKey: Keys.lastPlayedTrackURL) ?? ""
//        SpotifyService.shared.selectedTrack?.name = defaults.string(forKey: Keys.lastPlayedTrackName) ?? ""
//        SpotifyService.shared.selectedTrack?.artistName = defaults.string(forKey: Keys.lastPlayedTrackArtistName) ?? ""
//        
//    }
    
    @objc func handlePan(_ recognizer:UIPanGestureRecognizer)
    {
        //print("Hello")
        let touchPoint = recognizer.location(in: self.view?.window)
        
        switch(recognizer.state)
        {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if (touchPoint.y - initialTouchPoint.y > 0) {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        case .ended:
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        @unknown default:
            print("Error?")
        }
    }
    
    
    func showHelperCircle(){
        let center = CGPoint(x: view.bounds.width * 0.5, y: 100)
        let small = CGSize(width: 30, height: 30)
        let circle = UIView(frame: CGRect(origin: center, size: small))
        circle.layer.cornerRadius = circle.frame.width/2
        circle.backgroundColor = UIColor.white
        circle.layer.shadowOpacity = 0.8
        circle.layer.shadowOffset = CGSize()
        view.addSubview(circle)
        UIView.animate(
            withDuration: 1.5,
            delay: 0.25,
            options: [],
            animations: {
                circle.frame.origin.y += 200
                circle.layer.opacity = 0
        },
            completion: { _ in
                circle.removeFromSuperview()
        }
        )
    }
    
    
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d", minute, second)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}
