# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'shinkansenquiz' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

pod 'Parse'
pod 'ParseUI'
pod "youtube-ios-player-helper", "~> 0.1.1"
pod 'Harpy'
pod 'SVProgressHUD'
pod 'Google-Mobile-Ads-SDK', '~> 7.0'

plugin 'cocoapods-keys', {
  :project => "ShinkansenQuiz",
  :keys => [
    "parseApplicationId",
    "parseClientKey"
    ]
}

  target 'shinkansenquizTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
