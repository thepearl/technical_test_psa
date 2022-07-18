//
//  RootViewController.swift
//  Technical Test
//
//  Created by Ghazi Tozri on 15/7/2022.
//

import UIKit
import OpenWeatherAPI

class RootViewController: UIViewController {
    @IBOutlet weak var savedCitiesTableView: UITableView!
    
    var savedCities: [OWResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDelegates()
    }
}

// MARK: - IBActions
extension RootViewController {
    @IBAction func addCityButtonTapped(_ sender: UIButton) {
        let addCitySheet = AddCityViewController.instantiateFromStoryboard("Main")
        addCitySheet.delegate = self
        present(addCitySheet, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate && DataSource
extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setDelegates() {
        savedCitiesTableView.delegate = self
        savedCitiesTableView.dataSource = self
        self.savedCities = UserDefaultsInteractor.shared.getCitiesFromCache()
        savedCitiesTableView.reloadData()
    }
    
    func registerCells() {
        let emptyCell = UINib(nibName: EmptyCell.reuseIdentifier, bundle: nil)
        savedCitiesTableView.register(emptyCell, forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        
        let cityPreviewCell = UINib(nibName: CityPreviewCell.reuseIdentifier, bundle: nil)
        savedCitiesTableView.register(cityPreviewCell, forCellReuseIdentifier: CityPreviewCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCities.isEmpty ? 1 : savedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !savedCities.isEmpty,
              indexPath.row < savedCities.count else {
            guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as? EmptyCell else {
                return UITableViewCell() }
            return emptyCell
        }
        
        guard let cityPreviewCell = tableView.dequeueReusableCell(withIdentifier: CityPreviewCell.reuseIdentifier, for: indexPath) as? CityPreviewCell else {
            return UITableViewCell()
        }
        
        cityPreviewCell.previewableObject = savedCities[indexPath.row]
        return cityPreviewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            !savedCities.isEmpty,
            indexPath.row < savedCities.count
        else { return }
        
        let detailsViewController = CityDetailsViewController.instantiateFromStoryboard("Main")
        detailsViewController.details = savedCities[indexPath.row]
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
