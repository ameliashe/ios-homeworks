//
//  PostManager.swift
//  Navigation
//
//  Created by Amelia Romanova on 3/4/25.
//

import Foundation
import CoreData


final class PostManager {
	static let shared = PostManager()

	//	var context: NSManagedObjectContext {
	//		return persistentContainer.viewContext
	//	}

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "FavoritePost")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {

				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	func fetchPosts() -> [Post] {
		let fetchRequest = FavoritePost.fetchRequest()
		let entities = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []

		let posts = entities.map { entity in
			return Post(
				author: entity.author ?? "",
				description: entity.postDescription ?? "",
				image: entity.image ?? "",
				likes: Int(entity.likes),
				views: Int(entity.views)
			)
		}
		return posts
	}

	func savePost(_ post: Post) {
		if isPostSaved(post) {
			print("Post is already saved!")
			return
		}

		let postEntity = FavoritePost(context: persistentContainer.viewContext)
		postEntity.author = post.author
		postEntity.postDescription = post.description
		postEntity.image = post.image
		postEntity.likes = Int64(post.likes)
		postEntity.views = Int64(post.views)

		try? persistentContainer.viewContext.save()
		print("Post saved! Amount of posts: \(fetchPosts().count)")
	}

	func deletePost(_ post: Post) {
		guard let postEntity = findPostEntity(post) else {
			print("Couldn't delete post")
			return
		}

		let context = postEntity.managedObjectContext
		context?.delete(postEntity)
		try? context?.save()
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
}
