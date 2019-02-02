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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
