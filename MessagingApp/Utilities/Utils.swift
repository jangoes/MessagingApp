//
//  Utils.swift
//  MessagingApp
//
//  Created by FDC-MM11-Leah on 2/19/21.
//

import UIKit

struct Screen {

    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }

    static var statusBarHeight: CGFloat {
        let viewController = UIApplication.shared.windows.first?.rootViewController
        return viewController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIButton {
    func updateAttributedText(_ text: String) {
        if let attributedText = attributedTitle(for: .normal) {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.mutableString.setString(text)
            setAttributedTitle(mutableAttributedText, for: .normal)
        }
    }
}

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

extension UIView {
    func addPointer(direction: ArrowDirection) {
        let cornerRadius: CGFloat = 5
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: true)
        path.addArc(withCenter: CGPoint(x: frame.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 3 * .pi / 2, endAngle: 2 * .pi, clockwise: true)
        
        if direction == .right {
            // Draw arrow
            path.addLine(to: CGPoint(x: frame.width, y: frame.height-27))
            path.addLine(to: CGPoint(x: frame.width + 10, y: frame.height-21))
            path.addLine(to: CGPoint(x: frame.width, y: frame.height-15))
        }
        
        path.addArc(withCenter: CGPoint(x: frame.width - cornerRadius, y: frame.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: frame.height - cornerRadius), radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        
        if direction == .left {
            // Draw arrow
            path.addLine(to: CGPoint(x: 0, y: frame.height-15))
            path.addLine(to: CGPoint(x: -10, y: frame.height-21))
            path.addLine(to: CGPoint(x: 0, y: frame.height-27))
        }
        
        path.close()
        
        let shape = CAShapeLayer()
        shape.fillColor = #colorLiteral(red: 0.536103487, green: 0.8913286328, blue: 0.02797951177, alpha: 1).cgColor
        shape.path = path.cgPath
        self.layer.insertSublayer(shape, at: 0)
    }
}
