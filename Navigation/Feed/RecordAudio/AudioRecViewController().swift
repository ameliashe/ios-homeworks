//
//  AudioRecViewController().swift
//  Navigation
//
//  Created by Amelia Romanova on 1/31/25.
//

import UIKit
import AVFoundation

class AudioRecViewController: UIViewController {

	var audioRecorder: AVAudioRecorder!
	var audioPlayer: AVAudioPlayer!
	var recordingSession: AVAudioSession!
	var audioFileName: URL?


	// MARK: UI Elements
	private lazy var recordButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "record.circle", withConfiguration: largeConfig), for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var playButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
		button.tintColor = .blue
		button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
		button.isEnabled = false
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)

	// MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		recordingSession = AVAudioSession.sharedInstance()
		addSubviews()
		setupConstraints()
		requestMicrophonePermission()
	}

	//MARK: Setup UI
	func addSubviews() {
		view.addSubview(recordButton)
		view.addSubview(playButton)
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),

			playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
		])
	}


	//MARK: Permission
	private func requestMicrophonePermission() {
		let status = AVCaptureDevice.authorizationStatus(for: .audio)
		switch status {
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .audio) { granted in
				DispatchQueue.main.async {
					if granted {
						print("Already authorized")
						self.recordButton.isEnabled = true
					} else {
						return
					}
				}
			}
		case .authorized:
			print("Already authorized")
		case .restricted, .denied:
			showPermissionAlert()
		}
	}

	private func showPermissionAlert() {
		let alert = UIAlertController(title: "Audio recording is not allowed",
									  message: "Grant permission in Settings to record audio",
									  preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true)
	}

	private func setupRecorder() {
		let audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
		audioFileName = audioFilename

		let settings: [String: Any] = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]

		do {
			audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
			guard let recorder = audioRecorder else {
				showErrorAlert(message: "Error creating audio recorder")
				return
			}
			recorder.delegate = self
			recorder.prepareToRecord()
		} catch {
			showErrorAlert(message: "Error creating audio recorder: \(error.localizedDescription)")
		}
	}

	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	//MARK: User interaction methods
	@objc private func recordTapped() {
		if audioRecorder == nil {
			setupRecorder()
		}

		guard let recorder = audioRecorder else {
			showErrorAlert(message: "Recorder is not initialized")
			return
		}

		if recorder.isRecording {
			recorder.stop()
			recordButton.tintColor = .black
			playButton.isEnabled = true
		} else {
			do {
				try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
				try recordingSession.setActive(true)
				recorder.record()
				recordButton.tintColor = .red
			} catch {
				showErrorAlert(message: "Error: \(error.localizedDescription)")
			}
		}
	}

	@objc private func playTapped() {
		guard let audioFileName = audioFileName, FileManager.default.fileExists(atPath: audioFileName.path) else {
			showErrorAlert(message: "Audio file not found!")
			return
		}

		do {
			audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
			audioPlayer?.play()
		} catch {
			showErrorAlert(message: "Error: \(error.localizedDescription)")
		}
	}
}

extension AudioRecViewController: AVAudioRecorderDelegate {

}
