//
//  TrackersController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 26.04.2023.
//

import UIKit

protocol TrackersViewProtocol {
    var categories: [TrackerCategory] { get set }
    var datePickerBackgroundView: UIView { get }
    var visibleCategories: [TrackerCategory] { get set}
    var completedTrackers: Set<TrackerRecord> { get set }

    func updateCollection()
    func updateVisibleCategories()
}

final class TrackersViewController: UIViewController, TrackersViewProtocol, TrackerCellDelegate, DataProviderDelegate {

    private let addTrackerButton = UIButton()
    private let mainLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let searchBar = UISearchBar()
    private let imageView = UIImageView()
    private let imageLabel = UILabel()
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let filtersButton = UIButton()

    private let dataProvider = DataProvider.shared
    lazy var categories: [TrackerCategory] = dataProvider.takeCategories()
    lazy var completedTrackers = dataProvider.takeRecords()
    private var currentDate: Date = Date()
    var visibleCategories: [TrackerCategory] = []

    var datePickerBackgroundView: UIView {
        return datePicker.subviews[0].subviews[0].subviews[0]
    }
    private var datePickerTextLabel: UILabel? {
        return datePicker.subviews[0].subviews[0].subviews[1].subviews.first as? UILabel
    }

    private let weekDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ru")
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        currentDate = Calendar.current.startOfDay(for: datePicker.date)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Меняем цвет фона datePicker, поскольку каждый раз при открытии вью он отрисовывается с параметрами по-умолчанию
        // Метод выбран, потому что вью уже отрисовано и можно менять цвет
        datePickerBackgroundView.backgroundColor = UIColor(named: "#F0F0F0")
    }

    // Скрываем клавиатуру при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func configureView() {
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        configureAddTrackerButton()
        configureMainLabel()
        configureDatePicker()
        configureSearchTextField()

        updateVisibleCategories()
        if visibleCategories.count == 0 {
            configureImage()
            configureImageLabel()
        } else {
            configureCollection()
            configureFiltersButton()
        }
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
        if !view.subviews.contains(imageView) { return }

        imageLabel.text = NSLocalizedString("noTrackersLabel", comment: "Надпись заглушки, когда трекеры не созданы")
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

    private func configureAddTrackerButton() {
        addTrackerButton.setImage(UIImage(systemName: "plus",
                                          withConfiguration: UIImage.SymbolConfiguration(pointSize: 16,
                                                                                         weight: .bold,
                                                                                         scale: .large)),
                                  for: .normal)
        addTrackerButton.tintColor = UIColor(named: "MainForegroundColor")
        addTrackerButton.addTarget(self, action: #selector(newTracker), for: .touchUpInside)

        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addTrackerButton)

        NSLayoutConstraint.activate([
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),

            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func configureMainLabel() {
        if !view.subviews.contains(addTrackerButton) { return }

        mainLabel.text = NSLocalizedString("trackerViewMainLabel", comment: "Главная надпись на экране трекеров")
        mainLabel.textColor = UIColor(named: "MainForegroundColor")
        mainLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainLabel)

        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainLabel.topAnchor.constraint(equalTo: addTrackerButton.safeAreaLayoutGuide.bottomAnchor, constant: 1)
        ])
    }

    private func configureDatePicker() {
        if !view.subviews.contains(mainLabel) { return }

        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date

        datePickerBackgroundView.backgroundColor = UIColor(named: "#F0F0F0")

        datePickerTextLabel?.textColor = UIColor(named: "#1A1B22")

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

    private func configureSearchTextField() {
        if !view.subviews.contains(mainLabel) { return }

        // Зададим стиль в котором нет фона
        searchBar.searchBarStyle = .minimal

        // Настроим цвет картинки внутри поля поиска
        let searchBarImage = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor(named: "#AEAFB4") ?? UIColor.gray,
                                                                                   renderingMode: .alwaysOriginal)
        searchBar.setImage(searchBarImage,
                           for: .search,
                           state: .normal)

        searchBar.searchTextField.clearButtonMode = .never
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("search", comment: "Плейсхолдер в строке поиска"),
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SearchBarColor") ?? UIColor.gray,
                                                                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        searchBar.returnKeyType = .go

        searchBar.delegate = self

        searchBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }

    private func configureCollection() {
        if !view.subviews.contains(searchBar) { return }

        collection.backgroundColor = .clear

        collection.dataSource = self
        collection.delegate = self

        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "trackerCells")
        collection.register(SupplementaryView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "header")

        collection.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collection)

        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func updateCollection() {
        if !visibleCategories.isEmpty {
            if contains(imageView) && contains(imageLabel) {
                removeImageAndLabel()
                configureCollection()
                configureFiltersButton()
            }
            collection.reloadData()
        } else {
            removeCollection()
            removeFiltersButton()
            configureImage()
            configureImageLabel()
            if currentDate != Calendar.current.startOfDay(for: Date()) || !(searchBar.text ?? "").isEmpty {
                imageView.image = UIImage(named: "NothingFound")
                imageLabel.text = NSLocalizedString("notFoundLabel", comment: "Надпись плейсхолдера, когда после фильтрации ничего не найдено")
            }
        }
    }

    private func removeCollection() {
        if !(view.contains(collection)) { return }
        collection.removeFromSuperview()
    }

    private func configureFiltersButton() {
        if !view.subviews.contains(collection) { return }

        filtersButton.backgroundColor = UIColor(named: "#3772E7")
        filtersButton.setTitle(NSLocalizedString("filterButton", comment: "Надпись на кнопке фильра"), for: .normal)
        filtersButton.setTitleColor(.white, for: .normal)
        filtersButton.titleLabel?.textAlignment = .center
        filtersButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)

        filtersButton.layer.cornerRadius = 16
        filtersButton.layer.masksToBounds = true

        filtersButton.addTarget(self, action: #selector(filterButtonTap), for: .touchUpInside)

        filtersButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(filtersButton)

        NSLayoutConstraint.activate([
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.304),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func removeFiltersButton() {
        if !(view.contains(filtersButton)) { return }
        filtersButton.removeFromSuperview()
    }

    func updateVisibleCategories() {
        visibleCategories = []
        for category in categories where !category.trackers.isEmpty {
            var trackers: [Tracker] = []

            for tracker in category.trackers {
                if tracker.shedule[0] == true && weekDayDateFormatter.string(from: currentDate) == "понедельник" {
                    trackers.append(tracker)
                }
                if tracker.shedule[1] == true && weekDayDateFormatter.string(from: currentDate) == "вторник" {
                    trackers.append(tracker)
                }
                if tracker.shedule[2] == true && weekDayDateFormatter.string(from: currentDate) == "среда" {
                    trackers.append(tracker)
                }
                if tracker.shedule[3] == true && weekDayDateFormatter.string(from: currentDate) == "четверг" {
                    trackers.append(tracker)
                }
                if tracker.shedule[4] == true && weekDayDateFormatter.string(from: currentDate) == "пятница" {
                    trackers.append(tracker)
                }
                if tracker.shedule[5] == true && weekDayDateFormatter.string(from: currentDate) == "суббота" {
                    trackers.append(tracker)
                }
                if tracker.shedule[6] == true && weekDayDateFormatter.string(from: currentDate) == "воскресенье" {
                    trackers.append(tracker)
                }
            }

            if !trackers.isEmpty {
                let newCategory = TrackerCategory(name: category.name, trackers: trackers)
                visibleCategories.append(newCategory)
            }
        }
    }

    func trackerCellDidTapButton(_ cell: TrackerCell) {
        if currentDate <= Calendar.current.startOfDay(for: Date()) {
            if isCompletedOnCurrentDate(cell.trackerID) {
                deleteTrackerRecord(for: cell.trackerID)
                reload(cell)
            } else {
                saveTrackerRecord(for: cell.trackerID)
                reload(cell)
            }
        }
    }

    private func saveTrackerRecord(for trackerID: UUID) {
        let trackerRecord = TrackerRecord(idTracker: trackerID, date: currentDate)
        completedTrackers.insert(trackerRecord)
        dataProvider.createRecord(id: trackerID, date: currentDate)
    }

    private func deleteTrackerRecord(for trackerID: UUID) {
        let trackerRecord = TrackerRecord(idTracker: trackerID, date: currentDate)
        completedTrackers.remove(trackerRecord)
        dataProvider.deleteRecord(id: trackerID, date: currentDate)
    }

    private func reload(_ cell: TrackerCell) {
        guard let indexPath = collection.indexPath(for: cell) else { return }
        collection.reloadItems(at: [indexPath])
    }

    private func isCompletedOnCurrentDate(_ trackerID: UUID) -> Bool {
        return completedTrackers.contains(TrackerRecord(idTracker: trackerID, date: currentDate))
    }

    @objc private  func calendarOpenedClosed() {
        // Меняем цвет текста datePicker, поскольку каждый раз при открытии и закрытии календаря он отрисовывается с параметрами по-умолчанию
        datePickerTextLabel?.textColor = UIColor(named: "#1A1B22")
    }

    @objc private func selectDate() {
        currentDate = Calendar.current.startOfDay(for: datePicker.date)
        updateVisibleCategories()
        updateCollection()
    }

    @objc private func newTracker() {
        let trackerTypeController = TrackerTypeController()
        trackerTypeController.trackerView = self
        present(trackerTypeController, animated: true)
    }

    @objc private func filterButtonTap() {

    }

}

// MARK: UISearchBar extension

extension TrackersViewController: UISearchBarDelegate {

    // Вызывается каждый раз, когда пользователь изменяет текст
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Показываем и убираем кнопку отмены
        let searchText = (searchBar.text as NSString?)?.replacingCharacters(in: range, with: text) ?? ""
        searchBar.showsCancelButton = !searchText.isEmpty

        if searchText.isEmpty {
            updateVisibleCategories()
            updateCollection()
        }

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

        updateVisibleCategories()
        updateCollection()
    }

    // Вызывается при нажатии на кнопку "Найти"
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Скрываем клавиатуру
        searchBar.resignFirstResponder()

        updateVisibleCategories() // Все категории в visibleCategories по выбранной дате
        let filterText = (searchBar.text ?? "").lowercased()
        var newVisibleCategories: [TrackerCategory] = []
        var newCategory: [Tracker] = []

        for category in visibleCategories {
            for tracker in category.trackers where tracker.name.lowercased().contains(filterText) {
                newCategory.append(tracker)
            }
            if !newCategory.isEmpty {
                newVisibleCategories.append(TrackerCategory(name: category.name, trackers: newCategory))
            }
            newCategory = []
        }

        visibleCategories = newVisibleCategories
        updateCollection()
    }

}

