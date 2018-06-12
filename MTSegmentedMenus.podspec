#
# Be sure to run `pod lib lint MTSegmentedMenus.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MTSegmentedMenus'
  s.version          = '0.1.0'
  s.summary          = 'The view controller for segmented menus.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The view controller for segmented menus. Tap menu to cancel selected-state. When the menu is switched, the change block is called two times.
                       DESC

  s.homepage         = 'https://github.com/Secrimart/MTSegmentedMenus'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Secrimart' => 'secrimart@aliyun.com' }
  s.source           = { :git => 'https://github.com/Secrimart/MTSegmentedMenus.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MTSegmentedMenus/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MTSegmentedMenus' => ['MTSegmentedMenus/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry', '~> 1.1'
  
end
