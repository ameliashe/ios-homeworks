//
//  PlayerViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/30/25.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {

	var player = AVAudioPlayer()
	let music = ["Queen", "Navigating", "Fade Away", "Overcompensate", "The Code", "Obsession"]
	var currentTrackIndex = 0
	var timer: Timer?

	//MARK: UI elements
	private lazy var playButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
		button.tintColor = ColorPalette.customTextColor
		button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var stopButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "stop.fill", withConfiguration: largeConfig), for: .normal)
		button.tintColor = ColorPalette.customTextColor
		button.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var previousTrackButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "backward.fill", withConfiguration: largeConfig), for: .normal)
		button.tintColor = ColorPalette.customTextColor
		button.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var nextTrackButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "forward.fill", withConfiguration: largeConfig), for: .normal)
		button.tintColor = ColorPalette.customTextColor
		button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private lazy var timecodeLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.textColor = .systemGray
		label.text = String(format: "%02d:%02d", ((Int)((player.currentTime))) / 60, ((Int)((player.currentTime))) % 60)
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private lazy var durationLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.textColor = .systemGray
		label.font = .systemFont(ofSize: 16, weight: .light)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let trackNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = ColorPalette.customTextColor
		label.font = .systemFont(ofSize: 25, weight: .medium)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)

	//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = ColorPalette.customBackground

		addSubviews()
		setConstraints()
		setupAudioPlayer(music[currentTrackIndex])

		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

	//MARK: Layout
	func addSubviews() {
		view.addSubview(playButton)
		view.addSubview(stopButton)
		view.addSubview(previousTrackButton)
		view.addSubview(nextTrackButton)
		view.addSubview(trackNameLabel)
		view.addSubview(timecodeLabel)
		view.addSubview(durationLabel)
	}

	func setConstraints() {
		NSLayoutConstraint.activate([
			playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			playButton.widthAnchor.constraint(equalToConstant: 50),
			playButton.heightAnchor.constraint(equalToConstant: 50),

			stopButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
			stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
			stopButton.widthAnchor.constraint(equalToConstant: 50),
			stopButton.heightAnchor.constraint(equalToConstant: 50),

			trackNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			trackNameLabel.bottomAnchor.constraint(equalTo: timecodeLabel.topAnchor, constant: -16),

			timecodeLabel.bottomAnchor.constraint(equalTo: previousTrackButton.topAnchor, constant: -8),
			timecodeLabel.centerXAnchor.constraint(equalTo: previousTrackButton.centerXAnchor),

			durationLabel.bottomAnchor.constraint(equalTo: nextTrackButton.topAnchor, constant: -8),
			durationLabel.centerXAnchor.constraint(equalTo: nextTrackButton.centerXAnchor),

			previousTrackButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
			previousTrackButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: -80),
			previousTrackButton.widthAnchor.constraint(equalToConstant: 50),
			previousTrackButton.heightAnchor.constraint(equalToConstant: 50),

			nextTrackButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
			nextTrackButton.centerXAnchor.constraint(equalTo: stopButton.centerXAnchor, constant: 80),
			nextTrackButton.widthAnchor.constraint(equalToConstant: 50),
			nextTrackButton.heightAnchor.constraint(equalToConstant: 50),
		])
	}

	//MARK: Player setup
	func setupAudioPlayer(_ song: String) {
		guard let musicURL = Bundle.main.path(forResource: song, ofType: "mp3") else {
			print("Audio file not found")
			return
		}
		do {
			player.stop()
			player.currentTime = 0
			timecodeLabel.text = "00:00"
			player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: musicURL))
			player.prepareToPlay()
			trackNameLabel.text = "\(player.url?.deletingPathExtension().lastPathComponent ?? "No data")"
			durationLabel.text = String(format: "%02d:%02d", ((Int)((player.duration))) / 60, ((Int)((player.duration))) % 60)
		}
		catch {
			print(error)
		}
	}

	@objc func updateTime() {
		timecodeLabel.text = String(format: "%02d:%02d", Int(player.currentTime) / 60, Int(player.currentTime) % 60)
	}


	//MARK: User Interaction Methods
	@objc func playTapped(_ sender: Any) {
		if player.isPlaying {
			player.stop()
			playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
		}
		else {
			player.play()
			playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: largeConfig), for: .normal)
		}
	}

	@objc func stopTapped(_ sender: Any) {
		if player.isPlaying {
			player.stop()
			player.currentTime = 0
			playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig), for: .normal)
			timecodeLabel.text = "00:00"
		} else {
			print("Already stopped!")
		}
	}

	@objc func previousTapped() {
		let wasPlaying = player.isPlaying

		if currentTrackIndex > 0 {
			currentTrackIndex -= 1
		} else {
			currentTrackIndex = music.count - 1
		}

		setupAudioPlayer(music[currentTrackIndex])

		if wasPlaying {
			player.play()
		} else {
			return
		}
	}

	@objc func nextTapped() {
		let wasPlaying = player.isPlaying

		if currentTrackIndex < music.count - 1 {
			currentTrackIndex += 1
		} else {
			currentTrackIndex = 0
		}

		setupAudioPlayer(music[currentTrackIndex])

		if wasPlaying {
			player.play()
		} else {
			return
		}

	}
}


