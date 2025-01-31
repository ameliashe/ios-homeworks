//
//  VideosViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 1/30/25.
//

import UIKit
import AVKit

class VideosViewController: UIViewController {

	let videoCellID: String = "videoCellID"

	let videosTableview: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		view.addSubview(videosTableview)
		setupTableView()
		setupConstraints()
    }


	func setupConstraints() {
		NSLayoutConstraint.activate([
			videosTableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			videosTableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			videosTableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			videosTableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])
	}

	func setupTableView() {
		videosTableview.rowHeight = UITableView.automaticDimension
		videosTableview.estimatedRowHeight = 100
		videosTableview.register(VideosTableViewCell.self, forCellReuseIdentifier: videoCellID)

		videosTableview.delegate = self
		videosTableview.dataSource = self
	}
}

extension VideosViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Videos.videoList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: videoCellID, for: indexPath) as? VideosTableViewCell else {
			fatalError("Could not dequeue VideosTableViewCell")
		}
		cell.update(Videos.videoList[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let videoURL = URL(string: Videos.videoList[indexPath.row]) else {
			return
		}
		let player = AVPlayer(url: videoURL)
		let controller = AVPlayerViewController()
		controller.player = player
		present(controller, animated: true) {
			player.play()
		}
	}	
}
