//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {

	var user: User?

	private enum HeaderFooterReuseID: String {
		case base = "ProfileHeaderView_ID"
	}

	private enum CellReuseID: String {
		case base = "ProfilePostCell_ID"
		case photos = "PhotosTableViewCell_ID"
	}

	var profileHeaderView: ProfileHeaderView?

	lazy private var postsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}()

	let overlayView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alpha = 0
		return view
	}()

	let closeButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.tintColor = .white
		button.translatesAutoresizingMaskIntoConstraints = false
		button.alpha = 0
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		addSubviews()
		setupView()
		setupConstraints()
		setupTableView()
		setupCloseButton ()
	}

	func addSubviews() {
		view.addSubview(postsTableView)
		view.addSubview(overlayView)
		view.addSubview(closeButton)
	}

	func setupView() {
#if DEBUG
		view.backgroundColor = .systemYellow
#else
		view.backgroundColor = .systemGreen
#endif

	}

	func setupTableView() {
		postsTableView.rowHeight = UITableView.automaticDimension
		postsTableView.estimatedRowHeight = 200
		postsTableView.tableFooterView = UIView()
		postsTableView.contentInsetAdjustmentBehavior = .never

		postsTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue)

		postsTableView.register(CustomPostCell.self, forCellReuseIdentifier: CellReuseID.base.rawValue)

		postsTableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: CellReuseID.photos.rawValue)

		postsTableView.delegate = self
		postsTableView.dataSource = self
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			postsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			postsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			postsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

			overlayView.topAnchor.constraint(equalTo: view.topAnchor),
			overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
		])
	}

	func setupCloseButton () {
		closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
	}

	func animateAvatarExpansion() {
		guard let profileHeaderView = self.profileHeaderView else {
			print("Header view not found")
			return
		}
		let avatar = profileHeaderView.avatarImageView
		guard let avatarSuperview = avatar.superview else {
			print("Avatar superview not found")
			return
		}

		let avatarInitialFrame = avatarSuperview.convert(avatar.frame, to: view)

		let avatarCopy = UIImageView(image: avatar.image)
		avatarCopy.frame = avatarInitialFrame
		avatarCopy.contentMode = .scaleAspectFill
		avatarCopy.layer.cornerRadius = avatar.layer.cornerRadius
		avatarCopy.layer.masksToBounds = true
		avatarCopy.tag = 999
		view.addSubview(avatarCopy)

		avatar.isHidden = true

		let targetFrame = CGRect(
			x: 0,
			y: view.center.y - (view.frame.width / 2),
			width: view.frame.width,
			height: view.frame.width
		)

		UIView.animate(withDuration: 0.5, animations: {
			self.overlayView.alpha = 1
			avatarCopy.frame = targetFrame
			avatarCopy.layer.cornerRadius = 0
		}, completion: { _ in
			UIView.animate(withDuration: 0.3) {
				self.closeButton.alpha = 1
			}
		})
	}

	@objc private func closeButtonTapped() {
		guard let avatarCopy = view.viewWithTag(999) as? UIImageView else { return }

		UIView.animate(withDuration: 0.3, animations: {
			self.closeButton.alpha = 0
		})

		guard let headerView = self.profileHeaderView else {
			print("Header view not found")
			return
		}
		let avatar = headerView.avatarImageView
		guard let avatarSuperview = avatar.superview else {
			print("Avatar superview not found")
			return
		}
		let avatarInitialFrame = avatarSuperview.convert(avatar.frame, to: view)


		UIView.animate(withDuration: 0.5, animations: {
			self.overlayView.alpha = 0
			avatarCopy.frame = avatarInitialFrame
			avatarCopy.layer.cornerRadius = avatar.frame.height / 2
		}, completion: { _ in
			avatarCopy.removeFromSuperview()
			avatar.isHidden = false
		})
	}
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterReuseID.base.rawValue) as? ProfileHeaderView else {
				return nil
			}

			if let user = user {
				headerView.configure(with: user)
			}

			headerView.contentView.backgroundColor = .systemGray6
			headerView.avatarTapped = { [weak self] in
				guard let self = self else { return }
				self.animateAvatarExpansion()
			}
			self.profileHeaderView = headerView
			return headerView
		}
		return nil
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return posts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.photos.rawValue, for: indexPath) as? PhotosTableViewCell else {
				fatalError("Could not dequeue PhotosTableViewCell")
			}
			return cell
		}
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.base.rawValue, for: indexPath) as? CustomPostCell else {
			fatalError("Could not dequeue CustomPostCell")
		}
		cell.update(posts[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 1 ? 0 : 220
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			let galleryVC = PhotoGalleryViewController()
			navigationController?.pushViewController(galleryVC, animated: true)
		} else {
		}
	}
}
