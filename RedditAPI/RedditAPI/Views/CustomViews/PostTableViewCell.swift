//
//  PostTableViewCell.swift
//  RedditAPI
//
//  Created by Jacob Marillion on 2/5/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postUpsLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    
    //MARK: - Properties
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Helper Methods
    func updateViews() {
        guard let post = post else { return }
        postTitleLabel.text = post.title
        postUpsLabel.text = "Upvotes: \(post.ups)"
        
        PostController.fetchThumbnailFor(post: post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let thumbnail):
                    self.postImageView.image = thumbnail
                case .failure(let error):
                    self.postImageView.image = UIImage(systemName: "photo.on.rectangle")
                    print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }

} //End of class
