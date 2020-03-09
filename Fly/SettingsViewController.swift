//
//  SettingsViewController.swift
//  Fly
//
//  Created by Janak Malla on 3/7/20.
//  Copyright © 2020 Janak Malla. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var switchOne: CustomSwitch!
    @IBOutlet weak var switchTwo: CustomSwitch!
    @IBOutlet weak var switchThree: CustomSwitch!
    @IBOutlet weak var doneButton: UIButton!
    var useAutomaticReminders = UserDefaults.standard.bool(forKey: "USE_AUTO_REMINDERS")
    var useManualReminders = UserDefaults.standard.bool(forKey: "USE_MANUAL_REMINDERS")
    var justForFun = UserDefaults.standard.bool(forKey: "JUST_FOR_FUN")
    var pickerDataOne = [String]()
    var pickerDataTwo = [String]()
    var pickerDataThree = [String]()
    var pickerDataFour = [String]()
    var pickerData = [[String]]()    
    
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
        setUpPickerView()
        if useManualReminders {
            self.pickerView.isHidden = false
            stackView.setCustomSpacing(-5, after: stackView.arrangedSubviews[1])
            stackView.setCustomSpacing(-5, after: stackView.arrangedSubviews[2])
        }
        
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
        if useManualReminders {
            UIView.animate(withDuration: 1, animations: {
                self.pickerView.isHidden = false
                self.stackView.setCustomSpacing(-5, after: self.stackView.arrangedSubviews[1])
                self.stackView.setCustomSpacing(-5, after: self.stackView.arrangedSubviews[2])
            })
        } else {
            self.stackView.setCustomSpacing(0, after: self.stackView.arrangedSubviews[1])
            self.stackView.setCustomSpacing(0, after: self.stackView.arrangedSubviews[2])
            UIView.animate(withDuration: 1, animations: {
                self.pickerView.isHidden = true
            })
        }
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
    
    private func setUpPickerView() {
        pickerDataOne = ["Every Day", "Weekdays", "Weekends"]
        pickerDataTwo = createHourArray()
        pickerDataThree = createMinuteArray()
        pickerDataFour = ["AM", "PM"]
        pickerData = [pickerDataOne, pickerDataTwo, pickerDataThree, pickerDataFour]
        pickerView.delegate = self
        pickerView.heightAnchor.constraint(lessThanOrEqualToConstant: 100.0).isActive = true
        if let savedManualReminder = UserDefaults.standard.string(forKey: "SAVED_MANUAL_REMINDER_TIME") {
            let components = savedManualReminder.components(separatedBy: "\n")
            pickerView.selectRow(Int(components[0])!, inComponent: 0, animated: true)
            pickerView.selectRow(Int(components[1])!, inComponent: 1, animated: true)
            pickerView.selectRow(Int(components[2])!, inComponent: 2, animated: true)
            pickerView.selectRow(Int(components[3])!, inComponent: 3, animated: true)
        }
    }
    
    private func createMinuteArray() -> [String] {
        var array: [String] = []
        for i in 0...59 {
            "\(i)".count == 1 ? array.append("0\(i)") : array.append("\(i)")
        }
        return array
    }
    
    private func createHourArray() -> [String] {
        var array: [String] = []
        for i in 1...12 {
            array.append("\(i)")
        }
        return array
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerDataOne.count
        } else if component == 1 {
            return pickerDataTwo.count
        } else if component == 2 {
            return pickerDataThree.count
        } else if component == 3 {
            return pickerDataFour.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let w = pickerView.frame.size.width
        return component == 0 ? (1 / 2.0) * w : (1 / 6.0) * w
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Gill Sans", size: 20)
            pickerLabel?.textAlignment = .left
        }
        pickerLabel?.text = pickerData[component][row]

        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NotificationHelper.removePendingNotification(notificationId: UUID().uuidString + "checkthatzipper" + "manual")
        let hour = pickerData[1][pickerView.selectedRow(inComponent: 1)]
        let minute = pickerData[2][pickerView.selectedRow(inComponent: 2)]
        let amPeriod =  pickerData[3][pickerView.selectedRow(inComponent: 3)]
        let repeatSchedule = pickerData[0][pickerView.selectedRow(inComponent: 0)]
        NotificationHelper.createFlyNotificationManual(
            hour: Int(hour) ?? 9,
            minute: Int(minute) ?? 5,
            amPeriod: "AM" == amPeriod,
            repeatSchedule: repeatSchedule
        )
        UserDefaults.standard.set(
            """
            \(pickerView.selectedRow(inComponent: 0))
            \(pickerView.selectedRow(inComponent: 1))
            \(pickerView.selectedRow(inComponent: 2))
            \(pickerView.selectedRow(inComponent: 3))
            """,
            forKey: "SAVED_MANUAL_REMINDER_TIME")
    }
}
