# MobileDeepLinking [![Build Status](https://travis-ci.org/mobiledeeplinking/mobiledeeplinking-ios.png?branch=master)](https://travis-ci.org/mobiledeeplinking/mobiledeeplinking-ios)

This project is the iOS library component of the MobileDeepLinking specification, an industry standard for mobile application deeplinking. This specification and accompanying libraries simplify and reduce implementation of deep links as well as provide flexible and powerful features for routing to custom behavior.

## Build
1. Install CocoaPods `sudo gem install cocoapods`
2. Run `pod install`
3. Open `MobileDeepLinking.xcworkspace`

## Demo App

Part of the `MobileDeepLinking.xcworkspace` includes `MobileDeepLinkingDemo`. This is a demo application that provides an example implementation of the `MobileDeepLinking.json` file, along with several custom handlers that demonstrate how to route to client-specified functionality. It also provides example routing to a storyboard based view, a xib based view, and a view without any Interface Builder elements.

## License

Copyright 2014 MobileDeepLinking.org and other contributors
http://mobiledeeplinking.org

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
