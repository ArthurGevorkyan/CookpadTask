//
//  CookpadRecipesTableViewController.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 31.01.22.
//

import UIKit

class CookpadRecipesTableViewController: UITableViewController, ErrorReporter {
    let viewModel: CookpadRecipesTableViewModel
    
    required init?(coder: NSCoder) {
#if DEBUG
        fatalError("Please use the initializer with a view model on \(Self.self)")
#endif
        return nil
    }
    
    init?(coder: NSCoder, viewModel: CookpadRecipesTableViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindings()
        viewModel.loadData()
    }
}

// MARK: - ViewModel interaction
extension CookpadRecipesTableViewController {
    private func configureBindings() {
        viewModel.isDataLoading.bind { [weak self] isLoading in
            if !isLoading {
                self?.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.loadingError.bind { [weak self] error in
            if let _ = error {
                self?.showGenericAlertView()
            }
        }
        
        viewModel.itemViewModels.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - View interaction
extension CookpadRecipesTableViewController {
    @IBAction func refreshControlDidTrigger(_ sender: UIRefreshControl) {
        viewModel.loadData()
    }
}

// MARK: - UITableViewDataSource
extension CookpadRecipesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemViewModels.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = CookpadRecipesTableViewCell.defaultReuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let recipeItemCell = cell as? CookpadRecipesTableViewCell,
           0..<viewModel.itemViewModels.value.count ~= indexPath.row {
            recipeItemCell.viewModel = viewModel.itemViewModels.value[indexPath.row]
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
}
