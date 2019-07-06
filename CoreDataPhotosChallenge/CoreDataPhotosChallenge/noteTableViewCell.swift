//
//  noteTableViewCell.swift
//  CoreDataPhotosChallenge
//
//  Created by John Williams III on 7/5/19.
//  Copyright © 2019 John Williams III. All rights reserved.
//

import UIKit

class noteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(note: Note) {
        self.noteNameLabel.text = note.noteName?.uppercased()
        self.descriptionLabel.text = note.noteDescription
        //self.noteImageView.image = UIImage(data: note.noteImage! as Data)
    }
    
}
