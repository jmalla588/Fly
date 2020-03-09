//
//  ViewController.swift
//  Fly
//
//  Created by Janak Malla on 3/4/20.
//  Copyright © 2020 Janak Malla. All rights reserved.
//

import UIKit

class FlyMainViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var steppingStackView: UIStackView!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minuteStepper: UIStepper!
    @IBOutlet weak var secondStepper: UIStepper!
    @IBOutlet weak var settings: UILabel!
    @IBOutlet weak var gear: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    var currentState: Bool = true // true means fly == zipped
    var newSwitch: CustomSwitch = CustomSwitch()
    var autoReminderTimeMinutes = 0
    var autoReminderTimeSeconds = 10
    var useAutoReminders = UserDefaults.standard.boolOptional(forKey: "USE_AUTO_REMINDERS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationAuthorization()
        setUpSwitch()
        getExistingReminderSettings()
        autoReminderTimeMinutes = Int(minuteStepper.value)
        autoReminderTimeSeconds = Int(secondStepper.value)
        gear.addGestureRecognizer(tapGesture)
        gear.isUserInteractionEnabled = true
        gear.tintColor = currentState ? newSwitch.onTintColor : newSwitch.offTintColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlpha(alpha: 0) // set alpha of all visible objects to 0 in order to let them fade in on app load
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        useAutoReminders = UserDefaults.standard.boolOptional(forKey: "USE_AUTO_REMINDERS")
        if let useAutoReminders = useAutoReminders, !useAutoReminders {
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.reminderLabel.alpha = 0
                self.steppingStackView.alpha = 0
            })
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.setAlphaMinusReminderSettings(alpha: 1)
            })
        } else {
            // set alpha of all visible objects to 1 in order to let them fade in on app load
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.setAlpha(alpha: 1)
             })
        }
        rotateAnimation(imageView: gear)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if segue.identifier == "settingsSegue" {
        segue.destination.presentationController?.delegate = self;
      }
    }
    
    @objc func switchChanged(_ sender: Any) {
        guard let sender = sender as? CustomSwitch else { return }
        currentState = sender.isOn
        print("Current Toggle State: \(currentState)")
        gear.tintColor = currentState ? newSwitch.onTintColor : newSwitch.offTintColor
        
        currentState
            ? UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            : NotificationHelper.createFlyNotificationAuto(minutes: autoReminderTimeMinutes, seconds: autoReminderTimeSeconds)
    }
    
    func presentationControllerDidDismiss(
      _ presentationController: UIPresentationController)
    {
        viewDidAppear(true)
    }
    
    
    //MARK: PRIVATE
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {_,_ in }
    }
    
    private func setUpSwitch() {
        let desiredSwitchWidth = self.view.frame.width/1.05
        let desiredSwitchHeight = desiredSwitchWidth/2
        let desiredSwitchX = self.view.center.x - (desiredSwitchWidth/2)
        let desiredSwitchY = self.view.center.y - (desiredSwitchHeight/2)
        newSwitch = CustomSwitch(frame: CGRect(x: desiredSwitchX, y: desiredSwitchY, width: desiredSwitchWidth, height: desiredSwitchHeight))
        newSwitch.offText = "UNZIPPED"
        newSwitch.onText = "ZIPPED"
        newSwitch.attachedKey = "FLY_IS_ZIPPED"
        self.view.addSubview(newSwitch)
        newSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        newSwitch.isOn = UserDefaults.standard.bool(forKey: "FLY_IS_ZIPPED")
        newSwitch.thumbImage = newSwitch.isOn
            ? UIImage(named: "zippers-closed-vertical")?.cgImage
            : UIImage(named: "zippers-open-vertical")?.cgImage
        currentState = newSwitch.isOn
    }
    
    private func getExistingReminderSettings() {
        if let flyReminderMinutes = UserDefaults.standard.integerOptional(forKey: "FLY_REMINDER_MINUTES") {
            minutesLabel.text = "\(flyReminderMinutes)"
            minuteStepper.value = Double(flyReminderMinutes)
        }
        if let flyReminderSeconds = UserDefaults.standard.integerOptional(forKey: "FLY_REMINDER_SECONDS") {
            secondsLabel.text = "\(flyReminderSeconds)"
            secondStepper.value = Double(flyReminderSeconds)
        }
    }
    
    private func setAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, animations: {
            for item in [self.titleLabel, self.newSwitch, self.gear, self.settings, self.steppingStackView, self.reminderLabel] {
                if let item = item {
                    item.alpha = alpha
                }
            }
         })
    }
    
    private func setAlphaMinusReminderSettings(alpha: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, animations: {
            for item in [self.titleLabel, self.newSwitch, self.gear, self.settings] {
                if let item = item {
                    item.alpha = alpha
                }
            }
         })
    }
    
    @objc private func rotateAnimation(imageView:UIImageView, duration: CFTimeInterval = 4.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        rotateAnimation.isRemovedOnCompletion = false

        imageView.layer.add(rotateAnimation, forKey: nil)
    }
    
}

// MARK: Extension where all the IBActions live
extension FlyMainViewController {
    
    @IBAction func minuteStep(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        minutesLabel.text = String(format: "%.0f", stepper.value)
        UserDefaults.standard.set(Int(stepper.value), forKey: "FLY_REMINDER_MINUTES")
        autoReminderTimeMinutes = Int(stepper.value)
    }
        
    @IBAction func secondStep(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        secondsLabel.text = String(format: "%.0f", stepper.value)
        UserDefaults.standard.set(Int(stepper.value), forKey: "FLY_REMINDER_SECONDS")
        if autoReminderTimeSeconds == 59 && Int(stepper.value) == 0 {
            autoReminderTimeMinutes += 1
            UserDefaults.standard.set(autoReminderTimeMinutes, forKey: "FLY_REMINDER_MINUTES")
            minutesLabel.text = String(format: "%.0f", Double(autoReminderTimeMinutes))
            minuteStepper.value += 1
        } else if autoReminderTimeSeconds == 0 && Int(stepper.value) == 59 && autoReminderTimeMinutes != 0 {
            autoReminderTimeMinutes -= 1
            UserDefaults.standard.set(autoReminderTimeMinutes, forKey: "FLY_REMINDER_MINUTES")
            minutesLabel.text = String(format: "%.0f", Double(autoReminderTimeMinutes))
            minuteStepper.value -= 1
        }
        autoReminderTimeSeconds = Int(stepper.value)
    }
    
}
