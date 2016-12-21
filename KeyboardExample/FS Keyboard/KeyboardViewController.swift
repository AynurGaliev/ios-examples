//
//  KeyboardViewController.swift
//  Extension Example
//
//  Created by Aynur Galiev on 8.декабря.2016.
//  Copyright © 2016 Aynur Galiev. All rights reserved.
//

import UIKit

final class KeyboardViewController: UIInputViewController {
    
    private var isCapsLockOn: Bool = true
    
    @IBOutlet weak var row1: UIView!
    @IBOutlet weak var row2: UIView!
    @IBOutlet weak var row3: UIView!
    @IBOutlet weak var row4: UIView!
    
    @IBOutlet weak var charSet1: UIView!
    @IBOutlet weak var charSet2: UIView!
    
    @IBOutlet weak var keyboardHeightConstraint:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        view = objects[0] as! UIView
        self.keyboardHeightConstraint.constant = ceil(UIScreen.main.bounds.size.height*0.38)
        self.charSet2.isHidden = true
    }
    
    @IBAction func nextKeyboardPressed(_ button: UIButton) {
        self.advanceToNextInputMode()
    }
    
    @IBAction func capsLockPressed(_ button: UIButton) {
        self.isCapsLockOn = !self.isCapsLockOn
        self.changeCaps(self.row1)
        self.changeCaps(self.row2)
        self.changeCaps(self.row3)
        self.changeCaps(self.row4)
    }
    
    @IBAction func keyPressed(_ button: UIButton) {
        guard let string = button.titleLabel?.text else { return }
        self.textDocumentProxy.insertText("\(string)")
        
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform.identity.scaledBy(x: 2.0, y: 2.0)
        }, completion: {(success) -> Void in
            button.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        })
    }
    
    @IBAction func backSpacePressed(_ button: UIButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func spacePressed(_ button: UIButton) {
        self.textDocumentProxy.insertText(" ")
    }
    
    @IBAction func returnPressed(_ button: UIButton) {
        self.textDocumentProxy.insertText("\n")
    }
    
    @IBAction func charSetPressed(_ button: UIButton) {
        guard let string = button.titleLabel?.text else { return }
        if string == "1/2" {
            UIView.transition(from: self.charSet2,
                              to: self.charSet1,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              completion: { (success) in
                    self.charSet1.isHidden = true
                    self.charSet2.isHidden = false
                    button.setTitle("2/2", for: .normal)
            })
        } else if string == "2/2" {
            UIView.transition(from: self.charSet1,
                              to: self.charSet2,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              completion: { (success) in
                self.charSet1.isHidden = false
                self.charSet2.isHidden = true
                button.setTitle("1/2", for: .normal)
            })
        }
    }
    
    private func changeCaps(_ containerView: UIView) {
        for view in containerView.subviews {
            guard let button = view as? UIButton else { continue }
            guard let buttonTitle = button.titleLabel?.text else { continue }
            if self.isCapsLockOn {
                let text = buttonTitle.uppercased()
                button.setTitle("\(text)", for: .normal)
            } else {
                let text = buttonTitle.lowercased()
                button.setTitle("\(text)", for: .normal)
            }
        }
    }
    
}
