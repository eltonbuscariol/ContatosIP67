//
//  ContatoDao.swift
//  ContatosIP67
//
//  Created by ios8043 on 05/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import Foundation

class ContatoDao: NSObject {
    static private var defaultDAO:ContatoDao!
    var contatos : Array<Contato>
    
    func adiciona(_ contato:Contato) {
        contatos.append(contato)
        print(contatos)
    }
    
    func buscaContatoNaPosicao(posicao:Int) -> Contato {
        return contatos[posicao]
    }
    
    func remove(posicao:Int) {
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
    }
}
