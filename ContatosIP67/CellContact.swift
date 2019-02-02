//
//  CellContact.swift
//  ContatosIP67
//
//  Created by ios8043 on 19/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import UIKit

class CellContact: UITableViewCell {

    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblPhone: UILabel!    
    @IBOutlet weak var imageProfile: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(contato:Contato) {
        self.lblNome.text = contato.nome
        self.lblPhone.text = contato.telefone
        
        let index = contato.nome.index(contato.nome.startIndex, offsetBy: 1)
        if let foto = contato.foto{
            self.imageProfile.image = foto
            self.imageProfile.layer.masksToBounds = true
            self.imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
            self.imageProfile.isHidden = false
            lblProfile.isHidden = true
        }else{
            lblProfile.text = contato.nome.substring(to: index).uppercased()
            lblProfile.layer.masksToBounds = true
            lblProfile.layer.cornerRadius = lblProfile.frame.height / 2
            lblProfile.layer.borderColor = lblProfile.textColor.cgColor
            lblProfile.layer.borderWidth = 2
            imageProfile.isHidden = true
            lblProfile.isHidden = false
        }
    }

}
