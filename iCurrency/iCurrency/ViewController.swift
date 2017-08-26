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
    
    @IBAction func dateChanged(_ sender: UITextField)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for:UIControlEvents.valueChanged)
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePickerView.maximumDate = NSDate() as Date
        var components = DateComponents()
        components.year = -17
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        datePickerView.minimumDate = minDate
        
    }
    @IBAction func swapButton(_ sender: Any)
    {
        if (toText.text != "" && fromText.text != "")
        {
            if (tmp & 1 == 0)
            {
                let swap = toText.text
                toText.text = fromText.text
                fromText.text = swap
                tmp = tmp & 1
            }
            else
            {
                let swap = fromText.text
                fromText.text = toText.text
                toText.text = swap
                tmp = tmp & 1
            }
        }
    }
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var wrongCurrencies: UILabel!
    
    @IBAction func convertButton(_ sender: Any)
    {
        if !currencies.contains(toText.text!) || !currencies.contains(fromText.text!)
        {
            wrongCurrencies.text = "Please choose valid currencies"
            wrongCurrencies.isHidden = false
        }
        else if self.amount.text == ""
        {
            alertAmount.text = "Please insert an amount"
            alertAmount.isHidden = false
        }
        else if let doubleValue = Double(self.amount.text!)
        {
            if doubleValue < 0
            {
                alertAmount.text = "Please insert a positive amount"
                alertAmount.isHidden = false
            }

            else
            {
                alertAmount.isHidden = true
                wrongCurrencies.isHidden = true
                let request = "http://api.fixer.io/latest?base=\(fromText.text! as String)&symbols=\(toText.text! as String)&date=\(date.text! as String)"
                Alamofire.request(request).responseJSON { response in
                    let rescode = response.response?.statusCode
                    if rescode == 200
                    {
                        if let json = response.result.value
                        {
                            let rate = json as! NSDictionary
                            let cur = rate["rates"] as! NSDictionary
                            if (cur.count == 0)
                            {
                                self.errorNotFound()
                            }
                            else
                            {
                                let value = cur.allValues[0] as! Double * Double(self.amount.text!)!
                                self.resultLabel.text = String(value)
                            }
                            
                        }
                    }
                    else
                    {
                        
                        self.sendAlert()
                    }
                }
            }
        }
        else
        {
            alertAmount.text = "Please insert a valid data"
            self.alertAmount.isHidden = false
        }
    }
    
    @IBOutlet weak var alertAmount: UILabel!
    
    let fromPickerView = UIPickerView()
    let toPickerView = UIPickerView()
    var currencies:[String] = []
    var values:[Double] = []
    var activeCurrency : Double = 0
    let datePickerView: UIDatePicker = UIDatePicker()
    var tmp : Int = 0

    func errorNotFound()
    {
        let alert = UIAlertController(title: "Oops! An error occured", message: "This information is not available in our database", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    func sendAlert()
    {
        let alert = UIAlertController(title: "Oops! An error occured", message: " It appears that some fields are missing or invalid", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
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
        loadCurrencies()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePickerView.maximumDate = NSDate() as Date
        var components = DateComponents()
        components.year = -17
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        datePickerView.minimumDate = minDate
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        date.inputView = datePickerView
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
    
    override func viewWillAppear(_ animated: Bool)
    {
    }
    
    func loadCurrencies()
    {
        Alamofire.request("http://api.fixer.io/latest").responseJSON(completionHandler: {
            response in
            if let values = response.result.value
            {
                let json = values as! NSDictionary
                let curr = json["rates"] as! NSDictionary
                for (key, _) in curr
                {
                    self.currencies.append(key as! String)
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func datePickerValueChanged(sender: UIDatePicker)
    {
        let format = DateFormatter()
        format.dateStyle = DateFormatter.Style.full
        format.dateFormat = "yyyy-MM-dd"
        date.text = format.string(from: sender.date)

    }
    

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    
}

