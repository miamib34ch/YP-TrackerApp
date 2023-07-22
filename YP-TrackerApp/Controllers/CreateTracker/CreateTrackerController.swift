//
//  CreateTrackerController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 03.05.2023.
//

import UIKit

protocol CreateTrackerDelegate: AnyObject {
    var createTrackerController: CreateTrackerProtocol? { get set }
}

protocol CreateTrackerProtocol {
    var trackerView: TrackersViewProtocol? { get set }
    var tracker: Tracker? { get set }
    var trackerTypeView: TrackerTypeController? { get set }
    var mainLabel: UILabel { get }
    var tableHeight: CGFloat { get set }
    var tableNumberRawsInSections: Int { get set }
    var selectedShedule: [Bool] { get set }
    var selectedCategory: String? { get set }
    var tableSubnames: [String] { get set }
    var selectedEmoji: String? { get set }
    var selectedColor: UIColor? { get set }
    var textField: MyTextField { get }

    func setTableSubnames()
}

final class CreateTrackerController: UIViewController, CreateTrackerProtocol {

    var trackerTypeView: TrackerTypeController?
    var trackerView: TrackersViewProtocol?
    var tracker: Tracker?

    private let scrollView = UIScrollView()
    let mainLabel = UILabel()
    let textField = MyTextField()
    private let cancelButton = UIButton()
    private let createButton = UIButton()

    private let warningLabel = UILabel()
    private var topConstraints: [NSLayoutConstraint] = []

    private var textFieldState = false

    private let table = UITableView()
    var tableHeight: CGFloat = 150
    var tableNumberRawsInSections = 2
    private let tableNames = ["Категория", "Расписание"]
    var tableSubnames = ["", ""]

    private let dataProvider = DataProvider.shared

