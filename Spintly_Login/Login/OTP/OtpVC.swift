//
//  OtpVC.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 24/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import UIKit

protocol OTPRequestDelegate {
    func didEnterOTP(_ otp: String, completion: @escaping (Error?)->())
    func didRequestResend(completion: @escaping (Error?)->())
}

class OtpVC: UIViewController {

    @IBOutlet weak var OTPSentLabel: UILabel!
    @IBOutlet weak var OTPInputTextField: UITextField!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    var delegate : OTPRequestDelegate!
    
    var resendWillInvalidateOTP = false
    var isSingleAttempt = false
    var timeoutInSeconds : Int?
    var destination : String = "your phone"
    
    private var remainingTime : Int!{
        didSet {
            timeRemainingLabel.text = "\(remainingTime ?? 0) seconds remaining"
        }
    }
    
    private var currentTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Verification"
        tapToHideKeyboard()
        OTPSentLabel.text = "An OTP has been sent to \(destination)"
        resetTimer()
    }

    @IBAction func resendOTPButtonPressed(_ sender: Any) {
        if resendWillInvalidateOTP {
            let alertController = UIAlertController(title: "Warning", message: "Resend may cause previously sent otp to be invalidated", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Resend", style: .default) { _ in
                self.requestResend()
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alertController, animated: true)
        } else {
            requestResend()
        }
        
    }
    
    @IBAction func verifyOTP() {
        guard OTPInputTextField.text?.count == 6 else {
            let errorController = UIAlertController(title: "Error", message: "OTP should be 6 digits long", preferredStyle: .alert)
            errorController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(errorController, animated: true)
            return
        }
        let alertController = UIAlertController.init(title: "Please wait", message: "Verifying...", preferredStyle: .alert)
        self.present(alertController, animated: true)
        delegate.didEnterOTP(OTPInputTextField.text!) { error in
            if let error = error as NSError? {
                alertController.dismiss(animated: true) {
                    let message = error.userInfo["__type"] as? String == "NotAuthorizedException" ? "Incorrect OTP" : error.userInfo["message"] as? String ?? error.localizedDescription
                    let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    if (self.isSingleAttempt) {
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                    }
                    self.present(errorAlert, animated: true)
                }
            } else {
                alertController.title = "Success"
                alertController.message = "OTP verification done"
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                self.resetTimer()
            }
        }
    }

    private func requestResend() {
        let alertController = UIAlertController(title: "Please wait", message: "Requesting to resend otp...", preferredStyle: .alert)
        self.present(alertController, animated: true)
        delegate?.didRequestResend(completion: { error in
            if let error = error as NSError? {
                alertController.dismiss(animated: true) {
                    let message = error.userInfo["message"] as? String ?? error.localizedDescription
                    let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(errorAlert, animated: true)
                }
            } else {
                alertController.title = "Success"
                alertController.message = "Resend request acknowledged"
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                self.resetTimer()
            }
        })
    }
    
    private func resetTimer() {
        currentTimer?.invalidate()
        timeRemainingLabel.isHidden = true
        if let timeoutInSeconds = timeoutInSeconds {
            remainingTime = timeoutInSeconds
            currentTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if !self.isViewLoaded {
                    timer.invalidate()
                } else {
                    self.remainingTime -= 1
                    if self.remainingTime == 0 {
                        timer.invalidate()
                        self.timeRemainingLabel.isHidden = true
                    } else {
                        self.timeRemainingLabel.isHidden = false
                    }
                }
            }
        }
    }
}

