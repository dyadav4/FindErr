//
//  NetworkConnection.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation
import Network


//to handle the intrnet connection
class NetworkConnection {
    
    static let _shared = NetworkConnection()
    
    class func shared() -> NetworkConnection{
        return _shared
    }
    
    var monitor: NWPathMonitor?
    var isMonitoring = false
    
    private init(){
        
    }
    
    deinit {
        stopMonitoring()
    }
    
    //checking if internet is connected
    var isConnected: Bool {
        guard let monitor = monitor else {return false}
        return monitor.currentPath.status == .satisfied
    }
    
    //checking if the connection is light type or expensive one for the user
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    //to start monitoring for the internet
    func startMonitoring(completion: () -> Void) {
        guard !isMonitoring else {return}
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "monitor")
        monitor?.start(queue: queue)
        
        
        isMonitoring = true
        
        completion()
        
        
    }
    
    //to stop monitoring for the internet
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else {return}
        
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        
    }
    
}
