//
//  WelcomeCreateAccountViewController.swift
//  bitbank_wallet
//
//  Created by 麦志泉 on 16/4/18.
//  Copyright © 2016年 bitbank. All rights reserved.
//

import UIKit

class WelcomeCreateAccountViewController: UIViewController {
    
    /// MARK: - 成员变量
    @IBOutlet var buttonConfirm: UIButton!
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldConfirmPassword: UITextField!
    
    var phrase = ""             //密语
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - 控制器方法
extension WelcomeCreateAccountViewController {
    
    func setupUI() {
        self.navigationItem.title = "Confirm Wallet".localized()
    }
    
    //检测输入值是否合法
    func checkValue() -> Bool {
        if self.textFieldUserName.text!.isEmpty {
            SVProgressHUD.showInfo(withStatus: "Username is empty".localized())
            
            return false
        }
        
        if self.textFieldPassword.text!.isEmpty {
            SVProgressHUD.showInfo(withStatus: "Password is empty".localized())
            return false
        }
        
        if self.textFieldConfirmPassword.text!.isEmpty {
            SVProgressHUD.showInfo(withStatus: "Confirm password is empty".localized())
            return false
        }
        if self.textFieldConfirmPassword.text != self.textFieldPassword.text! {
            SVProgressHUD.showInfo(withStatus: "Passwords is different".localized())
            return false
        }
        
        return true
    }
    
    
    
    /**
     点击确认按钮
     
     - parameter sender:
     */
    @IBAction func handleConfirmPress(_ sender: AnyObject?) {
        if self.checkValue() {
            let password = self.textFieldPassword.text!.trim()
            //创建钱包
            guard let wallet = CHBTCWallets.createWallet(self.phrase, password: password) else {
                SVProgressHUD.showError(withStatus: "Create wallet failed".localized())
                return
            }
            
            //创建默认HD账户
            let nickName = self.textFieldUserName.text!
            guard let account = wallet.createHDAccount(nickName) else {
                SVProgressHUD.showError(withStatus: "Create wallet account failed".localized())
                return
            }
            CHBTCWallets.sharedInstance.password = password
            CHWalletWrapper.selectedAccountIndex = account.index
            
            //配置默认账户数据库
            //_ = RealmDBHelper.setDefaultAccountDB(address: CHWalletWrapper.selectedAccount!)
            self.dismiss(animated: true, completion: nil)
            
            
        }
    }
}

// MARK: - 实现输入框代理方法
extension WelcomeCreateAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.textFieldUserName {
            self.textFieldPassword .becomeFirstResponder()
        } else if textField === self.textFieldPassword {
            self.textFieldConfirmPassword .becomeFirstResponder()
        } else if textField == self.textFieldConfirmPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharOfPassword = 50
        
        if(textField == self.textFieldPassword
            || textField == self.textFieldConfirmPassword
            || textField == self.textFieldUserName) {
            if (range.location>(maxCharOfPassword - 1)) {
                return false
            }
        }
        
        
        return true;
    }
    
}
