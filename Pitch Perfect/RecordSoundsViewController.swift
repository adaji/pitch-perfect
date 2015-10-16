//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ada Ji on 10/4/15.
//  Copyright © 2015 Ada Ji. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        progressLabel.hidden = false
        progressLabel.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        pauseButton.enabled = true
        stopButton.enabled = true
        progressLabel.text = "Recording..."
        
        // Use the same file name for every recording
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Record the user's voice
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func pauseRecording(sender: UIButton) {
        if (audioRecorder.recording) {
            pauseButton.setImage(UIImage(named: "resume"), forState: .Normal)
            progressLabel.text = "Paused"
            
            audioRecorder.pause()
        }
        else {
            pauseButton.setImage(UIImage(named: "pause"), forState: .Normal)
            progressLabel.text = "Recording..."
            
            audioRecorder.record()
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        stopButton.enabled = false
        pauseButton.enabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        progressLabel.text = "Processing..."
        
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        progressLabel.hidden = true

        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            print("Recording was not successful")
            recordButton.enabled = true
            pauseButton.hidden = true
            stopButton.hidden = true
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}











