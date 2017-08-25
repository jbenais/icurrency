//
//  ViewController.swift
//  iCurrency
//
//  Created by Julia Benaïs on 25/08/2017.
//  Copyright © 2017 Julia Benaïs. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    @IBOutlet weak var fromText: UITextField!
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func convertButton(_ sender: Any)
    {
        // DO THE CONVERSION
    }
    
    let fromPickerView = UIPickerView()
    let toPickerView = UIPickerView()
    var currencies:[String] = ["EUR", "USD", "DRH", "LIV", "SHEK"]
    var values:[Double] = []
    var activeCurrency : Double = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (pickerView.tag == 1)
        {
            fromText.text = currencies[row]
        }
        else
        {
            toText.text = currencies[row]
        }
        self.view.endEditing(false)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fromPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.delegate = self
        toPickerView.dataSource = self
        fromText.inputView = fromPickerView
        toText.inputView = toPickerView
        fromPickerView.tag = 1
        toPickerView.tag = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

