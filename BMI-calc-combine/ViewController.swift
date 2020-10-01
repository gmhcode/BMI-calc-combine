//
//  ViewController.swift
//  BMI-calc-combine
//
//  Created by Greg Hughes on 9/28/20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    
    let notificationCenter = NotificationCenter.default
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var height: Double?
    @Published private var weight: Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTextFields()
        // Do any additional setup after loading the view.
        
        ///old way
//        heightTextField.addTarget(self, action: #selector(textFieldValueChanges(_:)), for: .editingChanged)
    }
    ///old way
//    @objc private func textFieldValueChanges(_ sender: UITextField) {
//        print(sender.text)
//    }
    
    
    func observeTextFields() {
        notificationCenter.publisher(for: UITextField.textDidChangeNotification, object: heightTextField).sink {
            guard let textField = $0.object as? UITextField,
                  let text = textField.text, !text.isEmpty,
                  let height = Double(text) else {
                self.height = nil
                return}
            
            
            self.height = height
            print(height)
        }.store(in: &subscribers)
        
        notificationCenter.publisher(for: UITextField.textDidChangeNotification, object: widthTextField).sink {
            guard let textField = $0.object as? UITextField,
                  let text = textField.text, !text.isEmpty,
                  let weight = Double(text) else {
                self.height = nil
                return}
            
            self.weight = weight
        }.store(in: &subscribers)
        
        Publishers.CombineLatest($height, $weight).sink { [weak self] (height, weight) in
            guard let this = self else {return}
            guard let height = height, let weight = weight else {this.resultLabel.text = ""; return}
            this.resultLabel.text = "h: \(height), w: \(weight)"
            
            print(height,weight)
        }.store(in: &subscribers )
    }
    
}

