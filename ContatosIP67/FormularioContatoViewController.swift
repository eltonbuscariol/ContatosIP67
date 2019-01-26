//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios8043 on 05/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import UIKit

class FormularioContatoViewController: UIViewController {

    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var site: UITextField!
    var dao:ContatoDao
    var contato : Contato!
    var delegate: FormularioContatoViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        self.dao = ContatoDao.sharedInstance()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contato != nil{
            preencheFormulario()
            
            let botaoAlterar = UIBarButtonItem(image: UIImage(named: "saveEdit"), style: .plain, target: self, action: #selector(atualizaContato))
            self.navigationItem.rightBarButtonItem = botaoAlterar
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func criaContato() {
        self.pegarDadosDoFormulario()
        self.dao.adiciona(contato)
        self.delegate?.contatoAdicionado(contato)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func atualizaContato() {
        pegarDadosDoFormulario()
        self.delegate?.contatoAtualizado(contato)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func pegarDadosDoFormulario() {
        if contato == nil{
            contato = Contato()
        }
        
        contato.nome = nome.text
        contato.endereco = endereco.text
        contato.telefone = telefone.text
        contato.site = site.text
    }
    
    func preencheFormulario() {
        nome.text = contato.nome
        endereco.text = contato.endereco
        telefone.text = contato.telefone
        site.text = contato.site
    }
}

