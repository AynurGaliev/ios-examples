//
//  ViewController.swift
//  Speech Recognition
//
//  Created by Aynur Galiev on 7.декабря.2016.
//  Copyright © 2016 Aynur Galiev. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

final class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var speechTextView: UITextView!
    
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            self.audioSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    self.recordButton.isEnabled = allowed
                }
            }
        } catch let error {
            debugPrint(error)
        }
    }

    @IBAction func recordAction(_ sender: UIButton) {
        if audioRecorder == nil {
            self.startRecord()
        } else {
            self.finishRecord(success: true)
        }
    }
    
    func getAudioPath(for filename: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(filename)
    }
    
    func startRecord() {
        
        let audioFilename = self.getAudioPath(for: "audio.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
            
            self.recordButton.setTitle("Tap to finish", for: .normal)
        } catch {
            self.finishRecord(success: false)
        }
    }
    
    func finishRecord(success: Bool) {
        self.audioRecorder.stop()
        self.audioRecorder = nil
        self.recordButton.setTitle("Record", for: .normal)
        
        guard success else { return }
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else { return }
        
        let audioPath = self.getAudioPath(for: "audio.m4a")
        
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: audioPath)
        recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            DispatchQueue.main.async {
                self.speechTextView.text = result?.bestTranscription.formattedString
            }
        })
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            self.finishRecord(success: false)
        }
    }

}

