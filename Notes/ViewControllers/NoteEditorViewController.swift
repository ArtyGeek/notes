//
//  NoteEditorViewController.swift
//  Copyright © 2016 ArtyGeek. All rights reserved.
//

import UIKit

class NoteEditorViewController: UIViewController {

    //MARK: Public vars
    
    public var note: Note?
    
    //MARK: IBOutlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _fillTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _setupObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _removeObservers()
        _saveNote()
    }
    
    //MARK: Private methods
    
    private func _setupObservers() {
        let center = NotificationCenter.default
        center.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification) in
            self._onKeyboardWillShow(notification: notification);
        }
        center.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification) in
            self._onKeyboardWillHide(notification: notification)
        }
    }
    
    private func _removeObservers() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func _onKeyboardWillShow(notification: Notification) {
        _moveKeyboard(notification: notification, up: true)
    }
    
    private func _onKeyboardWillHide(notification: Notification) {
        _moveKeyboard(notification: notification, up: false)
    }
    
    private func _moveKeyboard(notification: Notification, up: Bool) {
        
        let userInfo = notification.userInfo!
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        var options = UIViewAnimationOptions(rawValue: curve << 16)
        options.formUnion(.beginFromCurrentState)
        
        let endFrame = ((userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        
        let keyboardFrame = self.view.convert(endFrame, to: nil)
        let keyboardHeight = keyboardFrame.height
        
        self.textViewBottom.constant = up ? keyboardHeight : 0
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.textView.contentOffset.y = keyboardHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func _fillTextView() {
        guard let note = note else {
            return
        }
        
        textView.text = note.text
    }
    
    private func _saveNote() {
        
        let text = textView.text
        if !(text!.isEmpty) {
            if note != nil {
                note!.text = text
            } else {
                note = NotesCoreDataService.shared.createNote(withText: text)
            }
        } else {
            guard let note = note else {
                return
            }
            NotesCoreDataService.shared.deleteNote(note)
        }
        
        CoreDataService.shared.saveStoredData()
    }
}
