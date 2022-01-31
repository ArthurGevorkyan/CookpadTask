//
//  CookpadCollectionsTableViewCell.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 30.01.22.
//

import UIKit

class CookpadCollectionsTableViewCell: UITableViewCell {
    static let defaultReuseIdentifier = "CookpadCollectionItem"
    
    @IBOutlet weak private(set) var previewImageView: UIImageView?
    @IBOutlet weak private(set) var titleLabel: UILabel?
    @IBOutlet weak private(set) var descriptionLabel: UILabel?
    @IBOutlet weak private(set) var recipeCountLabel: UILabel?
    
    var viewModel: CookpadCollectionsTableItemViewModel? {
        didSet(oldValue) {
            guard let viewModel = viewModel, viewModel !== oldValue else {
                return
            }
            bindTo(viewModel: viewModel)
        }
    }

    private func bindTo(viewModel: CookpadCollectionsTableItemViewModel) {
        viewModel.previewImage.bind { [weak self] image in
            self?.previewImageView?.image = image
        }
        viewModel.title.bind { [weak self] titleText in
            self?.titleLabel?.text = titleText
        }
        viewModel.descriptionText.bind { [weak self] description in
            self?.descriptionLabel?.text = description
        }
        viewModel.recipeCountText.bind { [weak self] countText in
            self?.recipeCountLabel?.text = countText
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
