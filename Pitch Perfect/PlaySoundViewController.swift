//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Brett Giles on 2016-01-01.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var receivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        self.playSomeAudio(0.5, pitchChange: nil)
    }
    @IBAction func playSoundFast(sender: UIButton) {
        self.playSomeAudio(2.0, pitchChange: nil)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        self.playSomeAudio(nil, pitchChange: 1000)
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        self.playSomeAudio(nil, pitchChange: -500)
    }
    
    func playSomeAudio(rateChange: Float?, pitchChange: Float?) {
        let audioPlayerNode = startAudioSession()
        
        let timePitch = AVAudioUnitTimePitch()
        
        if let newPitch = pitchChange {
            timePitch.pitch = newPitch
        }
        
        if let newRate = rateChange {
            timePitch.rate = newRate
        }
        
        configureAudioEngine(audioPlayerNode, effect: timePitch)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        }
        catch {
            print("unable to play")
        }
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func startAudioSession() -> AVAudioPlayerNode {
        let audioSession = AVAudioSession.sharedInstance()
        
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try! audioSession.setActive(true)
        
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        return audioPlayerNode
    }
    
    func configureAudioEngine(playerNode: AVAudioPlayerNode, effect: AVAudioUnitTimePitch) {
        audioEngine.attachNode(playerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(playerNode, to: effect, format: audioFile.processingFormat)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: audioFile.processingFormat)
    }
}
