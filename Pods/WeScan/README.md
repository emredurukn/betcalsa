# WeScan

<p align="center">
    <img width="900px" src="Assets/WeScan-Banner.jpg">
</p>

<p align="center">
<img src="https://travis-ci.com/WeTransfer/WeScan.svg?token=Ur5V2zzKmBJLmMYHKJTF&branch=master"/>
<img src="https://img.shields.io/cocoapods/v/WeScan.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/l/WeScan.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/p/WeScan.svg?style=flat"/>
<img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/>
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat"/>
</p>
 
**WeScan** makes it easy to add scanning functionalities to your iOS app! 
It's modelled after `UIImagePickerController`, which makes it a breeze to use.

- [Features](#features)
- [Example](#example)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Communication](#communication)
- [License](#license)

## Features

- [x] Fast
- [x] Live scanning of documents
- [x] Edit detected rectangle
- [x] Auto scan and flash support
- [x] Lightweight dependency
- [x] Translated to English, Chinese, Italian, Portuguese, and French
- [ ] Batch scanning

## Demo

<p align="left">
    <img src="Assets/WeScan.gif">
</p>

## Requirements

- Swift 4.2
- iOS 10.0+
- Xcode 9.x

<br>

## Installation
### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

To integrate **WeScan** into your Xcode project using CocoaPods, specify it in your `Podfile`:

```rubygi
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'WeScan', '>= 0.9'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate **WeScan** into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "WeTransfer/WeScan" >= 0.9
```

Run `carthage update` to build the framework and drag the built `WeScan.framework` into your Xcode project.

### Manually

Just download the project, and drag and drop the "WeScan" folder in your project.



<p align="center">
    <img width="900px" src="Assets/project.png">
</p>


Simply add the WeScan framework in the project's Embedded Binaries and Linked Frameworks and Libraries.

<p align="center">
    <img width="900px" src="Assets/LinkedFrameworks.png">
</p>

## Usage

1. Make sure that your ViewController confirms to the `ImageScannerControllerDelegate` protocol

```swift
class YourViewController: UIViewController, ImageScannerControllerDelegate {
    // YourViewController code here
}
```

2. Implement the delegate functions inside your view controller:
```swift
func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    // You are responsible for carefully handling the error
    print(error)
}

func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
    // The user successfully scanned an image, which is available in the ImageScannerResults
    // You are responsible for dismissing the ImageScannerController
    scanner.dismiss(animated: true)
}

func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    // The user tapped 'Cancel' on the scanner
    // You are responsible for dismissing the ImageScannerController
    scanner.dismiss(animated: true)
}
```

3. Finally, create and present a `ImageScannerController` instance somewhere within your view controller:

```swift
let scannerViewController = ImageScannerController()
scannerViewController.imageScannerDelegate = self
present(scannerViewController, animated: true)
```

### Objective-C

1. Create a dummy swift class in your project. When Xcode asks if you'd like to create a bridging header, press 'Create Bridging Header'
2. In the new header, add the Objective-C class (`#import myClass.h`) where you want to use WeScan
3. In your class, import the header (`import <yourProjectName.swift.h>`)
4. Drag and drop the WeScan folder to add it to your project
5. In your class, add `@Class ImageScannerController;`

#### Example Implementation
```objc
ImageScannerController *scannerViewController = [ImageScannerController new];
[self presentViewController:scannerViewController animated:YES completion:nil];
```

<br>

## Communication

- If you **found a bug**, open an [issue](https://github.com/WeTransfer/WeScan/issues).
- If you **have a feature request**, open an [issue](https://github.com/WeTransfer/WeScan/issues).
- If you **want to contribute**, submit a [pull request](https://github.com/WeTransfer/WeScan/pulls).

<br>

## License

**WeScan** is available under the MIT license. See the [LICENSE](https://github.com/WeTransfer/WeScan/blob/develop/LICENSE) file for more info.
