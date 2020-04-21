//
//  sourceCode.swift
//  hexy
//
//  Created by joelcross on 2020-04-15.
//  Copyright © 2020 joelcross. All rights reserved.
//
//  This app prompts the user to enter a hex code. 
//  Upon pressing "Go", the app will validate the hex 
//  code and change the on-screen colour swatch to the 
//  corresponding colour.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // initialize UI elements
    @IBOutlet weak var hexyLabel: UILabel!
    @IBOutlet weak var bottomInput: UIStackView!
    @IBOutlet weak var swatchLabel: UILabel!
    @IBOutlet weak var rect: UIImageView!
    @IBOutlet weak var colour: UIImageView!
    @IBOutlet weak var hexTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    // runs when view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make elements invisible
        hexTextField.delegate = self
        self.hexyLabel.alpha = 0.0
        self.bottomInput.alpha = 0.0
        self.colour.alpha = 0.0
        self.swatchLabel.alpha = 0.0
        self.rect.alpha = 0.0
        
        // fade in title, then other elements
        fadeInTitle(self)
        fadeInBottomGraphics(self)
    }
    
    // function creates a fade-in effect for the title
    func fadeInTitle (_ sender: Any) {
        UIView.animate(withDuration: 2.5, delay: 0.0, animations: {
            self.hexyLabel.alpha = 1.0
        })
    }
    
    // function creates a fade-in effect for the bottom graphics
    func fadeInBottomGraphics (_ sender: Any) {
        UIView.animate(withDuration: 2.0, delay: 1.5, animations: {
            self.bottomInput.alpha = 1.0
            self.colour.alpha = 1.0
            self.swatchLabel.alpha = 1.0
            self.rect.alpha = 1.0
        })
    }
    
    // forces keyboard down when "done" is pressed
    func textFieldShouldReturn(_ hexTextField: UITextField) -> Bool {
        hexTextField.resignFirstResponder()
        return true
    }
    
    // returns a UI color from a hex string
    func hexStringToUIColor (userInput:String) -> UIColor {
        // initialize user input and trim any whitespace
        let hexString:String = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // use regex to check for valid characters
        // if invalid character is found, alert user and keep swatch colour as is
        if hexString.range(of: "^[a-fA-F0-9]{6}$", options: .regularExpression) == nil {
            showAlertButtonTapped(self)
            return colour.tintColor
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func goButtonPress(_ sender: Any) {
        // initialize user input text and the new swatch colour
        let hexText = hexTextField.text ?? "placeholder"
        let newColour = hexStringToUIColor (userInput: hexText)
        
        // if entered colour is new
        if newColour != colour.tintColor {
            // change colour of swatch
            colour.tintColor = newColour
            // change swatch label text
            swatchLabel.text = "#" + hexText
        }
    }
    
    // creates an alert for invalid input
    @IBAction func showAlertButtonTapped(_ sender: Any) {
        // create alert
        let alert = UIAlertController(title: "Error", message: "Please enter a valid hex code.", preferredStyle: UIAlertController.Style.alert)

        // add action ("Ok" response)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

