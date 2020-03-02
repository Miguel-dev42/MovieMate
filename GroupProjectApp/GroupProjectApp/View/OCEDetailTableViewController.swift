//
//  OCEDetailTableViewController.swift
//  GroupProjectApp
//
//  Created by Miguel Figueroa on 1/23/20.
//  Copyright © 2020 Miguel Figueroa. All rights reserved.
//

import UIKit

class OCEDetailTableViewController: UITableViewController {
    
//    MARK: Outlets and Dependencies
    static var newCharacter: Bool? = false
    static var newEvent: Bool? = false
    static var newObject: Bool? = false
    static var retCharacter: Bool? = false
    static var retEvent: Bool? = false
    static var retObject: Bool? = false
    var movieID: Int?
    var collection: Collection?
    static var newOCE: Bool?
    @IBOutlet weak var characterNameTextView: UITextView!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var relatedCharacterNotesTextView: UITextView!
    @IBOutlet weak var relatedObjectsNotesTextView: UITextView!
    @IBOutlet weak var relatedEventsNotesTextView: UITextView!
    
    static var delegate: MovieDetailProtocol?
    static var character: Character?
    static var event: Event?
    static var object: Object?
    
//    MARK: Cancel Button
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        OCEDetailTableViewController.newCharacter = false
        OCEDetailTableViewController.newEvent = false
        OCEDetailTableViewController.newObject = false
        
    }
    var whatAmI: String?
    

//    MARK: Save Button
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if OCEDetailTableViewController.newCharacter == true {
            whatAmI = "char"
        } else if OCEDetailTableViewController.newObject == true {
            whatAmI = "obj"
        } else if OCEDetailTableViewController.newEvent == true {
            whatAmI = "event"
        }
        
        if OCEDetailTableViewController.newOCE == true {
            print("Adding new")
            if whatAmI == "char" {
                addNewOCEInMovie(movieIDToAddInto: globalMovieID!, oceToInsert: MovieCharacter(name: characterNameTextView.text, notes: notesText.text, relatedObjects: relatedObjectsNotesTextView.text, relatedCharacters: relatedCharacterNotesTextView.text, relateEvents: relatedEventsNotesTextView.text), oceType: whatAmI ?? "")
            } else if whatAmI == "event" {
                addNewOCEInMovie(movieIDToAddInto: globalMovieID!, oceToInsert: MovieEvent(name: characterNameTextView.text, notes: notesText.text, relatedObjects: relatedObjectsNotesTextView.text, relatedCharacters: relatedCharacterNotesTextView.text, relateEvents: relatedEventsNotesTextView.text), oceType: whatAmI ?? "")
            } else if whatAmI == "obj" {
                addNewOCEInMovie(movieIDToAddInto: globalMovieID!, oceToInsert: MovieObject(name: characterNameTextView.text, notes: notesText.text, relatedObjects: relatedObjectsNotesTextView.text, relatedCharacters: relatedCharacterNotesTextView.text, relateEvents: relatedEventsNotesTextView.text), oceType: whatAmI ?? "")
            }
            
            
        } else {
            print("updating")
            updateOCEInMovie(movieIDToAddInto: globalMovieID! , oceToInsert: MovieCharacter(name: characterNameTextView.text, notes: notesText.text, relatedObjects: relatedObjectsNotesTextView.text, relatedCharacters: relatedCharacterNotesTextView.text, relateEvents: relatedEventsNotesTextView.text), oldOCEName: (CharacterCollectionViewController.collectionCharacters?[CharacterCollectionViewController.indexOfChar].name)!, oceType: "")
        }
//        MovieDetailTableViewController.shared.tableView.reloadData()
        OCEDetailTableViewController.delegate?.saved()
        dismiss(animated: true, completion: nil)
    }
    
//    MARK: Trash Button
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        if OCEDetailTableViewController.retCharacter == true {
            whatAmI = "char"
            deleteOCEFromMovie(movieToDeleteFrom: globalMovieID!, oceToDelete: MovieCharacter(name: characterNameTextView.text, notes: notesText.text, relatedObjects: relatedObjectsNotesTextView.text, relatedCharacters: relatedCharacterNotesTextView.text, relateEvents: relatedEventsNotesTextView.text), oceType: whatAmI!, oldOCEName: (CharacterCollectionViewController.collectionCharacters?[CharacterCollectionViewController.indexOfChar].name)!)
            OCEDetailTableViewController.delegate?.saved()
        } else if OCEDetailTableViewController.retObject == true {
            whatAmI = "obj"
            deleteOCEFromMovie(movieToDeleteFrom: globalMovieID!, oceToDelete: MovieObject(name: characterNameTextView.text, notes: notesText.text, relatedObjects: relatedObjectsNotesTextView.text, relatedCharacters: relatedCharacterNotesTextView.text, relateEvents: relatedEventsNotesTextView.text), oceType: whatAmI!, oldOCEName: (CharacterCollectionViewController.collectionCharacters?[CharacterCollectionViewController.indexOfChar].name)!)
            OCEDetailTableViewController.delegate?.saved()
        } else if OCEDetailTableViewController.retEvent == true {
            whatAmI = "event"
            deleteOCEFromMovie(movieToDeleteFrom: globalMovieID!, oceToDelete: MovieEvent(name: characterNameTextView.text, notes: notesText.text, relatedObjects: relatedObjectsNotesTextView.text, relatedCharacters: relatedCharacterNotesTextView.text, relateEvents: relatedEventsNotesTextView.text), oceType: whatAmI!, oldOCEName: (CharacterCollectionViewController.collectionCharacters?[CharacterCollectionViewController.indexOfChar].name)!)
            OCEDetailTableViewController.delegate?.saved()
        }
      
        OCEDetailTableViewController.delegate?.saved()
        dismiss(animated: true, completion: nil)
    }
    
    
    
//    MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark  
        updateView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        OCEDetailTableViewController.newCharacter = false
        OCEDetailTableViewController.newEvent = false
        OCEDetailTableViewController.newObject = false
        OCEDetailTableViewController.character = nil
        OCEDetailTableViewController.event = nil
        OCEDetailTableViewController.object = nil
    }
    
    
//    MARK: UPDATE VIEW
    
    func updateView() {
        
        guard let newCharacter = OCEDetailTableViewController.newCharacter, let newEvent = OCEDetailTableViewController.newEvent, let newObject = OCEDetailTableViewController.newObject else { return }
        
        
        if !newCharacter && !newObject && !newEvent {
            characterNameTextView.text = OCEDetailTableViewController.character?.name ?? OCEDetailTableViewController.event?.name ?? OCEDetailTableViewController.object?.name ?? ""
            navTitle.title = "Edit existing"
        } else if newCharacter {
            navTitle.title = "Add a character"
            characterNameTextView.text = "Add Character's name"
        } else if newEvent {
            navTitle.title = "Add a new Event"
            characterNameTextView.text = "Add a name for the event"
        } else if newObject {
            navTitle.title = "Add a new Object"
            characterNameTextView.text = "Add a name for your object"
        }
        
        
        
    }

}
