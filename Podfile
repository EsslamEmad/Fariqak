# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Fariqak' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Fariqak
	pod 'SkyFloatingLabelTextField', '~> 3.4.1'
	pod 'PromiseKit', '~> 6.0'
	 pod 'Moya', '~> 11.0'
	 pod 'SwiftyJSON', '~> 4.0'
	 pod 'ResponseDetective', '~> 1.2'
 	pod 'DefaultsKit'
	 pod 'SVProgressHUD', '~> 2.2'
	pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'FirebaseUI/Auth'
pod 'FirebaseUI/Google'
pod 'FirebaseUI/Facebook'
pod 'GoogleSignIn'
pod 'SideMenu'
pod 'Kingfisher', '~> 4.0'
pod 'ImageSlideshow', '~> 1.6'
pod "ImageSlideshow/Kingfisher"
pod 'Cosmos', '~> 16.0'


# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
end
