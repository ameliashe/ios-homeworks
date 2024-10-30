//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Amelia Romanova on 10/31/24.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .lightGray
		title = "Profile"

		view.addSubview(profileHeaderView)
    }

	let profileHeaderView = ProfileHeaderView()

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		profileHeaderView.frame = view.frame

		navigationController?.navigationBar.isTranslucent = false
	}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
