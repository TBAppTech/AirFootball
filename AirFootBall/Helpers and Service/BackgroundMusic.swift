import AVFoundation

/**
 * Audio player that uses AVFoundation to play looping background music and
 * short sound effects. For when using SKActions just isn't good enough.
 */
public class SKTAudio {
  public var backgroundMusicPlayer: AVAudioPlayer?
    
  public class func sharedInstance() -> SKTAudio {
    return SKTAudioInstance
  }

  public func playBackgroundMusic(_ filename: String) {
    let url = Bundle.main.url(forResource: filename, withExtension: nil)
    if (url == nil) {
      print("Could not find file: \(filename)")
      return
    }

    var error: NSError? = nil
    do {
      backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
    } catch let error1 as NSError {
      error = error1
      backgroundMusicPlayer = nil
    }
    if let player = backgroundMusicPlayer
    {
        player.volume = 0.06
        player.numberOfLoops = -1
        
        player.prepareToPlay()
        player.play()
    } else {
        print("Could not create audio player: \(error!)")
    }
  }
    
    public func playBackgroundMusic2(_ filename: String) {
      let url = Bundle.main.url(forResource: filename, withExtension: nil)
      if (url == nil) {
        print("Could not find file: \(filename)")
        return
      }

      var error: NSError? = nil
      do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
      } catch let error1 as NSError {
        error = error1
        backgroundMusicPlayer = nil
      }
      if let player = backgroundMusicPlayer
      {
          player.volume = 0.10
          player.numberOfLoops = -1
          
          player.prepareToPlay()
          player.play()
      } else {
          print("Could not create audio player: \(error!)")
      }
    }
    
    public func playBackgroundMusicFadeIn(_ filename: String) {
      let url = Bundle.main.url(forResource: filename, withExtension: nil)
      if (url == nil) {
        print("Could not find file: \(filename)")
        return
      }

      var error: NSError? = nil
      do {
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
      } catch let error1 as NSError {
        error = error1
        backgroundMusicPlayer = nil
      }
      if let player = backgroundMusicPlayer
      {
          player.volume = 0.03
          player.numberOfLoops = -1
          
          player.prepareToPlay()
          player.volume = 0.0
          player.play()
        player.setVolume(0.03, fadeDuration: 2.0)

      } else {
          print("Could not create audio player: \(error!)")
      }
    }

  public func pauseBackgroundMusic() {
    if let player = backgroundMusicPlayer {
      if player.isPlaying {
        player.setVolume(0.0, fadeDuration: 0.5)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            player.pause()
        })
      }
    }
  }

  public func resumeBackgroundMusic() {
    if let player = backgroundMusicPlayer {
      if !player.isPlaying {
        player.play()
        player.setVolume(0.03, fadeDuration: 1.0)
      }
    }
  }
}

private let SKTAudioInstance = SKTAudio()

