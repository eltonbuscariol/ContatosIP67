//
//  GerenciadorDeAcoes.swift
//  ContatosIP67
//
//  Created by ios8043 on 19/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import UIKit

class GerenciadorDeAcoes {
    let contato:Contato
    var controller:UIViewController!
    
    init(do contato:Contato) {
        self.contato = contato
    }
    
    func exibirAcoes(em controller:UIViewController){
        self.controller = controller
        
        let alertView = UIAlertController(title: self.contato.nome, message: nil, preferredStyle: .actionSheet)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        let ligarParaContato = UIAlertAction(title: "Ligar", style: .default, handler: { action in
            self.ligar()
        })
        
        let exibirContatoNoMapa = UIAlertAction(title: "Visualizar no Mapa", style: .default, handler: { action in
            self.abrirMapa()
        })
        
        let exibirSiteDoContato = UIAlertAction(title: "Visualizar Site", style: .default, handler: { action in
            self.abrirNavegador()
        })
        
        alertView.addAction(cancelar)
        alertView.addAction(ligarParaContato)
        alertView.addAction(exibirContatoNoMapa)
        alertView.addAction(exibirSiteDoContato)
        
        self.controller.present(alertView, animated: true, completion: nil)
    }
    
    private func ligar(){
        let device = UIDevice.current
        
        if device.model == "iPhone" {
            print("UUID \(device.identifierForVendor!)")
            AbrirAplicativo(com: "tel:\(self.contato.telefone!)")
        } else{
            let alert = UIAlertController(title: "Impossível fazer ligações", message: "Seu dispositivo não é um iPhone", preferredStyle: .alert)
            self.controller.present(alert, animated: true, completion: nil)
        }
    }
    
    private func abrirNavegador(){
        var url = contato.site!
        
        if !url.hasPrefix("http://"){
            url = "http://" + url
        }
        
        AbrirAplicativo(com: url)
    }
    private func abrirMapa(){
        let url = ("http://maps.google.com/maps?q=" + self.contato.endereco!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        AbrirAplicativo(com: url)
    }
    
    private func AbrirAplicativo(com url:String){
        UIApplication
            .shared
            .open(URL(string: url)!, options: [:], completionHandler: nil)
    }
}
