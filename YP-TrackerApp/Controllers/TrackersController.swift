//
//  TrackersController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.04.2023.
//

import UIKit

class TrackersController: UIViewController {
    
    let button = UIButton()
    let label = UILabel()
    let datePicker = UIDatePicker()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        configureButton()
        configureLabel()
        configureDatePicker()
        configureSearchTextField()
    }
    
    func configureButton() {
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)), for: .normal)
        button.tintColor = UIColor(named: "ViewForegroundColor")
        button.addTarget(self, action: #selector(newTracker), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 42),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    func configureLabel() {
        if !view.subviews.contains(button) {
            return
        }
        
        label.text = "Трекеры"
        label.textColor = UIColor(named: "ViewForegroundColor")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: button.safeAreaLayoutGuide.bottomAnchor, constant: 1)
        ])
    }
    
    func configureDatePicker() {
        if !view.subviews.contains(label) {
            return
        }
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        // Устанавливаем цвет фона подложки выбранной даты
        datePicker.backgroundColor = UIColor(named: "DatePickerBackgroundColor")
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        
        // Измененяем цвет текста
        (datePicker.subviews[0].subviews[0].subviews[1].subviews.first as? UILabel)?.textColor = UIColor(named: "DatePickerTextColor")

        // Также добавляем изменение цвета текста на момент, когда календарь открывается и закрывается, потому что лейбл отрисовывается заново с начальными параметрами
        datePicker.addTarget(self, action: #selector(calendarOpenedClosed), for: .editingDidBegin)
        datePicker.addTarget(self, action: #selector(calendarOpenedClosed), for: .editingDidEnd)

        datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 110),
            
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
    
    func configureSearchTextField() {
        if !view.subviews.contains(label) {
            return
        }
        
        // Зададим стиль в котором нет фона
        searchBar.searchBarStyle = .minimal
        
        // Настроим цвет картинки внутри поля поиска
        let searchBarImage = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor(named: "SearchBarColor") ?? UIColor.gray,
                                                                                   renderingMode: .alwaysOriginal)
        searchBar.setImage(searchBarImage,
                           for: .search,
                           state: .normal)
        
        // Уберём кнопку очистки текста внутри поля поиска
        searchBar.searchTextField.clearButtonMode = .never
        
        // Настроим плейсхолдер
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SearchBarColor") ?? UIColor.gray,
                                                                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        
        searchBar.delegate = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            searchBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            
        ])
    }
    
    @objc func newTracker() {
        
    }
    
    @objc func selectDate() {
        
    }
    
    @objc func calendarOpenedClosed() {
        (datePicker.subviews[0].subviews[0].subviews[1].subviews.first as? UILabel)?.textColor = UIColor(named: "DatePickerTextColor")
    }
}

extension TrackersController: UISearchBarDelegate {
    
    // Вызывается каждый раз, когда пользователь изменяет текст
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Показываем и убираем кнопку отмены
        let searchText = (searchBar.text as NSString?)?.replacingCharacters(in: range, with: text) ?? ""
        searchBar.showsCancelButton = !searchText.isEmpty
        
    
        return true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Очищаем текст в поисковой строке
        searchBar.text = nil
        
        // Скрываем клавиатуру
        searchBar.resignFirstResponder()
        
        // Скрываем кнопку отмены
        searchBar.showsCancelButton = false
    }
    
    // Скрываем клавиатуру при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Вызывается при нажатии на кнопку "Найти"
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Скрываем клавиатуру
        searchBar.resignFirstResponder()
    }
}
