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
    @IBOutlet weak var viewProfile: UIView!
    
    
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
        
        let label = UILabel()
        let index = contato.nome.index(contato.nome.startIndex, offsetBy: 1)
        label.text = contato.nome.substring(to: index)
        viewProfile.insertSubview(label, at: 0)
    }

}
