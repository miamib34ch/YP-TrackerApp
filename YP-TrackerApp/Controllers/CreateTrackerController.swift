//
//  CreateTrackerController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 03.05.2023.
//

import UIKit

protocol CreateTrackerDelegate {
    var createTrackerController: CreateTrackerProtocol? { get set }
}

protocol CreateTrackerProtocol {
    
    var trackerView: TrackersViewProtocol? { get set }
    var trackerTypeView: TrackerTypeController? { get set }
    var mainLabel: UILabel { get }
    var tableHeight: CGFloat { get set }
    var tableNumberRawsInSections: Int { get set }
    var selectedShedule: [Bool] { get set }
    var selectedCategory: String? { get set }
    var tableSubnames: [String] { get set }
    var selectedEmoji: String? { get set } // сделать его выбор при редактировании
    var selectedColor: UIColor? { get set } // сделать его выбор при редактировании
    var textField: MyTextField { get }
    
    func setTableSubnames()
    
}

final class CreateTrackerController: UIViewController, CreateTrackerProtocol {
    
    var trackerTypeView: TrackerTypeController?
    var trackerView: TrackersViewProtocol?
    
    private let scrollView = UIScrollView()
    let mainLabel = UILabel()
    let textField = MyTextField()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let warningLabel = UILabel()
    private var topConstraints: [NSLayoutConstraint] = []
    
    private let table = UITableView()
    var tableHeight: CGFloat = 150
    var tableNumberRawsInSections = 2
    private let tableNames = ["Категория", "Расписание"]
    var tableSubnames = ["",""]
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let sectionNames = ["Emoji", "Цвет"]
    private let emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    private lazy var colors = {
        let baseColorName = "Color "
        var colorStringArray: [String] = []
        (0...17).forEach { colorStringArray.append(baseColorName + String($0)) }
        var colorsUIArray: [UIColor] = []
        colorStringArray.forEach { colorsUIArray.append(UIColor(named: $0) ?? .gray) }
        return colorsUIArray
    }()
    private lazy var selectedBackgroundViewForEmoji: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var selectedBackgroundViewForColor: UIView = {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        configureScrollView()
        configureLabel()
        configureTextField()
        configureTable()
        configureCollection()
        configureButtons()
    }
    
    // Скрываем клавиатуру при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureLabel() {
        if (!view.contains(scrollView)) {
            return
        }
        
        mainLabel.textColor = UIColor(named: "MainForegroundColor")
        mainLabel.font = UIFont.systemFont(ofSize: 16)
        mainLabel.textAlignment = .center
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 27),
            mainLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 16),
            mainLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func configureTextField() {
        if (!(view.contains(scrollView) && scrollView.contains(mainLabel))) {
            return
        }
        
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
        
        scrollView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func configureWarningLabel() {
        if (!(view.contains(scrollView) && scrollView.contains(textField))) {
            return
        }
        
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.textColor = UIColor(named: "#F56B6C")
        warningLabel.font = UIFont.systemFont(ofSize: 17)
        warningLabel.textAlignment = .center
        
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    private func configureTable() {
        if (!(view.contains(scrollView) && scrollView.contains(textField))) {
            return
        }
        
        table.separatorStyle = .none
        
        table.dataSource = self
        table.delegate = self
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(table)
        
        topConstraints.append(table.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24))
        
        NSLayoutConstraint.activate([
            topConstraints[0],
            table.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            table.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            table.heightAnchor.constraint(equalToConstant: tableHeight)
        ])
    }
    
    private func configureCollection() {
        if (!(view.contains(scrollView) && scrollView.contains(table))) {
            return
        }
        
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "emojiAndColorCells")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 444)
        ])
    }
    
    private func addWarningLabel() {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + 16)
        topConstraints.forEach(){ $0.constant += 38 }
        configureWarningLabel()
    }
    
    private func deleteWarningLabel() {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height - 16)
        topConstraints.forEach(){ $0.constant -= 38 }
        warningLabel.removeFromSuperview()
    }
    
    private func configureButtons() {
        if (!(view.contains(scrollView) && scrollView.contains(collectionView))) { //поменять на коллекцию
            return
        }
        
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
        
        scrollView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = UIColor(named: "#AEAFB4")
        createButton.addTarget(self, action: #selector(createButtonTap), for: .touchUpInside)
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func cancelButtonTap() {
        dismiss(animated: true)
    }
    
    @objc func createButtonTap() {
        // сделать
        dismiss(animated: true)
        trackerTypeView?.dismiss(animated: true)
    }
    
    private func makeCreationButtonActive() {
        // сделать
    }
    
    private func makeCreationButtonNoActive() {
        // сделать
    }
    
    func setTableSubnames() {
        table.cellForRow(at: IndexPath(row: 0, section: 0))?.detailTextLabel?.text = tableSubnames[0]
        table.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = tableSubnames[1]
    }
    
}


// MARK: UITextField extension

extension CreateTrackerController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let isLessThan39 = updatedText.count <= 38
        if isLessThan39  {
            if (view.contains(warningLabel)) {
                deleteWarningLabel()
            }
        }
        else {
            if (!view.contains(warningLabel)) {
                addWarningLabel()
            }
        }
        
        if updatedText.count < 1 {
            makeCreationButtonNoActive()
        }
        else {
            makeCreationButtonActive()
        }
        
        return isLessThan39
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if (view.contains(warningLabel)) {
            deleteWarningLabel()
        }
        
        makeCreationButtonNoActive()
        
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
            var categoryController = CategoryController()
            categoryController.createTrackerController = self
            present(categoryController, animated: true)
        case 1:
            var scheduleController = ScheduleController()
            scheduleController.createTrackerController = self
            present(scheduleController, animated: true)
        default:
            break
        }
    }
    
}

extension CreateTrackerController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableNumberRawsInSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        cell.selectionStyle = .none
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: table.frame.width - cell.contentView.frame.width, height: 15))
        button.setImage( UIImage(systemName: "chevron.right")?.withTintColor(UIColor(named: "#AEAFB4") ?? .gray).withRenderingMode(.alwaysOriginal), for: .normal)
        cell.accessoryView = .some(button)
        
        if (tableNumberRawsInSections > 1) {
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
        }
        else {
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
        }
        
        return cell
    }
    
}


// MARK: UICollectionView extensions

extension CreateTrackerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SupplementaryView
            
            headerView.titleLabel.text = sectionNames[indexPath.section]
            headerView.titleLabel.textAlignment = .left
            headerView.titleLabel.textColor = UIColor(named: "MainForegroundColor")
            headerView.titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        switch indexPath.section {
        case 0:
            cell.selectedBackgroundView = selectedBackgroundViewForEmoji
            selectedEmoji = emojies[indexPath.row]
        case 1:
            selectedBackgroundViewForColor.layer.borderColor = colors[indexPath.row].cgColor.copy(alpha: 0.3)
            cell.selectedBackgroundView = selectedBackgroundViewForColor
            selectedColor = colors[indexPath.row]
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.selectedBackgroundView = nil
    }
    
}

extension CreateTrackerController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojies.count
        case 1:
            return colors.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColorCells", for: indexPath) as? EmojiAndColorCell
        
        switch indexPath.section {
        case 0:
            cell?.setLabel(text: emojies[indexPath.row])
        case 1:
            cell?.setLabel(color: colors[indexPath.row])
        default:
            break
        }
        
        return cell ?? UICollectionViewCell()
    }
    
}