    private let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let sectionNames = ["Emoji", "Цвет"]
    private let emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    private let colors = {
        let baseColorName = "Color "
        var colorStringArray: [String] = []
        (0...17).forEach { colorStringArray.append(baseColorName + String($0)) }
        var colorsUIArray: [UIColor] = []
        colorStringArray.forEach { colorsUIArray.append(UIColor(named: $0) ?? .gray) }
        return colorsUIArray
    }()
    private let selectedBackgroundViewForEmoji: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    private let selectedBackgroundViewForColor: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.layer.masksToBounds = true
        return view
    }()

    var selectedEmoji: String?
    var selectedColor: UIColor?
    var selectedShedule = [Bool](repeating: false, count: 7)
    var selectedCategory: String?
    var beforeSelectedCategory: String?
    var isSectionSelected: [Bool] = [false, false]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        configureLabel()
        configureTextField()
        configureTable()
        configureScrollView()
        configureEmojiCollection()
        configureColorCollection()
        configureButtons()
        
        if let tracker = tracker {
            textField.text = tracker.name
            textFieldState = true
            tableSubnames[0] = selectedCategory ?? ""
            beforeSelectedCategory = selectedCategory
            selectedShedule = tracker.shedule
            tableSubnames [1] = createSubname()
            selectedEmoji = tracker.emoji
            selectedColor = tracker.color
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if tracker != nil {
            let emojiCell = emojiCollectionView.cellForItem(at: IndexPath(row: emojies.firstIndex(of: selectedEmoji ?? "") ?? 0, section: 0))
            emojiCell?.isSelected = true
            (emojiCell as? EmojiAndColorCell)?.selectedBackgroundView = selectedBackgroundViewForEmoji
            
            let marshalling = UIColorMarshalling()
            var index = 0
            var selectedColorIndex = 0
            for color in colors {
                if marshalling.hexString(from: color) == marshalling.hexString(from: selectedColor ?? UIColor()) {
                    selectedColorIndex = index
                }
                index += 1
            }
            
            let colorCell = colorCollectionView.cellForItem(at: IndexPath(row: selectedColorIndex, section: 0))
            
            selectedBackgroundViewForColor.layer.borderColor = colors[selectedColorIndex].cgColor.copy(alpha: 0.3)
            colorCell?.selectedBackgroundView = selectedBackgroundViewForColor
            colorCell?.isSelected = true
            
            shouldCreationButtonBeActive()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if tracker != nil {
            trackerView?.datePickerBackgroundView.backgroundColor = UIColor(named: "#F0F0F0")
            trackerView?.updateVisibleCategories()
            trackerView?.updateCollection()
        }
    }

    // Скрываем клавиатуру при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func configureLabel() {
        mainLabel.textColor = UIColor(named: "MainForegroundColor")
        mainLabel.font = UIFont.systemFont(ofSize: 16)
        mainLabel.textAlignment = .center

        mainLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainLabel)

        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 16),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureTextField() {
        if !view.contains(mainLabel) { return }

        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "#AEAFB4") ?? UIColor.gray]
        )
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        textField.clearButtonMode = .whileEditing

        textField.delegate = self

        textField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }

    private func configureWarningLabel() {
        if !view.contains(textField) { return }

        warningLabel.text = "Ограничение 38 символов"
        warningLabel.textColor = UIColor(named: "#F56B6C")
        warningLabel.font = UIFont.systemFont(ofSize: 17)
        warningLabel.textAlignment = .center

        warningLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(warningLabel)

        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureTable() {
        if !view.contains(textField) { return }

        table.separatorStyle = .none

        table.dataSource = self
        table.delegate = self

        table.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(table)

        topConstraints.append(table.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24))

        NSLayoutConstraint.activate([
            topConstraints[0],
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.heightAnchor.constraint(equalToConstant: tableHeight)
        ])
    }

    func setTableSubnames() {
        table.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = tableSubnames[0]
        table.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = tableSubnames[1]
        shouldCreationButtonBeActive()
    }

    private func configureScrollView() {
        if !view.contains(table) { return }

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 32),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureEmojiCollection() {
        if  !view.contains(scrollView) { return }

        emojiCollectionView.backgroundColor = .clear

        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self

        emojiCollectionView.register(EmojiAndColorCell.self,
                                     forCellWithReuseIdentifier: "emojiAndColorCells")
        emojiCollectionView.register(SupplementaryView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")

        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(emojiCollectionView)

        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            emojiCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }

    private func configureColorCollection() {
        if  !view.contains(scrollView) && !view.contains(emojiCollectionView) { return }

        colorCollectionView.backgroundColor = .clear

        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self

        colorCollectionView.register(EmojiAndColorCell.self,
                                     forCellWithReuseIdentifier: "emojiAndColorCells")
        colorCollectionView.register(SupplementaryView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")

        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(colorCollectionView)

        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 0),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }

    private func addWarningLabel() {
        topConstraints.forEach { $0.constant += 38 }
        configureWarningLabel()
    }

    private func deleteWarningLabel() {
        topConstraints.forEach { $0.constant -= 38 }
        warningLabel.removeFromSuperview()
    }

    private func configureButtons() {
        if  !view.contains(scrollView) { return }

        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true

        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "#F56B6C"), for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "#F56B6C")?.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        createButton.isEnabled = false

        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true

        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = UIColor(named: "#AEAFB4")
        createButton.addTarget(self, action: #selector(createButtonTap), for: .touchUpInside)

        createButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func shouldCreationButtonBeActive() {
        if textFieldState &&
            selectedCategory != nil &&
            (selectedShedule.contains(true) || tableNumberRawsInSections == 1) &&
            selectedColor != nil &&
            selectedEmoji != nil {
            createButton.isEnabled = true
            createButton.setTitleColor(UIColor(named: "MainBackgroundColor"), for: .normal)
            createButton.backgroundColor = UIColor(named: "MainForegroundColor")
        } else {
            createButton.isEnabled = false
            createButton.setTitleColor(.white, for: .normal)
            createButton.backgroundColor = UIColor(named: "#AEAFB4")
        }
    }

    @objc private func cancelButtonTap() {
        dismiss(animated: true)
    }

    @objc private func createButtonTap() {
        
        if let tracker = tracker {
            let newTracker = Tracker(idTracker: tracker.idTracker,
                                     name: textField.text ?? "",
                                     color: selectedColor ?? .black,
                                     emoji: selectedEmoji ?? "",
                                     shedule: selectedShedule,
                                     fixed: tracker.fixed)
            
            let newCategory = TrackerCategory(name: selectedCategory ?? "", trackers: [])
            let oldCategory = trackerView?.categories.first(where: {$0.name == beforeSelectedCategory}) ?? TrackerCategory(name: "", trackers: [])

            dataProvider.editTracker(tracker: newTracker, oldCategory: oldCategory, newCategory: newCategory)
            trackerView?.categories = dataProvider.takeCategories()
            dismiss(animated: true)
        } else {
            var updatedCategories: [TrackerCategory] = []
            let categories = trackerView?.categories ?? [TrackerCategory]()
            for categorie in categories {
                if categorie.name == selectedCategory {
                    var trackers = categorie.trackers
                    if tableNumberRawsInSections == 1 {
                        selectedShedule = [Bool](repeating: true, count: 7)
                    }
                   
                        let newTracker = Tracker(idTracker: UUID(),
                                                 name: textField.text ?? "",
                                                 color: selectedColor ?? .black,
                                                 emoji: selectedEmoji ?? "",
                                                 shedule: selectedShedule,
                                                 fixed: false)
                        trackers.append(newTracker)
                        let newCategory = TrackerCategory(name: selectedCategory ?? "", trackers: trackers)
                        updatedCategories.append(newCategory)
                        dataProvider.addTracker(tracker: newTracker, category: newCategory)
                    
                } else {
                    updatedCategories.append(categorie)
                }
            }
            trackerView?.categories = updatedCategories
            dismiss(animated: true)
            trackerTypeView?.dismiss(animated: true)
        }
    }

    private func createSubname() -> String {
        let indices = selectedShedule.indices
        var days: [String] = []
        for index in indices where selectedShedule[index] == true {
            switch index {
            case 0:
                days.append("Пн")
            case 1:
                days.append("Вт")
            case 2:
                days.append("Ср")
            case 3:
                days.append("Чт")
            case 4:
                days.append("Пт")
            case 5:
                days.append("Сб")
            case 6:
                days.append("Вс")
            default:
                break
            }
        }
        if days.count == 7 {
            return "Каждый день"
        } else {
            var subname = ""
            for day in days {
                subname += day
                if day != days[days.count - 1] {
                    subname += ", "
                }
            }
            return subname
        }
    }

}

