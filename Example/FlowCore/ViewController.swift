//
//  ViewController.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 04/03/2017.
//  Copyright (c) 2017 Flow.ai. All rights reserved.
//

import UIKit
import FlowCore
import Speech

class ViewController: UIViewController, LiveClientDelegate, SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate {
    
    
    let client = LiveClient(
        clientId: "enter client id here",
        threadId: "unique-for-this-user",
        endpoint: "https://api.flow.ai"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.delegate = self
        client.start()
    }

    
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
        print("Did receive a message")
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

