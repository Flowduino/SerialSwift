//
//  Serialable.swift
//  
//
//  Created by Simon Stuart on 18/08/2022.
//

import Foundation
import Observable

public protocol Serialable: Observable {
    /**
     Obtains a Singleton Serial Port Interface with the given Port and Baud Rate. Will create the Port if necessary.
     - Author: Simon J. Stuart
     - Version: 1.0.0
     - Note: Can return `nil` so test for `nil` and unwrap as necessary
     */
    static subscript (port: String, baud: BaudRate) -> Serialable? { get }
    
    /**
     The Port the Serial Interface is connected to
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    var port: String { get }
    
    /**
     The Baud Rate of the Serial Interface
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    var baud: BaudRate { get }
    
    /**
     Returns `true` if the Serial Port is ready to work, `false` if it is not.
     - Author: Simon J. Stuart
     - Version: 1.0.0
     - Returns: `true` if the Serial Port is ready to work, `false` if it is not.
     */
    var isReady: Bool { get }
    
    /**
     Instructs the Serial Port to Open
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    func open()
    
    /**
     Instructs the Serial Port to Close
     - Author: Simon J. Stuart
     - Version: 1.0.0
     */
    func close()
}
