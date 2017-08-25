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
        if amount.text == ""
        {
            alertAmount.isHidden = false
        }
        else
        {
            datePicker.isHidden = true;
            alertAmount.isHidden = true
            let request = "http://api.fixer.io/latest?base=\(fromText.text! as String)&symbols=\(toText.text! as String)&date=\(date.text! as String)"
            Alamofire.request(request).responseJSON { response in
                if let json = response.result.value
                {
                    let rate = json as! NSDictionary
                    let cur = rate["rates"] as! NSDictionary
                    let value = cur.allValues[0] as! Double + Double(self.amount.text!)!
                    self.resultLabel.text = String(value)
                }
                
            }
        }
        
    }
    @IBOutlet weak var alertAmount: UILabel!
    
    let fromPickerView = UIPickerView()
    let toPickerView = UIPickerView()
    var currencies:[String] = ["EUR", "USD", "DRH", "LIV", "GBP"]
    var values:[Double] = []
    var activeCurrency : Double = 0
    let datePicker = UIDatePicker()
    
    
    
    
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
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(ViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        date.inputView = datePicker
        fromPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.delegate = self
        toPickerView.dataSource = self
        fromText.inputView = fromPickerView
        toText.inputView = toPickerView
        fromPickerView.tag = 1
        toPickerView.tag = 2
        alertAmount.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func datePickerValueChanged(sender: UIDatePicker)
    {
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.full
        format.dateFormat = "yyyy-MM-dd"
        date.text = format.string(from: sender.date)
    }

}

