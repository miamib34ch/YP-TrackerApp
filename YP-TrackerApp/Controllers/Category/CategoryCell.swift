//
//  CategoryCell.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 17.07.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkmarkView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(title)
        contentView.addSubview(checkmarkView)
        contentView.backgroundColor = UIColor(named: "ElementsBackgroundColor")
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            checkmarkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}

