# SwiftSpinner

[![Version](https://img.shields.io/cocoapods/v/SwiftSpinner.svg?style=flat)](http://cocoadocs.org/docsets/SwiftSpinner)
[![License](https://img.shields.io/cocoapods/l/SwiftSpinner.svg?style=flat)](http://cocoadocs.org/docsets/SwiftSpinner)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSpinner.svg?style=flat)](http://cocoadocs.org/docsets/SwiftSpinner)

SwiftSpinner is an extra beautiful activity indicator with plain and bold style fitting iOS 8 design very well. It uses dynamic blur and translucency to overlay the current screen contents and display an activity indicator with text (or the so called “spinner”).

- - -

**Note:** SwiftSpinner is now **Swift 1.2** compatible.
- - -

I developed it for my Swift app called **Doodle Doodle** and wanted to share it with everyone. Check the app here: http://doodledoodle.io

This is how the activity looks like (from the demo app):

![SwiftSpinner Screenshot](https://raw.githubusercontent.com/icanzilb/SwiftSpinner/master/etc/spinner-preview.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the DemoApp directory first. That’ll run the demo program which shows you how the spinner looks like and what it can do. 

#### Code samples

The simple code to get `SwiftSpinner` running in your own app.

 * In case you installed SwiftSpinner via CocoaPods you need to import it (add this somewhere at the top of your source code file):

```swift
    import SwiftSpinner
```

 * When you want to show an animated activity (eg. rings are randomly rotating around):

```swift
     SwiftSpinner.show("Connecting to satellite...")
```

 * If you want to show a static activity indicator (eg. a message with two complete rings around it)

```swift
    SwiftSpinner.show("Failed to connect, waiting...", animated: false)
```

 * When you want to hide the activity:

```swift
    SwiftSpinner.hide()
```

In case you want to do something after the hiding animation completes you can provide a closure to the `hide()` method:

```swift
    SwiftSpinner.hide({
      //do stuff
    })
```


That's all. If you want to change the text of the current activity, just call `show(...)` again, this will animate the old text into the new text.

## Beyond the basics 

If you are using `SwiftSpinner` to show an alert message you can also easily add a dismiss handler:

```swift
    SwiftSpinner.show("Connecting \nto satellite...").addTapHandler({
      SwiftSpinner.hide()
    })
```

Or even add a subtitle to let the user know they can tap to do stuff:

```swift
    SwiftSpinner.show("Connecting \nto satellite...").addTapHandler({
      SwiftSpinner.hide()
    }, subtitle: "Tap to hide while connecting! This will affect only the current operation.")
```

In case you want to adjust the font of the spinner title:

```swift
    SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
```

To reset back to the default font:

```swift
    SwiftSpinner.setTitleFont(nil)
```

In case you want to change an arbitrary aspect of the text on screen access directly:

```swift
    SwiftSpinner.sharedInstance.titleLabel
    SwiftSpinner.sharedInstance.subtitleLabel
```

Finally you can show a spinner only if certain amount of time has passed (e.g. if you are downloading a file - show a message only if the operation takes longer than certain amount of time):

```swift
    SwiftSpinner.showWithDelay(2.0, title: "It's taking longer than expected")
```

If you call `show(…)` or `hide()` before the `delay` time has passed - this will clear the call to `showWithDelay(…)`.

## Requirements

There aren’t any requirements per se. As long as you got `UIKit` imported the spinner takes care of everything else.

## Installation

`SwiftSpinner` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
    pod "SwiftSpinner"
```

In case you don’t want to use CocoaPods - just copy the file **SwiftSpinner/SwiftSpinner.swift** to your Xcode project.

## Author

**Marin Todorov**, [http://www.touch-code-magazine.com/about](http://www.touch-code-magazine.com/about)

## License

`SwiftSpinner` is available under the MIT license. See the LICENSE file for more info.

