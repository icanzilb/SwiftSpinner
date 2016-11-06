//
// Copyright (c) 2015-present Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit
import SwiftSpinner

class ViewController: UIViewController {
    
    var progress = 0.0
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.demoSpinner()
    }
    
    func demoSpinner() {

        SwiftSpinner.show(delay: 0.5, title: "Shouldn't see this one", animated: true)
        SwiftSpinner.hide()
        
        SwiftSpinner.show(delay: 1.0, title: "Connecting...", animated: true)
        
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
            SwiftSpinner.sharedInstance.outerColor = UIColor.red.withAlphaComponent(0.5)
            SwiftSpinner.show("Failed to connect, waiting...", animated: false)
        })
        
        delay(seconds: 14.0, completion: {
            SwiftSpinner.sharedInstance.outerColor = nil
            SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
            SwiftSpinner.show("Retrying to authenticate")
        })
        
        delay(seconds: 18.0, completion: {
            SwiftSpinner.show("Connecting...")
        })
        
        delay(seconds: 21.0, completion: {
            SwiftSpinner.setTitleFont(nil)
            SwiftSpinner.sharedInstance.innerColor = UIColor.green.withAlphaComponent(0.5)
            SwiftSpinner.show(duration: 2.0, title: "Connected", animated: false)
        })

        delay(seconds: 24.0) {
            SwiftSpinner.sharedInstance.innerColor = nil
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFire), userInfo: nil, repeats: true)
        }
        
        delay(seconds: 34.0, completion: {
            self.demoSpinner()
        })
    }
    
    func timerFire(_ timer: Timer) {
        progress += (timer.timeInterval/5)
        SwiftSpinner.show(progress: progress, title: "Downloading: \(Int(progress * 100))% completed")
        if progress >= 1 {
            timer.invalidate()
            SwiftSpinner.show(duration: 2.0, title: "Complete!", animated: false)
        }
    }
    
}
