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
    
    lazy var sosButton = UIButton(type: UIButton.ButtonType.system)

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
        self.sosButton.setTitle("报警", for: UIControl.State.normal)
        self.sosButton.backgroundColor = UIColor.white
        self.sosButton.addTarget(self, action: #selector(didTappedSOSButton(button:)), for: UIControl.Event.touchUpInside)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "重要信息", message: "如果确定报警，App会使用你的个人号码向12110发送报警信息。如果虚假报警，公安机关有权依据《治安管理处罚法》的相关规定对当事人处以拘留和罚款。因报假案造成严重社会危害性，已经构成刑事犯罪的，则需要依法追究当事人刑事责任。", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "同意", style: UIAlertAction.Style.default) { (action) in
            
        })
        alert.addAction(UIAlertAction(title: "不同意", style: UIAlertAction.Style.cancel) { (action) in
            exit(0);
        })
        self.present(alert, animated: true, completion: nil)
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
        
        let alert = UIAlertController(title: "报警到：12110\(params["cityZoneCode"] ?? "")", message: sosMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (action) in
            
        })
        alert.addAction(UIAlertAction(title: "报警！", style: UIAlertAction.Style.destructive) { (action) in
            if (MFMessageComposeViewController.canSendText()) {
                let smsController = MFMessageComposeViewController()
                smsController.body = sosMessage
                smsController.recipients = ["12110\(params["cityZoneCode"] ?? "")"]
                smsController.messageComposeDelegate = self
                self.present(smsController, animated: true, completion: nil)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
}