// MARK: UITextField extension

extension CreateTrackerController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let isLessThan39 = updatedText.count <= 38
        if isLessThan39 {
            if view.contains(warningLabel) {
                deleteWarningLabel()
            }
        } else {
            if !view.contains(warningLabel) {
                addWarningLabel()
            }
        }

        let isLessThan1 = updatedText.count < 1
        if isLessThan1 {
            textFieldState = false
        } else {
            textFieldState = true
        }
        shouldCreationButtonBeActive()
        return isLessThan39
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if view.contains(warningLabel) {
            deleteWarningLabel()
        }
        textFieldState = false
        shouldCreationButtonBeActive()
        return true
    }

}

// MARK: UITableView extensions

extension CreateTrackerController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = tableNames[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.textColor = UIColor(named: "MainForegroundColor")

        cell.detailTextLabel?.text = tableSubnames[indexPath.row]
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.textColor = UIColor(named: "#AEAFB4")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let categoryController = CategoryController()
            categoryController.createTrackerController = self
            present(categoryController, animated: true)
        case 1:
            let scheduleController = ScheduleController()
            scheduleController.createTrackerController = self
            present(scheduleController, animated: true)
        default:
            break
        }
    }

}

extension CreateTrackerController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNumberRawsInSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        cell.selectionStyle = .none

        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: table.frame.width - cell.contentView.frame.width,
                                            height: 15))
        button.setImage( UIImage(systemName: "chevron.right")?.withTintColor(UIColor(named: "#AEAFB4") ?? .gray).withRenderingMode(.alwaysOriginal), for: .normal)
        cell.accessoryView = .some(button)

        if tableNumberRawsInSections > 1 {
            if indexPath.row == 0 {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.layer.masksToBounds = true
            }
            if indexPath.row == tableNumberRawsInSections - 1 {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.layer.masksToBounds = true
            }
            if indexPath.row != 0 {
                cell.addSeperator(accessoryWidth: cell.accessoryView?.frame.width)
            }
        } else {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
        }
        return cell
    }

}

// MARK: UICollectionView extensions

extension CreateTrackerController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "header",
                                                                             for: indexPath) as? SupplementaryView
            guard let headerView = headerView else { return SupplementaryView() }
            var headerViewText = ""
            switch collectionView {
            case emojiCollectionView:
                headerViewText = sectionNames[0]
            case colorCollectionView:
                headerViewText = sectionNames[1]
            default:
                break
            }

            headerView.setLabel(text: headerViewText,
                                textAlignment: .left,
                                textColor: UIColor(named: "MainForegroundColor"),
                                font: UIFont.systemFont(ofSize: 19, weight: .bold))
            return headerView
        }
        return UICollectionReusableView()
    }

    // Метод, который вызывается, когда нажимают на другую ячейку, при условии, что одна уже была выбрана
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.selectedBackgroundView = nil
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        if cell.selectedBackgroundView != nil {
            cell.selectedBackgroundView = nil
            switch collectionView {
            case emojiCollectionView:
                selectedEmoji = nil
            default:
                selectedColor = nil
            }
        } else {
            switch collectionView {
            case emojiCollectionView:
                cell.selectedBackgroundView = selectedBackgroundViewForEmoji
                selectedEmoji = emojies[indexPath.row]
            case colorCollectionView:
                selectedBackgroundViewForColor.layer.borderColor = colors[indexPath.row].cgColor.copy(alpha: 0.3)
                cell.selectedBackgroundView = selectedBackgroundViewForColor
                selectedColor = colors[indexPath.row]
            default:
                break
            }
        }
        shouldCreationButtonBeActive()
    }

}

extension CreateTrackerController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case emojiCollectionView:
            return emojies.count
        case colorCollectionView:
            return colors.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColorCells",
                                                      for: indexPath) as? EmojiAndColorCell

        switch collectionView {
        case emojiCollectionView:
            cell?.setLabel(text: emojies[indexPath.row])
        case colorCollectionView:
            cell?.setLabel(color: colors[indexPath.row])
        default:
            break
        }

        return cell ?? UICollectionViewCell()
    }

}
