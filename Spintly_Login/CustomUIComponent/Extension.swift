//
//  Extension.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 09/02/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift
import FlagPhoneNumber



extension UITextField {

    func textFieldStyle() {
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.1
    }
    
    func underLineTextField(_ color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func textFieldIcon(_ viewMode: String , _ image: String) {
        
        let imageUIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height:24))
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageUIView.addSubview(imageView)
        
        if (viewMode == "rightView") {
            self.rightView = imageUIView
            self.rightViewMode = .always
        } else {
            self.leftView = imageUIView
            self.leftViewMode = .always
        }
    }

}

extension UITextView {
    
    func underLineTextView(_ color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


extension UIButton {
    func borderButton(_ color: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        layer.cornerRadius = 4
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }
}

extension UINavigationController {

    func setStatusBar() {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.262745098, blue: 0.4588235294, alpha: 1)
        view.addSubview(statusBarView)
    }

}

extension UIColor {
    
    static func myColor() -> UIColor {
    if #available(iOS 13, *) {
        return UIColor.init { (trait) -> UIColor in
            // the color can be from your own color config struct as well.
            return trait.userInterfaceStyle == .dark ? UIColor.darkStatusColor() : UIColor.primaryColor()
        }
    }
     else { return UIColor.primaryColor() }
    }
    
    class func appThemeBlueColor() -> UIColor{
        return UIColor.init(red: 28, green: 112, blue: 159)!
    }
    class func darkBlueBackgroundColor() -> UIColor{
        return UIColor.init(red: 21, green: 61, blue: 90)!
    }
    
    
    class func inactiveWhite() -> UIColor {
        return UIColor.init(white: 0.5, alpha: 0.8)
    }
    class func activeOrangeColor() -> UIColor{
        return UIColor.init(red: 238, green: 85, blue: 48)!
    }
    
    class func greenLabelColor() -> UIColor{
        return UIColor.init(red: 60, green: 200, blue: 30)!
    }
    class func redLabelColor() -> UIColor{
        return UIColor.init(red: 208, green: 2, blue: 30)!
    }
    class func grayLabelColor() -> UIColor{
        return UIColor.init(red: 149, green: 149, blue: 149)!
    }
    
    
    class func appBackgroundColor() -> UIColor{
        return UIColor.init(red: 238, green: 238, blue: 238)!
    }
    class func viewBackgroundColor() -> UIColor{
        return UIColor.init(red: 255, green: 255, blue: 255)!
    }
    
    class func primaryColor() -> UIColor {
        return UIColor (red: 28/255.0, green: 111/255.0, blue: 159/255.0, alpha: 1.0)
    }

    class func primaryDarkColor() -> UIColor {
        return UIColor (red: 49/255.0, green: 67/255.0, blue: 117/255.0, alpha: 1.0)
    }

    class func redColor() -> UIColor {
        return UIColor (red: 244/255.0, green: 67/255.0, blue: 54/255.0, alpha: 1.0)
    }

    class func greenColor() -> UIColor {
        return UIColor (red: 76/255.0, green: 175/255.0, blue: 80/255.0, alpha: 1.0)
    }

    class func orangeColor() -> UIColor {
        return UIColor (red: 239/255.0, green: 106/255.0, blue: 0/255.0, alpha: 1.0)
    }

    class func greyColor() -> UIColor {
        return UIColor (red: 108/255.0, green: 121/255.0, blue: 127/255.0, alpha: 1.0)
    }

    class func darkBlueColor() -> UIColor {
        return UIColor (red: 0/255.0, green: 46/255.0, blue: 72/255.0, alpha: 1.0)
    }

    class func darkStatusColor() -> UIColor {
        return UIColor (red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
    }
    
}

extension UIViewController {
    
    func tapToHideKeyboard() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyBoard() {
        self.view.endEditing(true)
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension UIFont{
    
    static func boldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize:size)
    }
    
    static func lightFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize:size)
    }
    
}


extension UILabel{
    
    class func titleTextLabel(text: String) -> UILabel{
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldFontWithSize(size: 17)
        label.textColor = UIColor.darkBlueBackgroundColor()
        label.numberOfLines = 0
        return label
   }
    
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var bundleName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}

