//
//  NotesViewController.swift
//  Copyright © 2016 ArtyGeek. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteCreatedLabel: UILabel!
    @IBOutlet weak var noteEditedLabel: UILabel!
    
    @IBOutlet weak var detailsViewBottom: NSLayoutConstraint!
    @IBOutlet weak var detailsViewHeight: NSLayoutConstraint!
    
    //MARK: Private vars
    
    private let _notesService = NotesCoreDataService.shared
    private var _notes: [Note] = []
    private let dateFormatter = DateFormatter()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupFormatter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _updateNotes()
    }

    //MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)

        let note = _notes[indexPath.row]
        cell.textLabel?.text = note.text
        
        return cell
    }

    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _fillDetailsViewWithNote(atIndexPath: indexPath)
        _moveDetailsView(up: true)
    }
    
    //MARK: IBActions
    
    @IBAction func onEditNoteTap(_ sender: AnyObject) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "editNoteSegue", sender: cell)
        }
    }
    
    @IBAction func onDeleteNoteTap(_ sender: AnyObject) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let note = _notes.remove(at: indexPath.row)
            _notesService.deleteNote(note)
            tableView.deleteRows(at: [indexPath], with: .left)
            _moveDetailsView(up: false)
        }
    }
    
    //MARK: Private methods
    
    private func _updateNotes() {
        if let notes = _notesService.getAllNotes() {
            _notes = notes
            let selectedIndexPath = tableView.indexPathForSelectedRow
            tableView.reloadData()
            
            if selectedIndexPath != nil && (selectedIndexPath!.row < notes.count) {
                tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .top)
                _fillDetailsViewWithNote(atIndexPath: selectedIndexPath!)
            } else {
                _moveDetailsView(up: false)
            }
        }
    }
    
    private func _setupFormatter() {
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
    }
    
    private func _fillDetailsViewWithNote(atIndexPath indexPath: IndexPath) {
        let note = _notes[indexPath.row]
        
        noteTitleLabel.text = note.text
        noteCreatedLabel.text = dateFormatter.string(from: note.metadata.createdDate)
        if let editedDate = note.metadata.editedDate {
            noteEditedLabel.text = dateFormatter.string(from: editedDate)
        }
    }
    
    private func _moveDetailsView(up: Bool) {
        detailsViewBottom.constant = up ? 0 : -detailsViewHeight.constant
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editorVC = segue.destination as! NoteEditorViewController
        
        if segue.identifier == "editNoteSegue" {
            let row = tableView.indexPath(for: sender as! UITableViewCell)!.row
            editorVC.note = _notes[row]
        }
    }

}
