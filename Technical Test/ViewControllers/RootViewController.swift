//
//  RootViewController.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 15/7/2022.
//

import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var savedCitiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setDelegates()
    }
}

// MARK: - IBActions
extension RootViewController {
    @IBAction func addCityButtonTapped(_ sender: UIButton) {
        present(AddCityViewController.instantiateFromStoryboard("Main"), animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate && DataSource
extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setDelegates() {
        savedCitiesTableView.delegate = self
        savedCitiesTableView.dataSource = self
        savedCitiesTableView.reloadData()
    }
    
    func registerCells() {
        let emptyCell = UINib(nibName: EmptyCell.reuseIdentifier, bundle: nil)
        savedCitiesTableView.register(emptyCell, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        
        let cityPreviewCell = UINib(nibName: CityPreviewCell.reuseIdentifier, bundle: nil)
        savedCitiesTableView.register(cityPreviewCell, forCellReuseIdentifier: CityPreviewCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let emptyCell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as? EmptyCell else {
            return UITableViewCell() }
        return emptyCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.75
//        UITableView.automaticDimension
    }
}
