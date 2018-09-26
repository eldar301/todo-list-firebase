//
//  DatePickerTextField.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 26/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DatePickerTextField: UpgradedTextField {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    override var text: String? {
        didSet {
            print("set")
        }
    }
    
    var date: Date? {
        didSet {
            if let date = date {
                self.text = dateFormatter.string(from: date)
            } else {
                self.text = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup() {
        let datePicker = UIDatePicker()
        self.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePicked(datePicker:)), for: .valueChanged)
    }
    
    @objc func datePicked(datePicker: UIDatePicker) {
        date = datePicker.date
    }
    
//    override func selectionRects(for range: UITextRange) -> [Any] {
//        return []
//    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
}
