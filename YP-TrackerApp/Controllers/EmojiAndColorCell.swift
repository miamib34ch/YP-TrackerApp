//
//  EmojiAndColorCell.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 28.06.2023.
//

import UIKit

final class EmojiAndColorCell: UICollectionViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = ""
        label.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
    
    func setLabel(text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 32)
    }
    
    func setLabel(color: UIColor) {
        label.backgroundColor = color
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
    }
    
}
