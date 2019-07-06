//
//  noteViewController.swift
//  CoreDataPhotosChallenge
//
//  Created by John Williams III on 7/5/19.
//  Copyright © 2019 John Williams III. All rights reserved.
//

import UIKit
import CoreData

class noteViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var noteNameLabel: UITextField!
    
    @IBOutlet weak var noteDescriptionLabel: UITextView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var notesFetchResultsController: NSFetchedResultsController<Note>!
    
    var notes = [Note]()
    var note: Note?
    //var image: UIImage?
    
    var isExisting = false
    var indexPath: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let note = note{
            noteNameLabel.text = note.noteName
            noteDescriptionLabel.text = note.noteDescription
            noteImageView.image = UIImage(data: note.noteImage! as Data)
        }
        
        if noteNameLabel.text != "" {
            isExisting = true
        }
        
        noteNameLabel.delegate = self
        noteDescriptionLabel.delegate = self
        
    }
    
    func saveToCoreData(completion: @escaping () -> Void) {
        managedObjectContext?.perform {
            do{
                try self.managedObjectContext?.save()
                completion()
                print("Note saved to core data")
            }
            catch{
                print("Could not save to core data")
            }
        }
    }
    

    @IBAction func pickImageButton(_ sender: Any) {

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Add Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in imagePickerController.sourceType = .camera
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else{
                print("Camera not available!")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        noteImageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    

    @IBAction func saveButtonWasPressed(_ sender: Any) {
        
        if noteNameLabel.text == "" || noteNameLabel.text == "Note name" || noteDescriptionLabel.text == "" || noteDescriptionLabel.text == "Note Description"{
            let alertController = UIAlertController(title: "Missing Info", message: "Please fill out information before saving", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            if (isExisting == false){
                let noteName = noteNameLabel.text
                let noteDescription = noteDescriptionLabel.text
  
                
                if let moc = managedObjectContext{
                    let note = Note(context: moc)
                    /*
                    if let data = UIImageJPEGRepresentation(self.noteImageView.image!, 1.0) {
                        managedObject!.setValue(data, forKey: "noteImage")
                    }
                    */
                    note.noteName = noteName
                    note.noteDescription = noteDescription
                    
                    saveToCoreData() {
                        let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
                        
                        if isPresentingInAddNoteMode {
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                }
            }
            
            
        }
        if (isExisting == true) {
          let note = self.note
            let managedObject = note
            managedObject!.setValue(noteNameLabel.text, forKey: "noteName")
            managedObject!.setValue(noteDescriptionLabel.text, forKey: "noteDescription")
            
            do {
                //try context.save()
                let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
                
                if isPresentingInAddNoteMode {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.navigationController!.popViewController(animated: true)
                }
                
            }
            catch{
                print("Update failed")
            }
            
        }
        
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
        
        if isPresentingInAddNoteMode {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        textView.resignFirstResponder()
        return false
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Note Description"){
            textView.text = ""
        }
    }
}
