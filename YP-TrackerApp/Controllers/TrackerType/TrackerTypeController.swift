//
//  TrackerTypeController.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 02.05.2023.
//

import UIKit

final class TrackerTypeController: UIViewController {

    private let habitButton = UIButton()
    private let irregularEventButton = UIButton()
    private let label = UILabel()

    var trackerView: TrackersViewProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        configureButtons()
        configureLabel()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        trackerView?.datePickerBackgroundView.backgroundColor = UIColor(named: "#F0F0F0")
        trackerView?.updateVisibleCategories()
        trackerView?.updateCollection()
    }

    private func configureButtons() {
        habitButton.backgroundColor = UIColor(named: "MainForegroundColor")
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(UIColor(named: "MainBackgroundColor"), for: .normal)
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitButton.addTarget(self, action: #selector(newHabit), for: .touchUpInside)

        habitButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(habitButton)

        NSLayoutConstraint.activate([
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        irregularEventButton.backgroundColor = UIColor(named: "MainForegroundColor")
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.setTitleColor(UIColor(named: "MainBackgroundColor"), for: .normal)
        irregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        irregularEventButton.addTarget(self, action: #selector(newIrregularEvent), for: .touchUpInside)

        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(irregularEventButton)

        NSLayoutConstraint.activate([
            irregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),

            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func configureLabel() {
        label.text = "Создание трекера"
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

    @objc private func newHabit() {
        guard let trackerView = trackerView else { return }

        let createTrackerController = CreateTrackerController()
        createTrackerController.trackerTypeView = self
        createTrackerController.trackerView = trackerView
        createTrackerController.mainLabel.text = "Новая привычка"

        present(createTrackerController, animated: true)
    }

    @objc private func newIrregularEvent() {
        guard let trackerView = trackerView else { return }

        let createTrackerController = CreateTrackerController()
        createTrackerController.trackerTypeView = self
        createTrackerController.trackerView = trackerView
        createTrackerController.mainLabel.text = "Новое нерегулярное событие"
        createTrackerController.tableHeight /= 2
        createTrackerController.tableNumberRawsInSections = 1

        present(createTrackerController, animated: true)
    }

}
