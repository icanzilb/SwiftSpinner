//
// Copyright (c) 2015 Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit
import SwiftSpinner

class ViewController: UIViewController {
    
    func delay(seconds seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.demoSpinner()
    }
    
    func demoSpinner() {

        SwiftSpinner.showWithDelay(2.0, title: "It's taking longer than expected")
        
        delay(seconds: 2.0, completion: {
            SwiftSpinner.show("Connecting \nto satellite...").addTapHandler({
                print("tapped")
                SwiftSpinner.hide()
            }, subtitle: "Tap to hide while connecting! This will affect only the current operation.")
        })
        
        delay(seconds: 6.0, completion: {
            SwiftSpinner.show("Authenticating user account")
        })
        
        delay(seconds: 10.0, completion: {
            SwiftSpinner.show("Failed to connect, waiting...", animated: false)
        })
        
        delay(seconds: 14.0, completion: {
            SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
            SwiftSpinner.show("Retrying to authenticate")
        })
        
        delay(seconds: 18.0, completion: {
            SwiftSpinner.show("Connecting...")
        })
        
        delay(seconds: 21.0, completion: {
            SwiftSpinner.setTitleFont(nil)
            SwiftSpinner.show("Connected", animated: false)
        })
        
        delay(seconds: 22.0, completion: {
            SwiftSpinner.hide()
        })
        
        delay(seconds: 28.0, completion: {
            self.demoSpinner()
        })
    }
    
}