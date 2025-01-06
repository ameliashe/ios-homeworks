//
//  PhotoGalleryViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 11/16/24.
//

import UIKit
import iOSIntPackage

class PhotoGalleryViewController: UIViewController {

	let imagePublisher = ImagePublisherFacade()
	var receivedImages = [UIImage]()

	let identifier: String = "PhotoGalleryCell"
	let itemsPerRow: CGFloat = 3
	let spacing: CGFloat = 8
	let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .white
		collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: identifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Photo Gallery"

		addSubviews()
		addConstraints()

		imagePublisher.addImagesWithTimer(time: 0.5, repeat: 10, userImages: imageList)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
		imagePublisher.subscribe(self)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = true
		imagePublisher.removeSubscription(for: self)
	}

	func addSubviews() {
		view.addSubview(collectionView)

		collectionView.delegate = self
		collectionView.dataSource = self
		
	}

	func addConstraints() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageLibrarySubscriber {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return receivedImages.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoGalleryCell else {
			fatalError("could not dequeue cell")
		}

		cell.update(receivedImages[indexPath.row])
		cell.contentView.layer.masksToBounds = true
		cell.contentView.clipsToBounds = true
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = (view.frame.width-32)/3
		return CGSize(width: size, height: size)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}

	func receive(images: [UIImage]) {
		receivedImages = images
		collectionView.reloadData()
	}

}
