#
# Be sure to run `pod lib lint SwiftSpinner.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftSpinner"
  s.version          = "1.1.0"
  s.summary          = "A beautiful activity indicator written in Swift"
  s.description      = <<-DESC
  	SwiftSpinner is an extra beautiful activity indicator with plain and bold style fitting iOS 8 design very well. It uses dynamic blur and translucency to overlay the current screen contents and display an activity indicator with text (or the so called “spinner”).

  	I developed it for my Swift app called **Doodle Doodle** (http://doodledoodle.io) and wanted to share it with everyone.
                       DESC
  s.homepage         = "https://github.com/icanzilb/SwiftSpinner"
  s.screenshots      = "https://raw.githubusercontent.com/icanzilb/SwiftSpinner/master/etc/spinner-preview.gif"
  s.license          = 'MIT'
  s.author           = { "Marin Todorov" => "touch-code-magazine@underplot.com" }
  s.source           = { :git => "https://github.com/icanzilb/SwiftSpinner.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/icanzilb'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true

  s.source_files = 'SwiftSpinner'
  s.frameworks = 'UIKit'
  
end
