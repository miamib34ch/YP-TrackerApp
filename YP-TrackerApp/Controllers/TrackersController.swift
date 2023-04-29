//
//  TrackersController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.04.2023.
//

import UIKit

class TrackersController: UIViewController {
    
    let button = UIButton()
    let mainLabel = UILabel()
    let datePicker = UIDatePicker()
    let searchBar = UISearchBar()
    
    let imageView = UIImageView()
    let imageLabel = UILabel()

    var datePickerBackgroundView: UIView {
        get { datePicker.subviews[0].subviews[0].subviews[0] }
    }
    var datePickerTextLabel: UILabel? {
        get { datePicker.subviews[0].subviews[0].subviews[1].subviews.first as? UILabel }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //меняем цвет фона datePicker, поскольку каждый раз при открытии вью он отрисовывается с параметрами по-умолчанию
        //метод выбран, потому что вью уже отрисовано и можно менять цвет
        datePickerBackgroundView.backgroundColor = UIColor(named: "DatePickerBackgroundColor")
    }
    
    
    func configureView() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        configureButton()
        configureMainLabel()
        configureDatePicker()
        configureSearchTextField()
        configureImage()
        configureImageLabel()
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
    
    func configureMainLabel() {
        if !view.subviews.contains(button) {
            return
        }
        
        mainLabel.text = "Трекеры"
        mainLabel.textColor = UIColor(named: "ViewForegroundColor")
        mainLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainLabel.topAnchor.constraint(equalTo: button.safeAreaLayoutGuide.bottomAnchor, constant: 1)
        ])
    }
    
    func configureDatePicker() {
        if !view.subviews.contains(mainLabel) {
            return
        }
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        // Устанавливаем цвет фона подложки выбранной даты
        datePickerBackgroundView.backgroundColor = UIColor(named: "DatePickerBackgroundColor")
        
        // Измененяем цвет текста
        datePickerTextLabel?.textColor = UIColor(named: "DatePickerTextColor")

        // Также добавляем изменение цвета текста на момент, когда календарь открывается и закрывается, потому что лейбл отрисовывается заново с начальными параметрами
        datePicker.addTarget(self, action: #selector(calendarOpenedClosed), for: .editingDidBegin)
        datePicker.addTarget(self, action: #selector(calendarOpenedClosed), for: .editingDidEnd)

        datePicker.addTarget(self, action: #selector(selectDate), for: .valueChanged)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 110),
            
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: mainLabel.centerYAnchor)
        ])
    }
    
    func configureSearchTextField() {
        if !view.subviews.contains(mainLabel) {
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
            
            searchBar.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            
        ])
    }
    
    func configureImage() {
        imageView.image = UIImage(named: "TrackersViewImage")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func configureImageLabel() {
        if !view.subviews.contains(imageView) {
            return
        }
        
        imageLabel.text = "Что будем отслеживать?"
        imageLabel.font = UIFont.systemFont(ofSize: 12)
        imageLabel.textColor = UIColor(named: "ViewForegroundColor")
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageLabel)
        
        NSLayoutConstraint.activate([
            imageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func newTracker() {
        
    }
    
    @objc func selectDate() {

    }
    
    @objc func calendarOpenedClosed() {
        //меняем цвет текста datePicker, поскольку каждый раз при открытии и закрытии календаря он отрисовывается с параметрами по-умолчанию
        datePickerTextLabel?.textColor = UIColor(named: "DatePickerTextColor")
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
    
    // Вызывается при нажатии на кнопку "Отмена"
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Очищаем текст в поисковой строке
        searchBar.text = nil
        
        // Скрываем клавиатуру
        searchBar.resignFirstResponder()
        
        // Скрываем кнопку отмены
        searchBar.showsCancelButton = false
    }
    
    // Вызывается при нажатии на кнопку "Найти"
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Скрываем клавиатуру
        searchBar.resignFirstResponder()
    }
    
    // Скрываем клавиатуру при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
