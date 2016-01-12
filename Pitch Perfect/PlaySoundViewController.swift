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
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopAudioSession()
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Play sound actions
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        playTimePitchedAudio(0.5, pitchChange: nil)
    }
    @IBAction func playSoundFast(sender: UIButton) {
        playTimePitchedAudio(2.0, pitchChange: nil)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playTimePitchedAudio(nil, pitchChange: 1000)
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        playTimePitchedAudio(nil, pitchChange: -500)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let audioPlayerNode = startAudioSession()
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50.0
        
        configureAudioEngine(audioPlayerNode, effect: reverbEffect)
        
        startPlaying(audioPlayerNode)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let audioPlayerNode = startAudioSession()
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.wetDryMix = 50.0
        
        configureAudioEngine(audioPlayerNode, effect: echoEffect)
        
        startPlaying(audioPlayerNode)
    }
    
    
    @IBAction func stopPlayback(sender: UIButton) {
        stopAudioSession()
    }
    
    // MARK: - Audio manipulation functions
    
    func playTimePitchedAudio(rateChange: Float?, pitchChange: Float?) {
        let audioPlayerNode = startAudioSession()
        
        let timePitch = AVAudioUnitTimePitch()
        
        if let newPitch = pitchChange {
            timePitch.pitch = newPitch
        }
        
        if let newRate = rateChange {
            timePitch.rate = newRate
        }
        
        configureAudioEngine(audioPlayerNode, effect: timePitch)
        
        startPlaying(audioPlayerNode)
    }
    
    func startAudioSession() -> AVAudioPlayerNode {
        let audioSession = AVAudioSession.sharedInstance()
        
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try! audioSession.setActive(true)
        
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        stopAndResetEngine()
        
        return audioPlayerNode
    }
    
    func configureAudioEngine(playerNode: AVAudioPlayerNode, effect: AVAudioUnit) {
        audioEngine.attachNode(playerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(playerNode, to: effect, format: audioFile.processingFormat)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: audioFile.processingFormat)
    }
    
    func startPlaying(audioPlayerNode: AVAudioPlayerNode){
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        }
        catch {
            print("unable to play")
        }
    }

    func stopAudioSession() {
        stopAndResetEngine()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func stopAndResetEngine() {
        audioEngine.stop()
        audioEngine.reset()
    }
}
