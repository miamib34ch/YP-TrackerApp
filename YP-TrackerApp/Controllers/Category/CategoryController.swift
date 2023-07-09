//
//  CategoryController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 27.06.2023.
//

import UIKit


final class CategoryController: UIViewController, CreateTrackerDelegate {
    
    var createTrackerController: CreateTrackerProtocol?
    
    var categories: [String] = []
    var selectedCategory: Int?
    
    private let label = UILabel()
    private let button = UIButton()
    private var table = UITableView()
    private let imageView = UIImageView()
    private let imageLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let trackerCategories = createTrackerController?.trackerView?.categories else { return }
        for trackerCategory in trackerCategories {
            categories.append(trackerCategory.name)
            
            if let beforeSelectedCategory = createTrackerController?.selectedCategory {
                if trackerCategory.name == beforeSelectedCategory{
                    selectedCategory = categories.count-1
                }
            }
        }
        
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        guard let selectedCategory = selectedCategory else { return }
        
        if createTrackerController?.selectedCategory != categories[selectedCategory] {
            createTrackerController?.selectedCategory = categories[selectedCategory]
            createTrackerController?.tableSubnames[0] = categories[selectedCategory]
            createTrackerController?.setTableSubnames()
        }
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        configureLabel()
        configureButton()
        if categories.count == 0 {
            configureImage()
            configureImageLabel()
        }
        else {
            configureTable()
        }
    }
    
    private func configureLabel() {
        
        label.text = "Категория"
        label.textColor = UIColor(named: "MainForegroundColor")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureButton() {
        
        button.backgroundColor = UIColor(named: "MainForegroundColor")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(UIColor(named: "MainBackgroundColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func buttonTap() {
        let createCategoryController = CreateCategoryController()
        createCategoryController.categoryController = self
        present (createCategoryController, animated: true)
    }
    
    private func configureTable() {
        if !(view.contains(label) && view.contains(button)) {
            return
        }
        
        table.separatorStyle = .none
        table.backgroundColor = .clear
        
        table.dataSource = self
        table.delegate = self
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            table.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -47),
            table.heightAnchor.constraint(equalToConstant: 525)
        ])
    }
    
    func updateTable() {
        if view.contains(imageView) {
            removeImageAndLabel()
            configureTable()
        }
        table.reloadData()
    }
    
    private func removeTable() {
        if !(view.contains(table)) { return }
        
        table.removeFromSuperview()
    }
    
    private func configureImage() {
        imageView.image = UIImage(named: "TrackersViewImage")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureImageLabel() {
        if !view.subviews.contains(imageView) {
            return
        }
        
        imageLabel.text = "Привычки и события можно объединить по смыслу"
        imageLabel.font = UIFont.systemFont(ofSize: 12)
        imageLabel.textColor = UIColor(named: "MainForegroundColor")
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageLabel)
        
        NSLayoutConstraint.activate([
            imageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func removeImageAndLabel() {
        if !(view.contains(imageView) && view.contains(imageLabel)) { return }
        
        imageView.removeFromSuperview()
        imageLabel.removeFromSuperview()
    }
    
}


// MARK: UITableView extensions

extension CategoryController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "categoryCell")
        cell.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        cell.selectionStyle = .none
        
        cell.textLabel?.text = categories[indexPath.row]
        
        let accessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: table.frame.width - cell.contentView.frame.width, height: 15))
        accessoryView.contentMode = .scaleAspectFit
        cell.accessoryView = accessoryView
        
        if indexPath.row == selectedCategory {
            let checkmarkView = cell.accessoryView as? UIImageView
            checkmarkView?.image =  UIImage(systemName: "checkmark")
            checkmarkView?.tintColor = UIColor(named: "#3771E7")
        }
        
        if categories.count > 1{
            if indexPath.row == 0 {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.layer.masksToBounds = true
            }
            if indexPath.row == categories.count - 1 {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.layer.masksToBounds = true
            }
            if indexPath.row != 0 {
                cell.addSeperator(accessoryWidth: cell.accessoryView?.frame.width) //пофиксить
            }
        }
        else {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
        }
        
        return cell
    }
    
}

extension CategoryController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        tableView.cellForRow(at: indexPath)?.deleteSeperator()
        
        let editAction = UIAction(title: "Редактировать") { [weak self] _ in
            self?.editItem(at: indexPath)
        }
        
        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            self?.deleteItem(at: indexPath)
        }
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [editAction, deleteAction])
        }
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        tableView.reloadData()
    }
    
    func editItem(at indexPath: IndexPath) {
        let createCategoryController = CreateCategoryController()
        createCategoryController.categoryController = self
        createCategoryController.textField.text = categories[indexPath.row]
        createCategoryController.editingIndex = indexPath.row
        present (createCategoryController, animated: true)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let deleteConfirmationAlert = UIAlertController(title: "Эта категория точно не нужна?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            
            if indexPath.row == self.selectedCategory {
                self.selectedCategory = nil
                self.createTrackerController?.selectedCategory = nil
                self.createTrackerController?.tableSubnames[0] = ""
                self.createTrackerController?.setTableSubnames()
            }
            else {
                if indexPath.row < (self.selectedCategory ?? 0) {
                    self.selectedCategory = (self.selectedCategory ?? 1) - 1
                }
            }
            
            self.categories.remove(at: indexPath.row)
            self.createTrackerController?.trackerView?.categories.remove(at: indexPath.row)
            
            self.table.reloadData()
            if self.categories.count == 0 {
                self.removeTable()
                self.configureImage()
                self.configureImageLabel()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in }
        
        deleteConfirmationAlert.addAction(deleteAction)
        deleteConfirmationAlert.addAction(cancelAction)
        
        present(deleteConfirmationAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let selectedBeforeCell = tableView.cellForRow(at: IndexPath(row: selectedCategory ?? 0, section: 0)) else { return }
        
        (selectedBeforeCell.accessoryView as? UIImageView)?.image = nil
        
        selectedCategory = indexPath.row
        createTrackerController?.selectedCategory = cell.textLabel?.text
        createTrackerController?.tableSubnames[0] = cell.textLabel?.text ?? ""
        createTrackerController?.setTableSubnames()
        
        dismiss(animated: true)
    }
    
}
