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
        
        let audioSession = AVAudioSession.sharedInstance()
        
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
        try! audioSession.setActive(true)

        let audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        let timePitch = AVAudioUnitTimePitch()
        
        if let newPitch = pitchChange {
            timePitch.pitch = newPitch
        }
        
        if let newRate = rateChange {
            timePitch.rate = newRate
        }
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(audioPlayerNode, to: timePitch, format: audioFile.processingFormat)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do
        {
            try audioEngine.start()
            audioPlayerNode.play()
        }
        catch {
            print("unable to play")
        }

    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioEngine.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

        audioEngine.reset()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
