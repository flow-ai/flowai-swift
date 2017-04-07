#
# Be sure to run `pod lib lint FlowCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlowCore'
  s.version          = '0.1.0'
  s.summary          = 'The official Swift Flow.ai SDK '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Access the flow.ai platform from your iOS or macOS app.

Flow.ai is the AI powered interaction platform. FlowCore provides a client to connect in real time.

Features:

- Connect in real-time using just a clientId
- Send messages and receive messages from bots and human operators
- Full support for response templates like cards, buttons, locations etc
- Auto reconnect and keep alive
                       DESC

  s.homepage         = 'https://flow.ai'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gijs van de Nieuwegiessen' => 'gijs@flow.ai' }
  s.source           = { :git => 'https://github.com/flow-ai/flowai-swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/theflowai'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FlowCore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FlowCore' => ['FlowCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SwiftWebSocket', '~> 2.6.5'
  s.dependency 'HandyJSON', '~> 1.6.1'
end
