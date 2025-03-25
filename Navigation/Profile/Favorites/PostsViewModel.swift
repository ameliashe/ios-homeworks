//
//  PostsViewModel.swift
//  Navigation
//
//  Created by Amelia Romanova on 3/4/25.
//

import Foundation
import CoreData

final class PostsViewModel {

	private(set) var posts: [Post] = []
	var postsChangesBlock: (() -> Void)?

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "FavoritePost")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {

				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	func fetchPosts() {
		let fetchRequest = FavoritePost.fetchRequest()
		let entities = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
		let posts = entities.map(Post.init)

		persistentContainer.viewContext.perform { [weak self] in
			self?.posts = posts
			self?.postsChangesBlock?()
		}
	}

	func savePost(_ post: Post) {
		if isPostSaved(post) {
			print("Post is already saved!")
			return
		}

		persistentContainer.performBackgroundTask { [weak self] backgroundContext in
			let postEntity = FavoritePost(context: backgroundContext)
			postEntity.author = post.author
			postEntity.postDescription = post.description
			postEntity.image = post.image
			postEntity.likes = Int64(post.likes)
			postEntity.views = Int64(post.views)

			do {
				try backgroundContext.save()
				DispatchQueue.main.async {
					self?.fetchPosts()
				}
			} catch {
				print("Failed to save post: \(error)")
			}
		}
	}

	func deletePost(_ post: Post) {

		persistentContainer.performBackgroundTask { [weak self] backgroundContext in
			guard let self  else {
				return
			}

			let fetchRequest = FavoritePost.fetchRequest()
			fetchRequest.predicate = NSPredicate(
				format: "author == %@ AND postDescription == %@ AND image == %@",
				post.author, post.description, post.image
			)

			if let result = try? backgroundContext.fetch(fetchRequest),
			   let postEntity = result.first {
				
				backgroundContext.delete(postEntity)

				do {
					try backgroundContext.save()
					self.fetchPosts()
				} catch {
					print("Failed to delete post: \(error)")
				}

			} else {
				print("Couldn't delete post: not found in background context")
			}

		}
	}

	func isPostSaved(_ post: Post) -> Bool {
		return findPostEntity(post) != nil
	}

	private func findPostEntity(_ post: Post) -> FavoritePost? {
		let fetchRequest = FavoritePost.fetchRequest()
		fetchRequest.predicate = NSPredicate(
			format: "author == %@ AND postDescription == %@ AND image == %@",
			post.author, post.description, post.image
		)

		return (try? persistentContainer.viewContext.fetch(fetchRequest))?.first
	}

	func updatePostsFiltered(by name: String?) {
		let fetchRequest = FavoritePost.fetchRequest()
		if let name = name, !name.isEmpty {
			fetchRequest.predicate = NSPredicate(format: "author CONTAINS[cd] %@", name)
		}
		let entities = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []

		persistentContainer.viewContext.perform { [weak self] in
			self?.posts = entities.map(Post.init)
			self?.postsChangesBlock?()
		}
	}
}

extension Post {
	init(entity: FavoritePost) {
		self.author = entity.author ?? ""
		self.description = entity.postDescription ?? ""
		self.image = entity.image ?? ""
		self.likes = Int(entity.likes)
		self.views = Int(entity.views)
	}
}
