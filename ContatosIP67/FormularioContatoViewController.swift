//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios8043 on 05/01/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import UIKit
import CoreLocation

class FormularioContatoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var site: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(selecionarFoto(sender:)))
        self.imageView.addGestureRecognizer(tap)
        imageView.layer.borderColor = UIColor.lightGray.cgColor
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
    
    @IBAction func buscarCoordenadas(sender: UIButton) {
        
        if !(self.endereco.text?.isEmpty)! {
        
            loading.startAnimating()
            sender.isEnabled = false
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(self.endereco.text!, completionHandler: {(resultado, error) in
                if error == nil && resultado!.count > 0{
                    let placemark = resultado![0]
                    let coordenada = placemark.location!.coordinate
                    
                    self.latitude.text = coordenada.latitude.description
                    self.longitude.text = coordenada.longitude.description
                }
                self.loading.stopAnimating()
                sender.isEnabled = true
            })
        } else {
            let alert = UIAlertController(title: "Aviso", message: "Informe um endereço para pesquisar!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func atualizaContato() {
        pegarDadosDoFormulario()
        self.delegate?.contatoAtualizado(contato)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func pegarDadosDoFormulario() {
        if contato == nil{
            contato = self.dao.novoContato()
        }
        
        contato.nome = nome.text
        contato.endereco = endereco.text
        contato.telefone = telefone.text
        contato.site = site.text
        if let foto = self.imageView.image {
            contato.foto = foto
        }
        if let latitude = Double(self.latitude.text!){
            contato.latitude = latitude as NSNumber
        }
        
        if let longitude = Double(self.longitude.text!){
            contato.longitude = longitude as NSNumber
        }
    }
    
    func preencheFormulario() {
        nome.text = contato.nome
        endereco.text = contato.endereco
        telefone.text = contato.telefone
        site.text = contato.site
        if let foto = contato.foto{
            imageView.image = foto
        }
        latitude.text = contato.latitude?.description
        longitude.text = contato.longitude?.description
    }
    
    func selecionarFoto(sender: AnyObject) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //câmera disponível
            var nome :String = ""
            
            if contato != nil{
                nome = contato.nome
            }
            
            let alert = UIAlertController(title: "Escolha foto do contato", message: nome, preferredStyle: .actionSheet)
            
            let tirarFoto = UIAlertAction(title: "Tirar foto", style: .default) { (action) in
                self.pergarImage(da: .camera)
            }
            let escolherFoto = UIAlertAction(title: "Escolher da biblioteca", style: .default) { (action) in
                self.pergarImage(da: .photoLibrary)
            }
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(tirarFoto)
            alert.addAction(escolherFoto)
            
            self.present(alert, animated: true, completion: nil)
        } else{
            //usar biblioteca
            self.pergarImage(da: .photoLibrary)
        }
    }
    
    func pergarImage(da sourceType : UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelecionada = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = imageSelecionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

