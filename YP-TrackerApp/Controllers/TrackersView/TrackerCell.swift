//
//  TrackerCell.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 29.06.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidTapButton(_ cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {

    weak var delegate: TrackerCellDelegate?

    var trackerID: UUID = UUID()

    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()

    private let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private let dayCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let dayCounterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.contentMode = .center
        button.addTarget(self, action: #selector(increaseDayCounter), for: .touchUpInside)
        return button
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        trackerID = UUID()
        colorView.backgroundColor = .clear
        emojiLabel.text = ""
        trackerNameLabel.text = ""
        dayCounterLabel.text = ""
        dayCounterButton.backgroundColor = .clear
    }

    func configureCell(with tracker: Tracker) {
        trackerID = tracker.idTracker
        colorView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        trackerNameLabel.text = tracker.name
        dayCounterButton.backgroundColor = tracker.color
    }

    func buttonSetPlus() {
        let symbolConfig = UIImage.SymbolConfiguration(scale: .small)
        let plusImage = UIImage(systemName: "plus", withConfiguration: symbolConfig)
        dayCounterButton.setImage(plusImage, for: .normal)
        dayCounterButton.backgroundColor = dayCounterButton.backgroundColor?.withAlphaComponent(1.0)
    }

    func buttonSetCheckmark() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .small)
        let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
        dayCounterButton.setImage(checkmarkImage, for: .normal)
        dayCounterButton.backgroundColor = dayCounterButton.backgroundColor?.withAlphaComponent(0.3)
    }

    func setDayCounterLabel(with dayCounter: Int) {
        dayCounterLabel.text = dayCounter.days
    }

    private func setupConstraints() {
        [colorView, dayCounterLabel, dayCounterButton].forEach { contentView.addSubview($0) }
        [emojiLabel, trackerNameLabel].forEach { colorView.addSubview($0) }

        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),

            trackerNameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),

            dayCounterLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            dayCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayCounterLabel.heightAnchor.constraint(equalToConstant: 18),

            dayCounterButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            dayCounterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dayCounterButton.widthAnchor.constraint(equalToConstant: 34),
            dayCounterButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    @objc private func increaseDayCounter() {
        delegate?.trackerCellDidTapButton(self)
    }

}
