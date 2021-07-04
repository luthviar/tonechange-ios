//
//  RecordSoundsViewController.swift
//  ToneChange
//
//  Created by Luthfi Abdurrahim on 02/07/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI(stateRecording: .notRecording)
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        configureUI(stateRecording: .recording)
        startRecord()
    }
    
    @IBAction func stopRecordAudio(_ sender: UIButton) {
        configureUI(stateRecording: .notRecording)
        stopRecord()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("not success save")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let audioURL = sender as! URL
            playSoundsVC.recordedAudioURL = audioURL
        }
    }
    
    
}

extension RecordSoundsViewController {
    enum stateRecord {
        case notRecording, recording
    }
    
    func configureUI(stateRecording: stateRecord) {
        switch stateRecording {
            case .notRecording:
                recordButton.isEnabled = true
                stopRecordingButton.isEnabled = false
                recordLabel.text = "Tap to Record"
            case .recording:
                recordButton.isEnabled = false
                stopRecordingButton.isEnabled = true
                recordLabel.text = "Audio is recording..."
        }
    }
    
    func startRecord() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecord() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}
