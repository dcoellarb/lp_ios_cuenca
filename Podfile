source 'https://github.com/CocoaPods/Specs.git'
xcodeproj ‘Lockphone.xcodeproj'

def import_pods
    pod 'SnapKit', '~> 0.15.0'
    pod 'Parse'
    pod 'GoogleAnalytics'
    pod 'RxSwift', '~> 2.0.0-beta'
    pod 'PayPal-iOS-SDK'
    pod 'Stripe'
    pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
    pod 'Alamofire', '~> 3.0'
    pod 'M13PDFKit', '1.0.2'
end

target :Lockphone do
    xcodeproj 'Lockphone.xcodeproj'
    platform :ios, '8.0'
    use_frameworks!
    import_pods
end

target :LockphoneQA do
    xcodeproj 'Lockphone.xcodeproj'
    platform :ios, '8.0'
    use_frameworks!
    import_pods
end