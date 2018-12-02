//
//  Extensions.swift
//  ClasseraSP
//
//  Created by Ammar AlTahhan on 16/05/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import UIKit
//import MBProgressHUD


extension Dictionary {
    mutating func append(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension UIViewController {
//    func showProgressHUD() {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//    }
//
//    func hideProgressHUD() {
//        MBProgressHUD.hide(for: self.view, animated: true)
//    }
    
    func showMessage(title: String, message: String, completion: (()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action) -> Void in
            completion?()
        }
        
        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPromptMessage(title: String, message: String, approveMessage: String = "OK", approveInteractionStyle: UIAlertAction.Style = UIAlertAction.Style.default, completionHandler: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: approveInteractionStyle) { (action) -> Void in
            completionHandler(true)
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            completionHandler(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func animateViewBackIn(withDuration: CGFloat = 0.6, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.9, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = .curveLinear) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    func animateStatusBarHidden(_ hide: Bool) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: {
            UIApplication.shared.isStatusBarHidden = hide
        }, completion: nil)
    }
}

extension UINavigationController {
    func pushViewController(_ withIdentifier: String, _ fromStoryboardName: String = "New") -> UIViewController {
        let viewController = UIStoryboard(name: fromStoryboardName, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
        self.pushViewController(viewController, animated: true)
        return viewController
    }
}

extension UITableView {
    func reloadAllSections(with animation: UITableView.RowAnimation = .automatic) {
        self.reloadSections(IndexSet(integersIn: Range(0..<self.numberOfSections)), with: animation)
    }
}

extension UICollectionView {
    func startAutoScroll(delaySeconds: TimeInterval) {
        var autoScrollCounter = 1
        Timer.scheduledTimer(withTimeInterval: delaySeconds, repeats: true) { (timer) in
            let indexPath = IndexPath(item: Int(autoScrollCounter) % self.numberOfItems(inSection: 0), section: 0)
            self.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            autoScrollCounter += 1
        }
    }
}

extension UITableViewCell {
    func animateSelection(color: UIColor = UIColor.gray.withAlphaComponent(0.3)) {
        let currentColor = self.backgroundColor
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.backgroundColor = color
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.25, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.backgroundColor = currentColor
            }, completion: nil)
        }
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    var rootSuperView: UIView {
        var view = self
        while let s = view.superview {
            view = s
        }
        return view
    }
    
    var currentHeightVisibilityPercentage: CGFloat {
        let visibleRect = self.bounds.intersection((superview?.bounds)!)
        let visibleHeight = visibleRect.height
        return visibleHeight/self.frame.height
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    func hasConstraint(withAttribute attribute: NSLayoutConstraint.Attribute) -> Bool {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute {
                return true
            }
        }
        return false
    }
    
    func getConstraint(withAttribute attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}

extension UIView {
    
    /** This is the function to get subViews of a view of a particular type
     */
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    var bold: UIFont {
        return withTraits(traits: .traitBold)
    }
}

extension TimeInterval {
    var minutes: Double {
        return self / 60
    }
    var hours: Double {
        return self / 3600
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setClearButtonTintColor(_ color: UIColor) {
        let clearButton = self.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = color
    }
    
    func animateFalseEntry() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 2, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 2, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        self.layer.borderColor = UIColor(rgb: 0xFF2600).cgColor
        self.layer.borderWidth = 1
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.layer.borderWidth = 0
            timer.invalidate()
        }
    }
}

public extension UIWindow {
    
    /** @return Returns the current Top Most ViewController in hierarchy.   */
    public func topMostWindowController()->UIViewController? {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    /** @return Returns the topViewController in stack of topMostWindowController.    */
    public func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
}

extension UIImageView {
    
//    func loadImageWithUrl (url: String) {
//        self.kf.indicatorType = .activity
//        self.kf.setImage(with: URL(string: url),
//                         options: [.transition(.fade(0.5))],
//                         progressBlock: nil)
//    }
//
//    func loadImageWithUrl (url: String, placeholder: UIImage) {
//        self.kf.indicatorType = .none
//        self.kf.setImage(with: URL(string: url), placeholder: placeholder, options: [.transition(.fade(0.5))], progressBlock: nil)  { (image, err, _, _) in
//            guard err == nil else {
//                self.image = placeholder
//                return
//            }
//        }
//    }
//
//    func loadImageWithUrl (url: String, placeholder: UIImage, onFailureColor backgroundColor: UIColor) {
//        self.kf.indicatorType = .none
//        self.kf.setImage(with: URL(string: url), placeholder: placeholder, options: [.transition(.fade(0.5))], progressBlock: nil)  { (image, err, _, _) in
//            guard err == nil else {
//                self.image = placeholder
//                self.backgroundColor = backgroundColor
//                return
//            }
//        }
//    }
//
//    func loadImageWithUrl (url: String, _ completionHandler: @escaping (_ image: UIImage)->Void) {
//        self.kf.indicatorType = .activity
//        self.kf.setImage(with: URL(string: url), options: [.transition(.fade(0.5))], progressBlock: nil) { (image, _, _, _) in
//            guard let image = image else { return }
//            completionHandler(image)
//        }
//    }
    
    func addEnlargability() {
        let imageView = self
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        
        let transition = CATransition()
        //        transition.type = kCATransitionReveal
        transition.type = CATransitionType.push
        //        transition.subtype = kCATransitionFade
//        transition.subtype = kCATransitionReveal
        transition.duration = 0.2
        rootSuperView.layer.add(transition, forKey: "transition")
        
        rootSuperView.addSubview(newImageView)
        parentViewController?.navigationController?.isNavigationBarHidden = true
        parentViewController?.tabBarController?.tabBar.isHidden = true
        
        UIApplication.shared.isStatusBarHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        parentViewController?.navigationController?.isNavigationBarHidden = false
        parentViewController?.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            sender.view?.alpha = 0
        }) { (_) in
            sender.view?.removeFromSuperview()
            UIApplication.shared.isStatusBarHidden = false
        }
    }
    
    func fill(withColor color: UIColor) {
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func resized(to newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}


extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    var coordinatesTupled: (String, String) {
        if self == "nil" {
            return ("nil","nil")
        }
        let subs = self.components(separatedBy: ", ")
        return (String(subs[0]), String(subs[1]))
    }
    
    var lastUrlSubDirectory: String? {
        guard let lastSlashIndex = self.range(of: "/", options: .backwards)?.lowerBound else { return nil }
        return String(self[lastSlashIndex...])
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}

extension CGRect {
    func shrinkedCGRect(by pixels: CGFloat) -> CGRect {
        return CGRect(x: minX, y: minY, width: width-pixels, height: height-pixels)
    }
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if let url = URL(string: url) {
                if application.canOpenURL(url) {
                    application.open(url, options: [:], completionHandler: nil)
                    return
                }
            }
        }
    }
}

extension UIScrollView {
    func isShowing(view: UIView) -> Bool {
        return view.frame.intersects(bounds)
    }
}

public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
