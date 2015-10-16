//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ada Ji on 10/7/15.
//  Copyright © 2015 Ada Ji. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var receivedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    // MARK: - Play Audio
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithRate(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.3
        playAudioWithEffect(echoEffect)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 60
        playAudioWithEffect(reverbEffect)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetAllAudioPlayers()
    }
    
    func playAudioWithRate(rate: Float) {
        stopAndResetAllAudioPlayers()
        
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithPitch(pitch: Float) {
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        playAudioWithEffect(pitchEffect)
    }
    
    func playAudioWithEffect(effect: AVAudioNode) {
        stopAndResetAllAudioPlayers()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    // Stop and reset all the audio players.
    func stopAndResetAllAudioPlayers() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        audioEngine.stop()
        audioEngine.reset()
    }
    
}









