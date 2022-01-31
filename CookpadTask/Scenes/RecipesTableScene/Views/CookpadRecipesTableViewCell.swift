//
//  CookpadRecipesTableViewCell.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 31.01.22.
//

import UIKit

class CookpadRecipesTableViewCell: UITableViewCell {
    static let defaultReuseIdentifier = "CookpadRecipeItem"
    
    @IBOutlet weak private(set) var previewImageView: UIImageView?
    @IBOutlet weak private(set) var titleLabel: UILabel?
    @IBOutlet weak private(set) var storyLabel: UILabel?
    @IBOutlet weak private(set) var ingredientCountLabel: UILabel?
    @IBOutlet weak private(set) var dateLabel: UILabel?
    
    var viewModel: CookpadRecipesTableItemViewModel? {
        didSet(oldValue) {
            guard let viewModel = viewModel, viewModel !== oldValue else {
                return
            }
            bindTo(viewModel: viewModel)
        }
    }

    private func bindTo(viewModel: CookpadRecipesTableItemViewModel) {
        viewModel.previewImage.bind { [weak self] image in
            self?.previewImageView?.image = image
        }
        viewModel.title.bind { [weak self] titleText in
            self?.titleLabel?.text = titleText
        }
        viewModel.storyText.bind { [weak self] description in
            self?.storyLabel?.text = description
        }
        viewModel.ingredientsCountText.bind { [weak self] countText in
            self?.ingredientCountLabel?.text = countText
        }
        viewModel.publishedAtText.bind { [weak self] publishedAtText in
            self?.dateLabel?.text = publishedAtText
        }
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
