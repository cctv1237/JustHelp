//
//  ViewController.swift
//  JustHelp
//
//  Created by LongFan on 2018/9/1.
//  Copyright © 2018 Long Fan. All rights reserved.
//

import UIKit
import SnapKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    let TEXT_FIELD_HEIGHT = 38
    let TEXT_FIELD_PADDING = 30
    
    lazy var cityZoneCodeTextField = UITextField()
    
    lazy var plateNumberTextField = UITextField()
    
    lazy var carColorTextField = UITextField()
    lazy var carBrandTextField = UITextField()
    
    lazy var fromTextField = UITextField()
    lazy var toTextField = UITextField()
    
    lazy var sosButton = UIButton(type: UIButtonType.system)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.cityZoneCodeTextField)
        self.view.addSubview(self.plateNumberTextField)
        self.view.addSubview(self.carColorTextField)
        self.view.addSubview(self.carBrandTextField)
        self.view.addSubview(self.fromTextField)
        self.view.addSubview(self.toTextField)
        self.view.addSubview(self.sosButton)
        
        self.view.backgroundColor = UIColor.lightGray
        self.cityZoneCodeTextField.placeholder = "请输入城市区号"
        self.plateNumberTextField.placeholder = "请输入车牌号"
        self.carColorTextField.placeholder = "请输入车身颜色"
        self.carBrandTextField.placeholder = "请输入汽车品牌型号"
        self.fromTextField.placeholder = "请输入出发地"
        self.toTextField.placeholder = "请输入目的地"
        for subview in self.view.subviews {
            if subview is UITextField {
                let textField = subview as! UITextField;
                textField.backgroundColor = UIColor.white
                textField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
            }
        }
        self.sosButton.setTitle("报警", for: UIControlState.normal)
        self.sosButton.backgroundColor = UIColor.white
        self.sosButton.addTarget(self, action: #selector(didTappedSOSButton(button:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.cityZoneCodeTextField.snp.makeConstraints { (make) in
            make.height.equalTo(TEXT_FIELD_HEIGHT)
            make.top.equalTo(self.view).offset(100)
            make.left.equalTo(self.view).offset(50)
            make.right.equalTo(self.view).offset(-50)
        }
        
        self.plateNumberTextField.snp.makeConstraints { (make) in
            make.height.equalTo(TEXT_FIELD_HEIGHT)
            make.top.equalTo(self.cityZoneCodeTextField.snp.bottom).offset(TEXT_FIELD_PADDING)
            make.left.equalTo(self.cityZoneCodeTextField)
            make.right.equalTo(self.cityZoneCodeTextField)
        }
        
        self.carColorTextField.snp.makeConstraints { (make) in
            make.height.equalTo(TEXT_FIELD_HEIGHT)
            make.top.equalTo(self.plateNumberTextField.snp.bottom).offset(TEXT_FIELD_PADDING)
            make.left.equalTo(self.cityZoneCodeTextField)
            make.right.equalTo(self.cityZoneCodeTextField)
        }
        
        self.carBrandTextField.snp.makeConstraints { (make) in
            make.height.equalTo(TEXT_FIELD_HEIGHT)
            make.top.equalTo(self.carColorTextField.snp.bottom).offset(TEXT_FIELD_PADDING)
            make.left.equalTo(self.cityZoneCodeTextField)
            make.right.equalTo(self.cityZoneCodeTextField)
        }
        
        self.fromTextField.snp.makeConstraints { (make) in
            make.height.equalTo(TEXT_FIELD_HEIGHT)
            make.top.equalTo(self.carBrandTextField.snp.bottom).offset(TEXT_FIELD_PADDING)
            make.left.equalTo(self.cityZoneCodeTextField)
            make.right.equalTo(self.cityZoneCodeTextField)
        }
        
        self.toTextField.snp.makeConstraints { (make) in
            make.height.equalTo(TEXT_FIELD_HEIGHT)
            make.top.equalTo(self.fromTextField.snp.bottom).offset(TEXT_FIELD_PADDING)
            make.left.equalTo(self.cityZoneCodeTextField)
            make.right.equalTo(self.cityZoneCodeTextField)
        }
        
        self.sosButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(self.toTextField.snp.bottom).offset(TEXT_FIELD_PADDING)
            make.left.equalTo(self.cityZoneCodeTextField)
            make.right.equalTo(self.cityZoneCodeTextField)
        }
    }
    
    @objc func didTappedSOSButton(button: UIButton) {
        let annuciator = JHAnnunciator()
        let params = NSMutableDictionary()
        params["cityZoneCode"] = self.cityZoneCodeTextField.text
        params["plateNumber"] = self.plateNumberTextField.text
        params["carColor"] = self.carColorTextField.text
        params["carBrand"] = self.carBrandTextField.text
        params["from"] = self.fromTextField.text
        params["to"] = self.toTextField.text
        
        let sosMessage = annuciator.sos(params)
        
        let alert = UIAlertController(title: "Alert", message: sosMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel) { (action) in
            
        })
        alert.addAction(UIAlertAction(title: "send", style: UIAlertActionStyle.destructive) { (action) in
            if (MFMessageComposeViewController.canSendText()) {
                let smsController = MFMessageComposeViewController()
                smsController.body = sosMessage
                smsController.recipients = ["+8618521006525"]
                smsController.messageComposeDelegate = self
                self.present(smsController, animated: true, completion: nil)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
}

