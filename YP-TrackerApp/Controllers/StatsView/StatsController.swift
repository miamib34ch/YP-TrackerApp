//
//  Stats.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.04.2023.
//

import UIKit

final class StatsController: UIViewController {
    
    private let statisticsLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "StatsPlaceholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let statisticsTable: UITableView = {
        let table = UITableView()
        table.register(StatsCell.self, forCellReuseIdentifier: "statisticsCell")
        table.separatorStyle = .none
        table.allowsSelection = false
        table.backgroundColor = UIColor(named: "MainBackgroundColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
    }

    private func configureView() {
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        removeTable()
        removePlaceholder()
        view.addSubview(statisticsLabel)
        statisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        statisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        if DataProvider.shared.takeRecords().isEmpty {
            view.addSubview(placeholderImage)
            view.addSubview(placeholderLabel)
            
            NSLayoutConstraint.activate([
                placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
                placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            view.addSubview(statisticsTable)
            
            statisticsTable.dataSource = self
            statisticsTable.delegate = self
            
            NSLayoutConstraint.activate([
                statisticsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                statisticsTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                statisticsTable.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                statisticsTable.heightAnchor.constraint(equalToConstant: 90)
            ])
        }
    }
    
    private func removeTable() {
        if !view.contains(statisticsTable) { return }

        statisticsTable.removeFromSuperview()
    }
    
    private func removePlaceholder() {
        if !(view.contains(placeholderImage) && view.contains(placeholderLabel)) { return }

        placeholderImage.removeFromSuperview()
        placeholderLabel.removeFromSuperview()
    }
    
}

extension StatsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath)
        guard let statisticsCell = cell as? StatsCell else { return UITableViewCell() }
        statisticsCell.numberLabel.text = "\(DataProvider.shared.takeRecords().count)"
        return statisticsCell
    }
    
}

extension StatsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
