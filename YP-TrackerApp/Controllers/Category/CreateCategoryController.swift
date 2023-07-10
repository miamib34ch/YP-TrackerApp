//
//  CreateCategory.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 27.06.2023.
//

import UIKit

final class CreateCategoryController: UIViewController {

    private let label = UILabel()
    private let button = UIButton()
    let textField = MyTextField()

    var editingIndex: Int?
    var categoryController: CategoryController?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // Скрываем клавиатуру при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func configureView() {
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        configureLabel()
        configureButton()
        if editingIndex != nil {
            makeButtonActive()
        }
        configureTextField()
    }

    private func configureLabel() {
        if editingIndex != nil {
            label.text = "Редактирование категории"
        } else {
            label.text = "Новая категория"
        }

        label.textColor = UIColor(named: "MainForegroundColor")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureButton() {
        makeButtonNoActive()

        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true

        button.setTitle("Готово", for: .normal)
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

    private func makeButtonActive() {
        button.isEnabled = true
        button.setTitleColor(UIColor(named: "MainBackgroundColor"), for: .normal)
        button.backgroundColor = UIColor(named: "MainForegroundColor")
    }

    private func makeButtonNoActive() {
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "#AEAFB4")
    }

    private func configureTextField() {
        if !(view.contains(label)) { return }

        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true

        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название категории",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "#AEAFB4") ?? UIColor.gray]
        )

        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = UIColor(named: "ElementsBackgroundColor")

        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        textField.clearButtonMode = .whileEditing

        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.delegate = self

        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }

    @objc private func buttonTap() {
        guard let newCategory = textField.text,
              let categoryController = categoryController else { return }
        var createTrackerController = categoryController.createTrackerController ?? CreateTrackerController()
        var trackerView = createTrackerController.trackerView ?? TrackersViewController()

        if let editingIndex = editingIndex {
            categoryController.categories[editingIndex] = newCategory
            trackerView.categories[editingIndex] = TrackerCategory(name: newCategory,
                                                                   trackers: trackerView.categories[editingIndex].trackers)
            createTrackerController.setTableSubnames()
        } else {
            categoryController.categories.append(newCategory)
            categoryController.selectedCategory = categoryController.categories.count-1
            trackerView.categories.append(TrackerCategory(name: newCategory, trackers: []))
            createTrackerController.selectedCategory = newCategory
            createTrackerController.tableSubnames[0] = newCategory
            createTrackerController.setTableSubnames()
        }

        categoryController.updateTable()
        dismiss(animated: true)

        if editingIndex == nil {
            categoryController.dismiss(animated: true)
        }
    }

}

// MARK: UITextField extension

extension CreateCategoryController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let isLessThan1 = updatedText.count < 1
        if isLessThan1 {
            makeButtonNoActive()
        } else {
            makeButtonActive()
        }

        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        makeButtonNoActive()
        return true
    }

}
