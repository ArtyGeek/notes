//
//  NotesCoreDataService.swift
//  Copyright © 2016 ArtyGeek. All rights reserved.
//

import UIKit

class NotesCoreDataService: NSObject {

    static let shared = NotesCoreDataService()
    
    //MARK: Pravate vars
    
    private let _service = CoreDataService.shared
    private let _entityName = "Note"
    private let _metadataEntityName = "Metadata"
    
    //MARK: Public methods
    
    public func createNote(withText text: String? = nil) -> Note {
        let notesCount = _service.countObjects(forEntityName: _entityName)
        let note: Note = _service.insertObject(forEntityName: _entityName) as! Note
        let metadata: Metadata = _service.insertObject(forEntityName: _metadataEntityName) as! Metadata
        note.metadata = metadata
        
        note.id = NSNumber(value: notesCount)
        note.text = text
        metadata.createdDate = Date()
        
        return note
    }
    
    public func getNote(withId id: NSNumber) -> Note? {
        let predicate = NSPredicate(format: "id == %@", id)
        if let notes = _service.getObjects(forEntityName: _entityName, predicate: predicate) as? [Note] {
            return notes.first
        }
        
        return nil
    }
    
    public func getAllNotes() -> [Note]? {
        if let notes = _service.getObjects(forEntityName: _entityName) as? [Note] {
            return notes
        }
        
        return nil
    }
    
    public func deleteNote(_ note: Note) {
        _service.delete(object: note)
    }
    
    public func deleteNote(withId id: NSNumber) {
        if let note = getNote(withId: id) {
            deleteNote(note)
        }
    }
}
