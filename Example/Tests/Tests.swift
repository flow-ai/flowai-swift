// https://github.com/Quick/Quick

import Quick
import Nimble
import FlowCore

class SpyDelegate : LiveClientDelegate {
    
    func clientDidConnect(_ client:LiveClient) {}
    
    func clientWillReconnect(_ client:LiveClient) {}
    
    func clientDidDisconnect(_ client:LiveClient) {}
    
    func client(_ client:LiveClient, didReceiveReply reply: Reply) {}
    
    func client(_ client:LiveClient, didSendMessage message: Message) {}
    
    func client(_ client:LiveClient, didDeliverMessage message: Message) {}
    
    func client(_ client:LiveClient, didReceiveError error: Error) {}
    
    func client(_ client:LiveClient, didReceiveHistory history: [Reply]) {}
}

class LiveClientSpec: QuickSpec {
    override func spec() {
        describe("these will fail") {
            
            context("these will pass") {
                
                it("can create LiveClient") {
                    _ = LiveClient(clientId: "11234")
                }
                
                it("can create LiveClient") {
                    let client = LiveClient(clientId: "NzRkNDFmMGEtYTM5OC00Njk0LWI4MTktZTA4NmJjZjEyMTg3fDIyMWJkMjY3LTdjYTItNGIwZi05NDQwLThiNzg2ZDRmYjZkNg==", endpoint: "http://localhost:6005")
                    client.delegate = SpyDelegate()
                    client.start()
                }
                
            }
            
            it("can create originator") {
                _ = Originator()
            }
            
            it("can can make a REST call") {
                let rest = Rest("http://localhost:6005")
                rest.get(path: "socket.info", token: "1234", queryParams: nil){ err, json in
                    expect(err).to(beNil())
                }
            }
        }
    }
}
