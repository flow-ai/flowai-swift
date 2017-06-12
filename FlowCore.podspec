Pod::Spec.new do |s|
  s.name             = 'FlowCore'
  s.version          = '0.1.4'
  s.summary          = 'The official Swift Flow.ai SDK '
  s.description      = <<-DESC
Access the flow.ai platform from your iOS or macOS app.

Flow.ai is the AI powered interaction platform. FlowCore provides a websocket client that connects in real time.

Features:

- Create compelling conversational experiences using the Flow.ai designer
- Connect in real-time using just a clientId
- Send messages and receive messages from bots and human operators
- Full support for response templates like cards, buttons or locations
- Auto reconnect and keep alive
                       DESC
  s.homepage         = 'https://flow-ai.github.io/flowai-swift/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gijs van de Nieuwegiessen' => 'gijs@flow.ai' }
  s.source           = { :git => 'https://github.com/flow-ai/flowai-swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/theflowai'
  s.ios.deployment_target = '10.0'
  s.source_files = 'FlowCore/Classes/**/*'
  s.dependency 'SwiftWebSocket', '~> 2.6.5'
  s.dependency 'HandyJSON', '~> 1.6.1'
end
