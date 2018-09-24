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
    
    @IBOutlet weak var actionButton: UIButton!
    
    var presenter: TaskPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.delegate = self
        
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.delegate = self
        
        let padding = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        descriptionTextView.textContainerInset = padding
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        resetBackgrounds()
        updateDescriptionTextViewHeight()
    }
    
    @IBAction func action(_ sender: Any) {
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        
        if actionButton.titleLabel?.text == "ADD" {
            presenter.set(title: titleTextField.text!)
            presenter.set(description: descriptionTextView.textColor == .placeholderTextColor ? "" : descriptionTextView.text)
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
        presenter.set(description: descriptionTextView.textColor == .placeholderTextColor ? "" : descriptionTextView.text)
        
        presenter.dismiss()
    }
    
    func resetBackgrounds() {
        titleTextField.backgroundColor = .clear
        descriptionTextView.backgroundColor = .clear
    }
    
    func setBackgrounds() {
        titleTextField.backgroundColor = .editBackgroundColor
        descriptionTextView.backgroundColor = .editBackgroundColor
    }
    
    func updateDescriptionTextViewHeight() {
        descriptionTextView.isScrollEnabled = true
        descriptionTextViewHeightConstraint.constant = descriptionTextView.contentSize.height
        descriptionTextView.isScrollEnabled = false
    }
    
}

extension TaskViewController: TaskView {
    
    func setupNew() {
        titleTextField.becomeFirstResponder()
        actionButton.setTitle("ADD", for: .normal)
    }
    
    func set(title: String, description: String?, done: Bool) {
        titleTextField.text = title
        descriptionTextView.text = description
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = .placeholderTextColor
        } else {
            descriptionTextView.textColor = .textColor
        }
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
        updateDescriptionTextViewHeight()
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
