//
//  TemperaturaViewController.swift
//  ContatosIP67
//
//  Created by ios8043 on 02/02/19.
//  Copyright © 2019 Caelum. All rights reserved.
//

import UIKit

class TemperaturaViewController: UIViewController {

    @IBOutlet weak var lblLocalidade: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var imgCondicaoAtual: UIImageView!
    @IBOutlet weak var lblTemperaturaAtual: UILabel!
    @IBOutlet weak var lblCondicaoAtual: UILabel!
    @IBOutlet weak var lblTemperaturaMin: UILabel!
    @IBOutlet weak var lblTemperaturaMax: UILabel!
    @IBOutlet weak var lblNomeContato: UILabel!
    @IBOutlet weak var lblEnderecoContato: UILabel!
    
    var contato:Contato?
    let URL_BASE = "https://api.openweathermap.org/data/2.5/weather?appid=d0e9fb7d08a57ac6e8c77a86749955d4&units=metric"
    let URL_BASE_IMAGE = "https://openweathermap.org/img/w/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cria notificação para detectar mudança de orientação em tempo real
        NotificationCenter.default.addObserver(self, selector: #selector(TemperaturaViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if let contato = self.contato{
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .short
            lblData.text = formatter.string(from: currentDate)
            buscaInformacoesDoClima(contato: contato)
        }
        
        //Caso o app seja iniciado em landscape
        orientationChanged()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func orientationChanged() {
        // Verifica ambiente (size classes)
        // Carrega campos de contato apenas se estivermos num ambiente wR (Plus e iPads em landscape)
        if sizeClass() == (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact) {
            lblNomeContato.text = contato?.nome
            lblEnderecoContato.text = contato?.endereco
        }
    }
    
    func buscaInformacoesDoClima(contato : Contato) {
        if let endpoint = URL(string: URL_BASE + "&lat=\(contato.latitude ?? 0)&lon=\(contato.longitude ?? 0)"){
            
            let session = URLSession(configuration: .default)
            
            print(endpoint)
            
            let task = session.dataTask(with: endpoint){(data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        
                        do{
                            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                                
                                let main = json["main"] as! [String:AnyObject]
                                let weather = (json["weather"] as! [AnyObject])[0] as! [String:AnyObject]
                                let sys = json["sys"] as! [String:AnyObject]
                                let temp_min = main["temp_min"] as! Int
                                let temp_max = main["temp_max"] as! Int
                                let icon = weather["icon"] as! String
                                let condicao = weather["main"] as! String
                                let temp_atual = main["temp"] as! Int
                                let country = sys["country"] as! String
                                let city = json["name"] as! String
                                
                                DispatchQueue.main.async {
                                    
                                    self.lblLocalidade.text = "\(city), \(country)"
                                    self.lblCondicaoAtual.text = "\(condicao)"
                                    self.lblTemperaturaAtual.text = "\(temp_atual.description)º"
                                    self.lblTemperaturaMin.text = "\(temp_min.description)º"
                                    self.lblTemperaturaMax.text = "\(temp_max.description)º"
                                    self.pegaImagem(icon: icon)
                                    
                                    self.lblCondicaoAtual.isHidden = false
                                    self.lblTemperaturaMin.isHidden = false
                                    self.lblTemperaturaMax.isHidden = false
                                }
                            }
                        } catch let erro as NSError {
                            print("Não foi possível fazer o parse do JSON: \(erro.localizedDescription)")
                        }

                    }
                    else{
                        print("Ocorreu algum problema com a requisição")
                    }
                }
            }
            task.resume()
        }
    }
    
    func pegaImagem(icon: String) {
        
        if let endpoint = URL(string: URL_BASE_IMAGE + icon + ".png"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: endpoint){ (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            print("Exibindo imagem")
                            self.imgCondicaoAtual.image = UIImage(data: data!)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController{
    func sizeClass() -> (UIUserInterfaceSizeClass, UIUserInterfaceSizeClass) {
        return (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass)
    }
}
