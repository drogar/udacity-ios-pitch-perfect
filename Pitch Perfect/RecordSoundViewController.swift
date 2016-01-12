//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Brett Giles on 2015-12-30.
//  Copyright © 2015 Drogar Industries Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordedFileUrl: NSURL!
    
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Set up file url for recording(s). constant location, override older recordings.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        recordedFileUrl = NSURL.fileURLWithPathComponents(pathArray)
        print(recordedFileUrl)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        pauseResumeButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap microphone to record"
    }


    @IBAction func recordAudio(sender: UIButton) {
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true)
        
        recordingInProgress.text = "Recording"
        stopButton.hidden = false
        recordButton.enabled = false
        pauseResumeButton.setImage(UIImage.init(named: "Pause"), forState: UIControlState.Normal)
        pauseResumeButton.hidden = false
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)

        try! audioRecorder = AVAudioRecorder(URL: recordedFileUrl!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func pauseOrResumeRecording(sender: UIButton) {
        if pauseResumeButton.imageForState(UIControlState.Normal) == UIImage.init(named: "Pause") {
            pauseResumeButton.setImage(UIImage.init(named: "Resume"), forState: UIControlState.Normal)
            recordingInProgress.text = "Recording (paused)"
            audioRecorder.pause()
        } else {
            pauseResumeButton.setImage(UIImage.init(named: "Pause"), forState: UIControlState.Normal)
            recordingInProgress.text = "Recording"
            audioRecorder.record()
        }

    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        recordingInProgress.text = "Tap microphone to record"
        recordButton.enabled = true
        stopButton.hidden = true
        pauseResumeButton.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)

            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
            
        
            performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StopRecording" {
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

