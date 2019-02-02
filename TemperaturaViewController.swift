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
    var contato:Contato?
    let URL_BASE = "https://api.openweathermap.org/data/2.5/weather?appid=d0e9fb7d08a57ac6e8c77a86749955d4&units=metric"
    let URL_BASE_IMAGE = "https://openweathermap.org/img/w/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contato = self.contato{
            buscaInformacoesDoClima(contato: contato)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                                let weather = json["weather"]![0] as! [String:AnyObject]
                                let temp_min = main["temp_min"] as! Double
                                let temp_max = main["temp_max"] as! Double
                                let icon = weather["icon"] as! String
                                let condicao = weather["main"] as! String
                                
                                DispatchQueue.main.async {
                                    print(condicao)
                                    print(temp_min)
                                    print(temp_max)
                                    print(icon)
                                    
                                    self.lblCondicaoAtual.text = condicao
                                    self.lblTemperaturaMin.text = temp_min.description + "º"
                                    self.lblTemperaturaMax.text = temp_max.description + "º"
                                    
                                }
                            }
                        } catch let erro as NSError {
                            print(erro.localizedDescription)
                        }
                    }
                }
            }
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