extension NSDictionary {
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                //print(error)
            }
        }
        return nil
    }
}

extension NSDate {
    
    class func getDateStringToFormat(inputDate: String, inputFormat: String, outputFormat: String) -> String {
        
        let localDate = NSDate.UTCToLocal(date: inputDate, inputDateFormat: inputFormat)

        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "UTC") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = NSTimeZone.local
        let date = dateFormatter.date(from: localDate!)!
        dateFormatter.dateFormat = outputFormat
        dateFormatter.locale = tempLocale // reset the locale
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: ((date as NSDate) as Date))
    }
    
    class func getDateStringToFormat_WithoutUTC(inputDate: String, inputFormat: String, outputFormat: String, convertToUTC: Bool) -> String {
        
        var localDate : String
        if convertToUTC {
            localDate = NSDate.UTCToLocal(date: inputDate, inputDateFormat: inputFormat)!
        }else{
            localDate = inputDate
        }
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "UTC") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = NSTimeZone.local
        let date = dateFormatter.date(from: localDate)!
        dateFormatter.dateFormat = outputFormat
        dateFormatter.locale = tempLocale // reset the locale
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: ((date as NSDate) as Date))
    }
    
    class func UTCToLocal(date: String, inputDateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let timeUTC = dateFormatter.date(from: date)
        
        if timeUTC != nil {
            dateFormatter.timeZone = NSTimeZone.local
            
            let localTime = dateFormatter.string(from: timeUTC!)
            return localTime
        }
        
        return nil
    }
    
    class func getStringFromDate(date: Date, outputFormat: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = outputFormat
        return formatter.string(from: date)
    }
    
    class func getDateFromString(date: String, inputFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        return formatter.date(from: date)
    }
    
    
    class func getTheArrayOfDaybetweenDates(fromDate: Date, toDate: Date) -> [String] {
        
        var daysArray = [String]()
        
        let days = round(toDate.daysSince(fromDate))
        
        if days == 0 {
            
            daysArray.append(toDate.dayName().lowercased())
            
        }else {
            
            if days > 8 {
                
                daysArray = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"]
                
            }else {
                
                let datesArray = NSDate.dates(from: fromDate, to: toDate)
                for dateDay in datesArray {
                    daysArray.append(dateDay.dayName().lowercased())
                }
            }
        }
        return daysArray
    }
    
    class func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension UITableView {
    
    func removeTopSpace() {
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableHeaderView = UIView(frame: frame)
    }
    
    func addFooterLoader() {
        
//        let backgroundView = UIView()
//        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 39)
//        backgroundView.backgroundColor = UIColor.clear
//        backgroundView.tag = 1000
        
//        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        let activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 39))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor.activeOrangeColor()
        activityIndicator.startAnimating()
//        backgroundView.addSubview(activityIndicator)
        self.tableFooterView = activityIndicator
    }
    
    func removeFooterLoader() {
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableFooterView = UIView(frame: frame)
    }
}

extension UIView {
  
  class func cardView() -> UIView{
      
      let view = UIView()
      view.backgroundColor = UIColor.viewBackgroundColor()
      view.cornerRadius = 8
      return view
  }
  
  class func cardViewWithShadow() -> UIView {
      
      let view = UIView()
      view.backgroundColor = UIColor.viewBackgroundColor()
      view.cornerRadius = 8
      view.dropShadow()
      return view
  }
  
  func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.8
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1
      
      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
  
  func activityStartAnimating(backgroundColor: UIColor) {
      
      let backgroundView = UIView()
      backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
      backgroundView.backgroundColor = backgroundColor
      backgroundView.tag = 1000
      
      var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
      activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
      activityIndicator.center = self.center
      activityIndicator.hidesWhenStopped = true
      activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
      activityIndicator.color = UIColor.activeOrangeColor()
      activityIndicator.startAnimating()
      
      backgroundView.addSubview(activityIndicator)
      self.addSubview(backgroundView)
  }
  
  func activityStopAnimating() {
      if let background = viewWithTag(1000) {
          background.removeFromSuperview()
      }
   }
}
