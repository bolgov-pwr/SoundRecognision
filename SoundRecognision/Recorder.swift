//
//  Recorder.swift
//  SoundRecognision
//
//  Created by Ivan Bolhov on 17.06.2022.
//

import Foundation
import AVFoundation

protocol Recorder {
    var delegate: RecorderDelegate? { get set }
    
    func register()
    func startRecording()
    func finishRecording(success: Bool)
    func updateRecording()
}

protocol RecorderDelegate: AnyObject {
    func didRegister(isSuccess: Bool)
    func didUpdateRecordingState(with isInProgress: Bool, isSuccess: Bool)
}

final class AVSoundRecorder: NSObject, Recorder {
    
    weak var delegate: RecorderDelegate?
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    
    func register() {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.delegate?.didRegister(isSuccess: true)
                    } else {
                        self.delegate?.didRegister(isSuccess: false)
                    }
                }
            }
        } catch {
            delegate?.didRegister(isSuccess: false)
        }
    }
    
    func startRecording() {
        let audioFilename = FileManager.default.getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            delegate?.didUpdateRecordingState(with: true, isSuccess: false)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        delegate?.didUpdateRecordingState(with: false, isSuccess: success)
    }
    
    func updateRecording() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}

extension AVSoundRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
