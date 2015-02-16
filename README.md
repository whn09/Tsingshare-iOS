# Tsingshare-iOS

### Install Alamofire

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 beta adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ sudo gem install cocoapods --pre
```

```bash
pod --version
```

发现还是0.35版本，执行

```bash
gem list
```

你会看到自动安装了多个版本的cocoapods, 只需要 

```bash
gem cleanup
```

世界顿时清净了。

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'Alamofire', '~> 1.1'
```

Then, run the following command:

```bash
$ pod install
```
