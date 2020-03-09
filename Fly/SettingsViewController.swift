//
//  SettingsViewController.swift
//  Fly
//
//  Created by Janak Malla on 3/7/20.
//  Copyright © 2020 Janak Malla. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchOne: CustomSwitch!
    @IBOutlet weak var switchTwo: CustomSwitch!
    @IBOutlet weak var switchThree: CustomSwitch!
    @IBOutlet weak var doneButton: UIButton!
    var useAutomaticReminders = UserDefaults.standard.bool(forKey: "USE_AUTO_REMINDERS")
    var useManualReminders = UserDefaults.standard.bool(forKey: "USE_MANUAL_REMINDERS")
    var justForFun = UserDefaults.standard.bool(forKey: "JUST_FOR_FUN")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.tintColor = UserDefaults.standard.bool(forKey: "FLY_IS_ZIPPED")
            ? UIColor.init(red: 0.28, green: 0.745, blue: 0.44, alpha: 1)
            : UIColor.red
        
        for currentSwitch in [switchOne, switchTwo, switchThree] {
            currentSwitch?.thumbImage = currentSwitch?.isOn ?? true
                ? UIImage(named: "zippers-closed-vertical")?.cgImage
                : UIImage(named: "zippers-open-vertical")?.cgImage
        }
        switchOne.addTarget(self, action: #selector(self.autoReminderSettingChanged(_:)), for: .valueChanged)
        switchTwo.addTarget(self, action: #selector(self.manualReminderSettingChanged(_:)), for: .valueChanged)
        switchThree.addTarget(self, action: #selector(self.justForFunSettingChanged(_:)), for: .valueChanged)
        
        switchOne.attachedKey = "USE_AUTO_REMINDERS"
        switchTwo.attachedKey = "USE_MANUAL_REMINDERS"
        switchThree.attachedKey = "JUST_FOR_FUN"
        
        refreshSwitches()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshSwitches()
        super.viewDidAppear(animated)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        presentationController?.delegate?.presentationControllerDidDismiss?(self.presentationController!)
        super.dismiss(animated: true, completion: completion)
    }
    
    @objc func autoReminderSettingChanged(_ sender: Any) {
        guard let sender = sender as? CustomSwitch else { return }
        useAutomaticReminders = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "USE_AUTO_REMINDERS")
    }
    
    @objc func manualReminderSettingChanged(_ sender: Any) {
        guard let sender = sender as? CustomSwitch else { return }
        useManualReminders = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "USE_MANUAL_REMINDERS")
    }
    
    @objc func justForFunSettingChanged(_ sender: Any) {
        guard let sender = sender as? CustomSwitch else { return }
        justForFun = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "JUST_FOR_FUN")
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func refreshSwitches() {
        useAutomaticReminders = UserDefaults.standard.bool(forKey: "USE_AUTO_REMINDERS")
        useManualReminders = UserDefaults.standard.bool(forKey: "USE_MANUAL_REMINDERS")
        justForFun = UserDefaults.standard.bool(forKey: "JUST_FOR_FUN")
        switchOne.isOn = useAutomaticReminders
        switchTwo.isOn = useManualReminders
        switchThree.isOn = justForFun
    }
}
