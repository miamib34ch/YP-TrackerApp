//
//  SupplementaryView.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 29.06.2023.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {

    private let titleLabel = UILabel()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setLabel(text: String?, textAlignment: NSTextAlignment?, textColor: UIColor?, font: UIFont?) {
        titleLabel.text = text
        titleLabel.textAlignment = textAlignment ?? .center
        titleLabel.textColor = textColor
        titleLabel.font = font
    }

}
