//
//  ListaContatosViewControllerTableViewController.swift
//  ContatosIP67
//
//  Created by ios8043 on 05/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import UIKit

class ListaContatosViewControllerTableViewController: UITableViewController, FormularioContatoViewControllerDelegate {

    var dao : ContatoDao
    static let cellIdentifier = "cell"
    var linhaDestaque:IndexPath?
    
    required init?(coder aDecoder: NSCoder) {
        self.dao = ContatoDao.sharedInstance()
        super.init(coder: aDecoder)
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(exibirMaisAcoes(gesture:)))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        if let linha = linhaDestaque {
            self.tableView.selectRow(at: linha, animated: true, scrollPosition: .middle)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                self.tableView.deselectRow(at: linha, animated: true)
                self.linhaDestaque = .none
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FormSegue"{
            
            if let formulario = segue.destination as? FormularioContatoViewController{
                formulario.delegate = self
            }
        }
    }

    func exibirMaisAcoes(gesture:UIGestureRecognizer) {
        if gesture.state == .began{
            
            let ponto = gesture.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: ponto){
                let contato = dao.buscaContatoNaPosicao(posicao: indexPath.row)
                let acoes = GerenciadorDeAcoes(do: contato)
                acoes.exibirAcoes(em: self)
            }
        }
    }
    
    // MARK: - Delegate
    
    func contatoAtualizado(_ contato: Contato) {
        linhaDestaque = IndexPath(row: self.dao.buscaPosicaoDoContato(contato), section: 0)
        print("contato atualizado: \(contato.nome)")
    }
    
    func contatoAdicionado(_ contato: Contato) {
        linhaDestaque = IndexPath(row: self.dao.buscaPosicaoDoContato(contato), section: 0)
        print("contato adicionado: \(contato.nome)")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dao.contatos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contato = dao.buscaContatoNaPosicao(posicao: indexPath.row)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ListaContatosViewControllerTableViewController.cellIdentifier) as? CellContact
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: ListaContatosViewControllerTableViewController.cellIdentifier) as? CellContact
        }

        // Configure the cell...
        cell!.bind(contato: contato)

        return cell!
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dao.remove(posicao: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        linhaDestaque = indexPath
        let contatoSelecionado = dao.buscaContatoNaPosicao(posicao: indexPath.row)
        exibeFormulario(contato: contatoSelecionado)
    }
    
    func exibeFormulario(contato:Contato) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formulario = storyboard.instantiateViewController(withIdentifier: "Form-Contato") as! FormularioContatoViewController
        formulario.delegate = self
        formulario.contato = contato
        self.navigationController?.pushViewController(formulario, animated: true)
    }


}