// MARK: UICollectionView extension

extension TrackersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 41) / 2, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "header",
                                                                             for: indexPath) as? SupplementaryView
            guard let headerView = headerView else { return SupplementaryView() }
            headerView.setLabel(text: visibleCategories[indexPath.section].name,
                                textAlignment: .left,
                                textColor: UIColor(named: "MainForegroundColor"),
                                font: UIFont.systemFont(ofSize: 19, weight: .bold))
            return headerView
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return UIContextMenuConfiguration() }
        guard let fixed = (collectionView.cellForItem(at: indexPath) as? TrackerCell)?.fixed else { return UIContextMenuConfiguration() }
        var fixActionTitle = ""
        switch fixed {
        case true:
            fixActionTitle = NSLocalizedString("unfixTracker", comment: "Контекстное меню: открепление трекера")
        case false:
            fixActionTitle = NSLocalizedString("fixTracker", comment: "Контекстное меню: закрепление трекера")
        }
        let fixAction = UIAction(title: fixActionTitle) { [weak self] _ in
            self?.fixItem(at: indexPath, state: fixed)
        }
        let editAction = UIAction(title: NSLocalizedString("editTracker", comment: "Контекстное меню: редактирование трекера")) { [weak self] _ in
            self?.editItem(at: indexPath)
        }
        let deleteAction = UIAction(title: NSLocalizedString("deleteTracker", comment: "Контекстное меню: удаление трекера"), attributes: .destructive) { [weak self] _ in
            self?.deleteItem(at: indexPath)
        }

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [fixAction, editAction, deleteAction])
        }
        return configuration
    }
    
    private func fixItem(at indexPath: IndexPath, state: Bool) {
        let item = collection.cellForItem(at: indexPath) as? TrackerCell
        switch state {
        case true:
            item?.fixed = false
        case false:
            item?.fixed = true
        }
    }
    
    private func editItem(at indexPath: IndexPath) {
        guard let item = collection.cellForItem(at: indexPath) as? TrackerCell else { return }
        let createTrackerController = CreateTrackerController()
        createTrackerController.trackerView = self
        createTrackerController.mainLabel.text = "Редактирование привычки"
        createTrackerController.tracker = dataProvider.findTracker(id: item.trackerID)
        createTrackerController.selectedCategory = categories[indexPath.section].name
        present (createTrackerController, animated: true)
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let deleteConfirmationAlert = UIAlertController(title: NSLocalizedString("questionBeforeDelete", comment: "Надпись уточняющая удаление трекера"),
                                                        message: nil,
                                                        preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: NSLocalizedString("deleteTracker", comment: "Контекстное меню: удаление трекера"), style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            guard let item = self.collection.cellForItem(at: indexPath) as? TrackerCell else { return }
            
            self.dataProvider.deleteTracker(id: item.trackerID)
            self.categories = self.dataProvider.takeCategories()
            self.updateVisibleCategories()
            self.updateCollection()
            self.datePickerBackgroundView.backgroundColor = UIColor(named: "#F0F0F0")
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "Отмена действия"), style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.datePickerBackgroundView.backgroundColor = UIColor(named: "#F0F0F0")
        }

        deleteConfirmationAlert.addAction(deleteAction)
        deleteConfirmationAlert.addAction(cancelAction)
        present(deleteConfirmationAlert, animated: true, completion: nil)
    }

}

extension TrackersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "trackerCells",
                                                        for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.configureCell(with: tracker)
        let dayCounter = completedTrackers.filter { $0.idTracker == tracker.idTracker }.count
        cell.setDayCounterLabel(with: dayCounter)
        if isCompletedOnCurrentDate(tracker.idTracker) {
            cell.buttonSetCheckmark()
        } else {
            cell.buttonSetPlus()
        }
        cell.delegate = self
        return cell
    }

}
