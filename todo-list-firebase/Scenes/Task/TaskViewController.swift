//
//  ViewController.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 20/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    struct Strings {
        struct Placeholder {
            static let pickDeadline = NSLocalizedString("Pick deadline", comment: #file)
            static let description = NSLocalizedString("Description", comment: #file)
        }
        struct Action {
            static let add = NSLocalizedString("ADD", comment: #file)
            static let done = NSLocalizedString("DONE", comment: #file)
            static let undone = NSLocalizedString("UNDONE", comment: #file)
        }
    }
    struct TitleTextField {
        static let cornerRadius: CGFloat = 5.0
    }
    struct DescriptionTextView {
        static let cornerRadius: CGFloat = 5.0
        static let maxHeightRatio = CGFloat(3) / 8
        static let textInset = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
    }
    struct DeadlinePicker {
        static let cornerRadius: CGFloat = 5.0
    }
    struct Colors {
        static let textColor = UIColor.white
        static let editBackgroundColor = UIColor.black.withAlphaComponent(0.2)
        static let placeholderTextColor = UIColor(red: 158.0 / 255.0, green: 114.0 / 255.0, blue: 57.0 / 255.0, alpha: 0.7)
    }
}

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
        
        maxDescriptionTextViewHeight = self.view.bounds.height * Constants.DescriptionTextView.maxHeightRatio
        
        presenter.view = self
        
        titleTextField.layer.cornerRadius = Constants.TitleTextField.cornerRadius
        titleTextField.delegate = self
        
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.layer.cornerRadius = Constants.DescriptionTextView.cornerRadius
        descriptionTextView.delegate = self
        descriptionTextView.textContainerInset = Constants.DescriptionTextView.textInset
        
        deadlinePicker.layer.cornerRadius = Constants.DeadlinePicker.cornerRadius
        deadlinePicker.delegate = self
        deadlinePicker.textColor = Constants.Colors.textColor
        deadlinePicker.placeholder = Constants.Strings.Placeholder.pickDeadline
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
        
        if actionButton.titleLabel?.text == Constants.Strings.Action.add {
            presenter.set(title: titleTextField.text!)
            presenter.set(description: descriptionTextView.textColor == Constants.Colors.placeholderTextColor ? nil : descriptionTextView.text)
            presenter.set(deadline: deadlinePicker.date)
            presenter.create()
        } else {
            if presenter.toggleDone() {
                actionButton.setTitle(Constants.Strings.Action.undone, for: .normal)
            } else {
                actionButton.setTitle(Constants.Strings.Action.done, for: .normal)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        presenter.set(title: titleTextField.text!)
        presenter.set(description: descriptionTextView.textColor == Constants.Colors.placeholderTextColor ? nil : descriptionTextView.text)
        presenter.set(deadline: deadlinePicker.date)
        
        presenter.dismiss()
    }
    
    func resetBackgrounds() {
        titleTextField.backgroundColor = .clear
        descriptionTextView.backgroundColor = .clear
        deadlinePicker.backgroundColor = .clear
    }
    
    func setBackgrounds() {
        let color = Constants.Colors.editBackgroundColor
        titleTextField.backgroundColor = color
        descriptionTextView.backgroundColor = color
        deadlinePicker.backgroundColor = color
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
        descriptionTextView.text = Constants.Strings.Placeholder.description
        descriptionTextView.textColor = Constants.Colors.placeholderTextColor
        actionButton.setTitle(Constants.Strings.Action.add, for: .normal)
    }
    
    func set(title: String, description: String?, deadline: Date?, done: Bool) {
        titleTextField.text = title
        if description?.isEmpty ?? true {
            descriptionTextView.text = Constants.Strings.Placeholder.description
            descriptionTextView.textColor = Constants.Colors.placeholderTextColor
        } else {
            descriptionTextView.text = description
            descriptionTextView.textColor = Constants.Colors.textColor
        }
        deadlinePicker.date = deadline
        actionButton.setTitle(done ? Constants.Strings.Action.undone : Constants.Strings.Action.done, for: .normal)
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
        
        if textView.textColor == Constants.Colors.placeholderTextColor {
            textView.textColor = Constants.Colors.textColor
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
            textView.text = Constants.Strings.Placeholder.description
            textView.textColor = Constants.Colors.placeholderTextColor
        }
    }
    
}
