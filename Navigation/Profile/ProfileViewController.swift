//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {
	
	//MARK: Properties
	var isShowingFavoritePosts: Bool = false
	var user: User?
	var displayedPosts = [Post]()
	private let viewModel = PostsViewModel()

	private enum HeaderFooterReuseID: String {
		case base = "ProfileHeaderView_ID"
	}

	private enum CellReuseID: String {
		case base = "ProfilePostCell_ID"
		case photos = "PhotosTableViewCell_ID"
	}


	//MARK: UI elements
	var profileHeaderView: ProfileHeaderView?

	lazy private var displayedPostsTableView: UITableView = {
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


	//MARK: Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		addSubviews()
		setupView()
		setupConstraints()
		setupTableView()
		setupCloseButton()
		setupGesture()
		setupNavigationBar()
		configureFavoritesTable()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		loadTable()
	}

	//MARK: Layout
	func addSubviews() {
		view.addSubview(displayedPostsTableView)
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

	func setupNavigationBar() {
		if isShowingFavoritePosts {
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterButtonTapped))
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clearButtonTapped))
		} else {
		}
	}

	func setupTableView() {
		displayedPostsTableView.rowHeight = UITableView.automaticDimension
		displayedPostsTableView.estimatedRowHeight = 200
		displayedPostsTableView.tableFooterView = UIView()
		displayedPostsTableView.contentInsetAdjustmentBehavior = .never

		displayedPostsTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.base.rawValue)

		displayedPostsTableView.register(CustomPostCell.self, forCellReuseIdentifier: CellReuseID.base.rawValue)

		displayedPostsTableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: CellReuseID.photos.rawValue)

		displayedPostsTableView.delegate = self
		displayedPostsTableView.dataSource = self
	}

	func setupConstraints() {
		NSLayoutConstraint.activate([
			displayedPostsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			displayedPostsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			displayedPostsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			displayedPostsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

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

	func loadTable() {
		if isShowingFavoritePosts {
			viewModel.fetchPosts()
		}
	}

	func configureFavoritesTable() {
		if isShowingFavoritePosts {
			viewModel.postsChangesBlock = { [weak self] in
				self?.displayedPosts = self?.viewModel.posts ?? []
				self?.displayedPostsTableView.reloadData()
			}
		} else {
			self.displayedPosts = posts
		}
	}


	//MARK: User Interaction
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


	func setupGesture() {
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
		doubleTapGesture.numberOfTapsRequired = 2
		displayedPostsTableView.addGestureRecognizer(doubleTapGesture)
	}

	@objc private func doubleTapHandler(_ gesture: UITapGestureRecognizer) {
		let location = gesture.location(in: displayedPostsTableView)
		guard let indexPath = displayedPostsTableView.indexPathForRow(at: location), indexPath.section == 1 else {
			return
		}

		let selectedPost = displayedPosts[indexPath.row]

		if viewModel.isPostSaved(selectedPost) {
			return
		} else {
			viewModel.savePost(selectedPost)
			let alertController = UIAlertController(title: "Saved to Faves!", message: nil, preferredStyle: .alert)
			alertController.view.layer.opacity = 0.7
			self.present(alertController, animated: true)
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				alertController.dismiss(animated: true)
			}
		}
		loadTable()
	}

	@objc func filterButtonTapped() {
		let alertvc = UIAlertController(title: "Search by author", message: nil, preferredStyle: .alert)
		alertvc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alertvc.addTextField()
		alertvc.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak self] _ in
			guard let self = self else {
				return
			}
			guard let textField = alertvc.textFields?.first else {
				return
			}
			viewModel.updatePostsFiltered(by: textField.text ?? "")
		}))

		present(alertvc, animated: true)
	}

	@objc func clearButtonTapped() {
		self.loadTable()
	}
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 && !isShowingFavoritePosts {
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
			return isShowingFavoritePosts ? 0 : 1
		}
		return displayedPosts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 && !isShowingFavoritePosts {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.photos.rawValue, for: indexPath) as? PhotosTableViewCell else {
				fatalError("Could not dequeue PhotosTableViewCell")
			}
			return cell
		}
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.base.rawValue, for: indexPath) as? CustomPostCell else {
			fatalError("Could not dequeue CustomPostCell")
		}
		guard !displayedPosts.isEmpty else {
			return UITableViewCell()
		}
		cell.update(displayedPosts[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return isShowingFavoritePosts ? 0 : (section == 1 ? 0 : 220)
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 0  && !isShowingFavoritePosts {
			let galleryVC = PhotoGalleryViewController()
			navigationController?.pushViewController(galleryVC, animated: true)
		} else {
		}
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if isShowingFavoritePosts {
			if editingStyle == .delete {
				viewModel.deletePost(displayedPosts[indexPath.row])
				loadTable()
			}
		} else {
		}
	}
}
