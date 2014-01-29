# MobileDeepLinking [![Build Status](https://travis-ci.org/mobiledeeplinking/mobiledeeplinking-ios.png?branch=master)](https://travis-ci.org/mobiledeeplinking/mobiledeeplinking-ios)

This project is the iOS library component of the MobileDeepLinking specification, an industry standard for mobile application deeplinking. This specification and accompanying libraries simplify and reduce implementation of deep links as well as provide flexible and powerful features for routing to custom behavior.

## Build
1. Install CocoaPods `sudo gem install cocoapods`
2. Run `pod install`
3. Open `MobileDeepLinking.xcworkspace`

## Demo App

Part of the `MobileDeepLinking.xcworkspace` includes `MobileDeepLinkingDemo`. This is a demo application that provides an example implementation of the `MobileDeepLinking.json` file, along with several custom handlers that demonstrate how to route to client-specified functionality. It also provides example routing to a storyboard based view, a xib based view, and a view without any Inteface Builder elements.

