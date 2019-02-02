//
//  ContatoDao.swift
//  ContatosIP67
//
//  Created by ios8043 on 05/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import Foundation

class ContatoDao: CoreDataUtil {
    
    static private var defaultDAO:ContatoDao!
    var contatos : Array<Contato>
    
    func adiciona(_ contato:Contato) {
        contatos.append(contato)
        //print(contatos)
    }
    
    func buscaContatoNaPosicao(posicao:Int) -> Contato {
        return contatos[posicao]
    }
    
    func remove(posicao:Int) {
        getContext().delete(contatos[posicao])
        saveContext()
        contatos.remove(at: posicao)
    }
    
    func buscaPosicaoDoContato(_ contato:Contato) -> Int {
        return contatos.index(of: contato)!
    }
    
    static func sharedInstance() -> ContatoDao{
        if defaultDAO == nil {
            defaultDAO = ContatoDao()
        }
        
        return defaultDAO
    }
    
    override private init(){
        self.contatos = Array()
        super.init()
        inserirDadosIniciais()
        
        carregaContatos()
//        print("Caminho do BD: \(NSHomeDirectory())")
    }
    
    func inserirDadosIniciais() {
        let configuracoes = UserDefaults.standard
        
        let dadosInseridos = configuracoes.bool(forKey: "dados_inseridos")
        
        if !dadosInseridos{
            
            let caelumSP : Contato = novoContato()
            
            caelumSP.nome = "Caelum SP"
            caelumSP.endereco = "São Paulo, SP, Rua Vergueiro, 3185"
            caelumSP.telefone = "01155712751"
            caelumSP.site = "http://www.caelum.com.br"
            caelumSP.latitude = -23.5883034
            caelumSP.longitude = -46.632369
            
            self.saveContext()
            
            configuracoes.set(true, forKey: "dados_inseridos")
            
            configuracoes.synchronize()
        }
    }
    
    func carregaContatos(){
        let busca = NSFetchRequest<Contato>(entityName: "Contato")
        
        let orderPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        busca.sortDescriptors = [orderPorNome]
        
        do {
            contatos = try getContext().fetch(busca)
        } catch let error as NSError {
            print("Fetch falhou: \(error.localizedDescription)")
        }
    }
    
    func novoContato() -> Contato {
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: getContext()) as! Contato
    }
}
