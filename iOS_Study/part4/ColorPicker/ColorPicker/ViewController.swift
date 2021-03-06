//
//  ViewController.swift
//  ColorPicker
//
//  Created by 김세준 on 2018. 8. 7..
//  Copyright © 2018년 김세준. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- Pirvate Types
    private struct ColorComponent {
        
        typealias  SliderTag = Int
        typealias  Component = Int
    
        static let count: Int = 4
        
        static let red: Int = 0
        static let green: Int = 1
        static let blue: Int = 2
        static let alpha: Int = 3
        
        static func tag(`for`: Component) -> Int {
            return `for` + 100
        }
        
        static func component(from: SliderTag) -> Component {
            return from - 100
        }
    
    }
    
    // MARK: Privates
    private let rgbStep: Float = 255.0
    private let numberOfRGBStep: Int = 256
    private let numberOfAlphaStep: Int = 11
    
    private struct ViewTag {
        static let sliderRed: Int = 100
        static let sliderGreen: Int = 101
        static let sliderBlue: Int = 102
        static let sliderAlpha: Int = 103
    }
    
    // MARK: - Properties
    // MARK: IBOutlets
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard (ViewTag.sliderRed...ViewTag.sliderAlpha).contains(sender.tag) else {
            print("잘못된 slider이다.")
            return
        }
        
        // red: 0, green: 1, blue: 2, alpha: 3
        let component: Int = ColorComponent.component(from: sender.tag)
        let row: Int
        
        if component == ColorComponent.alpha {
            row = Int(sender.value * 10)
        } else {
            row = Int(sender.value)
        }
        
        self.pickerView.selectRow(row, inComponent: component, animated: true)
        
        self.matchViewColorWithCurrentValue()
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<self.pickerView.numberOfComponents {
            let numberOfRows: Int = self.pickerView.numberOfRows(inComponent: i)
            self.pickerView.selectRow(numberOfRows-1, inComponent: i, animated: true)
        }
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Privates
    private func matchViewColorWithCurrentValue() {
        
        guard let redSlider: UISlider = self.view.viewWithTag(ViewTag.sliderRed) as? UISlider,
            let greenSlider: UISlider = self.view.viewWithTag(ViewTag.sliderGreen) as? UISlider,
            let blueSlider: UISlider = self.view.viewWithTag(ViewTag.sliderBlue) as? UISlider,
            let alphaSlider: UISlider = self.view.viewWithTag(ViewTag.sliderAlpha) as? UISlider else {
                return
        }
        
        // UIColor의 Red, Green, Blue, Alpha 값은 0과 1사이의 실수 값
        let red: CGFloat = CGFloat(redSlider.value / self.rgbStep)
        let green: CGFloat = CGFloat(greenSlider.value / self.rgbStep)
        let blue: CGFloat = CGFloat(blueSlider.value / self.rgbStep)
        let alpha: CGFloat = CGFloat(alphaSlider.value)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        self.colorView.backgroundColor = color
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    

    // MRRK:- UIPickerViewDataSource
    // returns the number of 'columns' to display.
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return ColorComponent.count
    }
    
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ViewTag.sliderAlpha == ColorComponent.tag(for: component) {
            return self.numberOfAlphaStep
        } else {
            return self.numberOfRGBStep
        }
    }
    
    
    // MRRK:- UIPickerViewDelegate
    // DataSource로 전달한 row의 값 (numberOfAlphaStep OR numberOfRGBStep)을 받아서 숫자로 표기해준다.
    // 만약 이 Method가 구현이 안되어있다면 row값은 ?로 표기된다.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ViewTag.sliderAlpha == ColorComponent.tag(for: component) {
            return String(format: "%1.1lf", Double(row) * 0.1)
        } else {
            return "\(row)"
        }
    }
    
    // titleForRow의 값을 받아서 colorView에 적용한다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let sliderTag: Int = ColorComponent.tag(for: component)
        
        guard let slider: UISlider = self.view.viewWithTag(sliderTag) as? UISlider else {
            return
        }
        
        if component == ColorComponent.alpha {
           slider.setValue(Float(row) / 10.0, animated: true)
        } else {
            slider.setValue(Float(row), animated: true)
        }
        self.matchViewColorWithCurrentValue()
    }
}












