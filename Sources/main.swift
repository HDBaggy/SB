//
//  main.swift
//  PerfectTemplate
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import SwiftyGPIO

public class GPIOController {
    
    let objGpio = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    
    func configurePins(){
        
        let objPin = objGpio[.P2]!
        objPin.direction = .OUT
        
        
        objPin.onRaising{
            gpio in
            print("Transition to 1, current value:" + String(gpio.value))
        }
        
        objPin.onFalling{
            gpio in
            print("Transition to 0, current value:" + String(gpio.value))
        }
        
        objPin.onChange{
            gpio in
            gpio.clearListeners()
            print("The value changed, current value:" + String(gpio.value))
        }
        
        
    }
    
}


let objGpioController = GPIOController()
let objServer = HTTPServer()
objServer.serverPort = 8181

var objRoutes = Routes()
objRoutes.add(method: .get, uri: "/") { (request, response) in
    
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>").completed()
}

objRoutes.add(method: .get, uri: "/gpio") { (request, response) in
    
    
    objGpioController.configurePins()
    
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello, world!</title><body>Welcome to GPIO page</body></html>").completed()
}

objServer.addRoutes(objRoutes)

do {
    try objServer.start()
} catch {
    
    print("There is an error starting the server")
}


