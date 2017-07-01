# The flow.ai Swift SDK
Access the flow.ai platform from your iOS or macOS app. This library lets you build on the flow.ai Socket API.

[![Version](https://img.shields.io/cocoapods/v/FlowCore.svg?style=flat)](http://cocoapods.org/pods/FlowCore)
[![License](https://img.shields.io/cocoapods/l/FlowCore.svg?style=flat)](http://cocoapods.org/pods/FlowCore)
[![Platform](https://img.shields.io/cocoapods/p/FlowCore.svg?style=flat)](http://cocoapods.org/pods/FlowCore)

## Installation
Flow.ai for iOS supports iOS 10 and higher.

### CocoaPods
FlowCore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FlowCore"
```

## Example app
To run the example project, clone the repo, and run `pod install` from the Example directory first.

Next open the `FlowCore.xcworkspace` file.

## Usage

### Requirements
You'll need a [flow.ai](https://app.flow.ai) account. Log into the dashboard and copy and paste the clientId form your *Web API* channel.

### Start the connection
Import the LiveClient inside your AppDelegate file. The SDK opens a live connection so you should respect App events like `applicationWillTerminate(_ application: UIApplication)` to close the connection.

Simply call `start()` to open a connection and `stop()` to close it.

#### Example
```swift
import UIKit
import FlowCore

// Global LiveClient
let liveClient = LiveClient(

    // See the dashboard for your own clientId
    clientId: "your-client-id-from-the-dashboard",

    // Specify a threadId to make this unique for the user
    threadId: "john-doo"
)

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        liveClient.stop()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        liveClient.stop()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        liveClient.start()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        liveClient.stop()
    }
}
```

### Receiving events
The LiveClient supports a delegate you can implement with your view controller.

```swift
public protocol LiveClientDelegate {
    func clientDidConnect(_ client:LiveClient)
    func clientWillReconnect(_ client:LiveClient)
    func clientDidDisconnect(_ client:LiveClient)
    func client(_ client:LiveClient, didReceiveReply reply: Reply)
    func client(_ client:LiveClient, didSendMessage message: Message)
    func client(_ client:LiveClient, didDeliverMessage message: Message)
    func client(_ client:LiveClient, didReceiveError error: Error)
    func client(_ client:LiveClient, didReceiveHistory history: [Reply])
}
```

#### Example

```swift
extension MessagesController : LiveClientDelegate {

    func clientDidConnect(_ client:LiveClient) {
        print("Did connect")
    }

    func clientWillReconnect(_ client:LiveClient) {
        print("Will reconnect")
    }

    func clientDidDisconnect(_ client:LiveClient) {
        print("Did disconnect")
    }

    func client(_ client:LiveClient, didReceiveReply reply: Reply) {
        print("Did receive reply")
    }

    func client(_ client:LiveClient, didSendMessage message: Message) {
        print("Did send message")
    }

    func client(_ client:LiveClient, didDeliverMessage message: Message) {
        print("Did deliver message")
    }

    func client(_ client:LiveClient, didReceiveError error: Error) {
        print("Did receive error", error)
    }

    func client(_ client:LiveClient, didReceiveHistory history: [Reply]) {
    }
}
```

### Sending messages
Use the `send()` method to send messages after you started the connection.

#### Example
```swift
let speech = "I would like to order a pizza"

var originator = Originator()
originator.name = "Gijs"
originator.profile.fullName = "Gijs van de Nieuwegiessen"

let message = Message(speech: speech!, originator: originator)

liveClient.send(message)
```

### Loading history
You can load previous messages using `loadHistory()`. You can optionally provide a custom threadId to load messages of a specific thread or user.


## SDK Reference
Read the complete [SDK reference](https://flow-ai.github.io/flowai-swift)

## Author
[flow.ai](https://flow.ai)

## License

FlowCore is available under the MIT license. See the LICENSE file for more info.
