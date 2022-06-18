//
//  SoundRecordingViewController.swift
//  SoundRecognision
//
//  Created by Ivan Bolhov on 17.06.2022.
//

import UIKit

final class SoundRecordingViewController: UIViewController {

    var recordButton: UIButton!
    var recorder: Recorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBlue
        recorder = AVSoundRecorder()
        recorder.delegate = self
        recorder.register()
    }

    private func loadRecordingUI() {
        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(recordButton)
    }
    
    @objc private func recordTapped() {
        recorder.updateRecording()
    }    
}

extension SoundRecordingViewController: RecorderDelegate {
    func didRegister(isSuccess: Bool) {
        guard isSuccess else { return }
        loadRecordingUI()
    }
    
    func didUpdateRecordingState(with isInProgress: Bool, isSuccess: Bool) {
        if isInProgress {
            recordButton.setTitle("Tap to Stop", for: .normal)
        } else {
            recordButton.setTitle(isSuccess ? "Tap to Re-record" : "Tap to Record", for: .normal)
        }
    }
}
