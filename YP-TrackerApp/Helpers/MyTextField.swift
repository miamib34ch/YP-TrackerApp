//
//  MyTextField.swift
//  YP-TrackerApp
//
//  Created by Богдан Полыгалов on 04.05.2023.
//

import UIKit

final class MyTextField: UITextField {
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        
        return originalRect.offsetBy(dx: -12, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.textRect(forBounds: bounds)
        
        return CGRect(x: 16, y: 0, width: originalRect.width-28, height: originalRect.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return self.textRect(forBounds: bounds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = UIColor(named: "#AEAFB4")
            }
        }
    }
    
}
