//
//  ViewController.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 20/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deadlinePicker: DatePickerTextField!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var presenter: TaskPresenter!
    
    fileprivate var maxDescriptionTextViewHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxDescriptionTextViewHeight = self.view.bounds.height * 3 / 8
        
        presenter.view = self
        
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.delegate = self
        
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.delegate = self
        let padding = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        descriptionTextView.textContainerInset = padding
        
        deadlinePicker.layer.cornerRadius = 5.0
        deadlinePicker.delegate = self
        deadlinePicker.textColor = .textColor
        deadlinePicker.placeholder = "Pick deadline"
        deadlinePicker.textAlignment = .center
        deadlinePicker.clearButtonMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        resetBackgrounds()
        updateDescriptionTextView()
    }
    
    @IBAction func action(_ sender: Any) {
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        
        if actionButton.titleLabel?.text == "ADD" {
            presenter.set(title: titleTextField.text!)
            presenter.set(description: descriptionTextView.textColor == .placeholderTextColor ? nil : descriptionTextView.text)
            presenter.set(deadline: deadlinePicker.date)
            presenter.create()
        } else {
            if presenter.toggleDone() {
                actionButton.setTitle("UNDONE", for: .normal)
            } else {
                actionButton.setTitle("DONE", for: .normal)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        presenter.set(title: titleTextField.text!)
        presenter.set(description: descriptionTextView.textColor == .placeholderTextColor ? nil : descriptionTextView.text)
        presenter.set(deadline: deadlinePicker.date)
        
        presenter.dismiss()
    }
    
    func resetBackgrounds() {
        titleTextField.backgroundColor = .clear
        descriptionTextView.backgroundColor = .clear
        deadlinePicker.backgroundColor = .clear
    }
    
    func setBackgrounds() {
        titleTextField.backgroundColor = .editBackgroundColor
        descriptionTextView.backgroundColor = .editBackgroundColor
        deadlinePicker.backgroundColor = .editBackgroundColor
    }
    
    func updateDescriptionTextView() {
        descriptionTextView.isScrollEnabled = true
        let desiredHeight = descriptionTextView.contentSize.height
        if desiredHeight > maxDescriptionTextViewHeight {
            descriptionTextViewHeightConstraint.constant = maxDescriptionTextViewHeight
        } else {
            descriptionTextViewHeightConstraint.constant = desiredHeight
            descriptionTextView.isScrollEnabled = false
        }
    }
    
}

extension TaskViewController: TaskView {
    
    func setupNew() {
        titleTextField.becomeFirstResponder()
        descriptionTextView.text = "Description"
        descriptionTextView.textColor = .placeholderTextColor
        actionButton.setTitle("ADD", for: .normal)
    }
    
    func set(title: String, description: String?, deadline: Date?, done: Bool) {
        titleTextField.text = title
        if description?.isEmpty ?? true {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = .placeholderTextColor
        } else {
            descriptionTextView.text = description
            descriptionTextView.textColor = .textColor
        }
        deadlinePicker.date = deadline
        actionButton.setTitle(done ? "UNDONE" : "DONE", for: .normal)
    }
    
    func error(error: TaskError) {
        switch error {
        case .invalidTitle:
            print("invalid title")
        }
    }
    
}

extension TaskViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setBackgrounds()
        
        textField.tintColor = self.view.backgroundColor
        
        if textField === deadlinePicker, deadlinePicker.date == nil {
            deadlinePicker.date = Date()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField === deadlinePicker {
            deadlinePicker.date = nil
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resetBackgrounds()
        
        textField.resignFirstResponder()
    }
    
}

extension TaskViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setBackgrounds()
        
        textView.tintColor = self.view.backgroundColor
        
        if textView.textColor == .placeholderTextColor {
            textView.textColor = .textColor
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateDescriptionTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        resetBackgrounds()
        
        textView.resignFirstResponder()
        
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .placeholderTextColor
        }
    }
    
}

fileprivate extension UIColor {
    
    static var editBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.2)
    }
    
    static var placeholderTextColor: UIColor {
        return UIColor(red: 158.0 / 255.0,
                       green: 114.0 / 255.0,
                       blue: 57.0 / 255.0,
                       alpha: 0.7)
    }
    
    static var textColor: UIColor {
        return .white
    }
    
}
