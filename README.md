# MLVAdView

[![CocoaPods](https://img.shields.io/badge/pod-1.0.0-377ADE.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](http://img.shields.io/badge/license-MIT-black.svg)](http://opensource.org/licenses/MIT)
[![Twitter](https://img.shields.io/badge/twitter-@melvyndev-blue.svg?style=flat)](http://twitter.com/melvyndev)

There may be sometimes that an infinite page loop would be desired. For example, if you want display a gallery of photos or other informations, you may want it start back when you reach the end, or you want it scroll automatically with a time interval. MLVAdView will help you creat an endless pagenated scroll view. 

## Requirements
| MLVAlertKit Version | Minimum iOS Target  | Descriptions            |
|:-------------------:|:-------------------:|:-----------------------:|
| 1.0.0               | iOS 8               |                         |

## Installation
MLVAdView can be added to a project using CocoaPods、Cathage, One may also use source files included in the project.

###CocoaPods
[CocoaPods](http://cocoapods.org) is the recommended way to add MLVAlertKit to your project.

1. Add a pod entry for MLVAlertKit to your Podfile `pod 'MLVAdView', '~> 1.0.0'` or `pod 'MLVAdView'`
2. Install the pod(s) by running `pod install` or update by running `pod update`
3. Include MLVAlertKit wherever you need it with `#import <MLVAdView/MLVAdView.h>`.

###Carthage
1. Add MLVAdView to your Cartfile. e.g., `github "melvyndev/MLVAdView" ~> 1.0.0`
2. Run `carthage update`
3. Follow the rest of the [standard Carthage installation instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add MLVAdView to your project.

###Source files
Alternatively you can directly add the source files to your project.

1. Download the [latest code version](https://github.com/Melvyndev/MLVAdView/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `MLVAdView.h` `MLVAdView.h` `MLVAdView.m` `MLVAdCell.h` `MLVAdCell.m` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
3. Include MLVAlertKit wherever you need it with `#import "MLVAdView.h"`.

## Usage
```Objective-C
```
Init adView and add it to view where you want display ads, than set dataSource and delegate

```
adView.delegate = self;
adView.dataSource = self;
```
Imp required dataSource method:

```
- numberOfItemsInAdView:
- adView:viewForItemAtIndex:
```
If you want add a header or footer on it, just creat a new view asign it to adViewHeader/adViewFooter
```
UIView *header = UIView.new;
adView.adViewHeader = header;

UIView *footer = UIView.new;
adView.adViewFooter = footer;
```

For more example, downloads [MLVAdView](https://github.com/Melvyndev/MLVAdView/archive/master.zip) an try out the iPhone example app

## License
MLVAdView is released under the MIT license. See LICENSE for details.
