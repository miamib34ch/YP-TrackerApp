//
//  TrackerCell.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 29.06.2023.
//
/*
import UIKit

final class TrackerCell: UICollectionViewCell {

    weak var delegate: TrackerCellDelegate?

    private(set) lazy var trackerID = ""

    private lazy var trackerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .blue
        return view
    }()

    private lazy var trackerEmojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "YSDisplay-Medium", size: 13)
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()

    private lazy var trackerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "YSDisplay-Medium", size: 12)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private lazy var dayCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "YSDisplay-Medium", size: 12)
        return label
    }()

    private lazy var increaseDayCounterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.contentMode = .center
        button.addTarget(self, action: #selector(increaseDayCounter), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func increaseDayCounter() {
        delegate?.trackerCellDidTapButton(self)
    }

    private func setupConstraints() {
        [trackerView, dayCounterLabel, increaseDayCounterButton].forEach { contentView.addSubview($0) }
        [trackerEmojiLabel, trackerNameLabel].forEach { trackerView.addSubview($0) }
        NSLayoutConstraint.activate([
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerView.heightAnchor.constraint(equalToConstant: 90),

            trackerEmojiLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            trackerEmojiLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerEmojiLabel.heightAnchor.constraint(equalToConstant: 24),
            trackerEmojiLabel.widthAnchor.constraint(equalToConstant: 24),

            trackerNameLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),

            dayCounterLabel.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 16),
            dayCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayCounterLabel.heightAnchor.constraint(equalToConstant: 18),

            increaseDayCounterButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            increaseDayCounterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            increaseDayCounterButton.widthAnchor.constraint(equalToConstant: 34),
            increaseDayCounterButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    func configure(with viewModel: Tracker) {
        trackerID = viewModel.id
        trackerView.backgroundColor = viewModel.color
        increaseDayCounterButton.backgroundColor = viewModel.color
        trackerEmojiLabel.text = viewModel.emoji
        trackerNameLabel.text = viewModel.name
    }

    func set(dayCounter: Int) {
        dayCounterLabel.text = dayCounter.days
    }

    func buttonSetPlus() {
        let symbolConfig = UIImage.SymbolConfiguration(scale: .small)
        let plusImage = UIImage(systemName: "plus", withConfiguration: symbolConfig)
        increaseDayCounterButton.setImage(plusImage, for: .normal)
        increaseDayCounterButton.backgroundColor = increaseDayCounterButton.backgroundColor?.withAlphaComponent(1.0)
    }

    func buttonSetCheckmark() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .small)
        let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
        increaseDayCounterButton.setImage(checkmarkImage, for: .normal)
        increaseDayCounterButton.backgroundColor = increaseDayCounterButton.backgroundColor?.withAlphaComponent(0.3)
    }
}

*/
