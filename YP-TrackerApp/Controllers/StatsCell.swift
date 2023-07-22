//
//  StatsCell.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 23.07.2023.
//

import UIKit

final class StatsCell: UITableViewCell {
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "0"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stringLablel: UILabel = {
        let label = UILabel()
        label.text = "Трекеров завершено"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(stringLablel)
        contentView.addSubview(numberLabel)

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(named: "#FD4C49")?.cgColor, UIColor(named: "#46E69D")?.cgColor,  UIColor(named: "#007BFA")?.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width + 41, height: bounds.height)
        UIGraphicsBeginImageContextWithOptions(gradient.bounds.size, false, 0)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        contentView.backgroundColor = UIColor(named: "MainBackgroundColor")
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(patternImage: gradientImage!).cgColor
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stringLablel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stringLablel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 12)
        ])
    }
    
}
