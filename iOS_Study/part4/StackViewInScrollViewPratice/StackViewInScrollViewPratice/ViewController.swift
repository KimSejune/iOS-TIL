//
//  ViewController.swift
//  StackViewInScrollViewPratice
//
//  Created by 김세준 on 2018. 8. 6..
//  Copyright © 2018년 김세준. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let inset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
        
    }

    @IBAction func addEntry(_ sender: AnyObject) {
        let stack = stackView
        let index = (stack?.arrangedSubviews.count)! - 1
        let addView = stack?.arrangedSubviews[index]
        
        let scroll = scrollView
        let offset = CGPoint(x: (scroll?.contentOffset.x)!,
                             y: (scroll?.contentOffset.y)! + (addView?.frame.size.height)!)
        
        let newView = createEntry()
        newView.isHidden = true
        
        stackView.insertArrangedSubview(newView, at: index)
        
        UIView.animate(withDuration: 0.25) {
            newView.isHidden = false
            scroll?.contentOffset = offset
        }
        
    }

    private func createEntry() -> UIView {
        
        let date = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
        let number = "\(arc4random())"
        
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.spacing = 8
        
        let dateLabel = UILabel()
        dateLabel.text = date
        
        let numberLabel = UILabel()
        numberLabel.text = number
        
        let deleteButton = UIButton(type: UIButtonType.roundedRect)
        deleteButton.setTitle("Delete", for: UIControlState.normal)
        deleteButton.addTarget(self, action: #selector(self.deleteStackView(_:)), for: UIControlEvents.touchUpInside)

        
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(deleteButton)
        
        return stack
        
    }
    
    @objc func deleteStackView(_ sender: UIButton) {
        if let view = sender.superview {
            UIView.animate(withDuration: 0.25,animations: {
                view.isHidden = true
            }) { (success) in
                view.removeFromSuperview()
            }
        }
    }

}

