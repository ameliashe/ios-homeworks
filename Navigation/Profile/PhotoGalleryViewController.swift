//
//  PhotoGalleryViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 11/16/24.
//

import UIKit
import iOSIntPackage

class PhotoGalleryViewController: UIViewController {

	let identifier: String = "PhotoGalleryCell"
	let itemsPerRow: CGFloat = 3
	let spacing: CGFloat = 8
	let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	let imageProcessor = ImageProcessor()
	var processedImages = [CGImage?]()

	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .white
		collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: identifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

	lazy var completionClosure: ([CGImage?]) -> Void = { images in
		self.processedImages = images
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = NSLocalizedString("Photo Gallery", comment: "Photo gallery VC title")

		processImages(images: imageList, completionClosure: completionClosure)
		addSubviews()
		addConstraints()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = true
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

	//default – 1.641395292
	//userInitiated – 1.605782291
	//userInteractive – 1.589748083
	//utility – 1.88586525
	//background – 21.880509458
	func processImages(images: [UIImage], completionClosure: @escaping ([CGImage?]) -> Void) {
		let start = DispatchTime.now()
		imageProcessor.processImagesOnThread(sourceImages: images, filter: .posterize, qos: .default) { processedImages in

			let end = DispatchTime.now()
			let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
			let timeInterval = Double(nanoTime) / 1_000_000_000

			   print(timeInterval)
			completionClosure(processedImages)
		}
	}
}

extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return processedImages.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoGalleryCell else {
			fatalError("could not dequeue cell")
		}

		if let cgImage = processedImages[indexPath.row] {
			let uiImage = UIImage(cgImage: cgImage)
			cell.update(uiImage)
		}
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

}

