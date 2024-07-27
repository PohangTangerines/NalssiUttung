//
//  IntentHandler.swift
//  IntentHandler
//
//  Created by 금가경 on 7/28/24.
//

import Intents

class IntentHandler: INExtension, AddressSelectionIntentHandling {
    func provideLocationOptionsCollection(for intent: AddressSelectionIntent, with completion: @escaping (INObjectCollection<Location>?, Error?) -> Void) {
        let addresses = LocationInfo.Data.map { location in
            let weatherLocation = Location(
                identifier: location.name,
                display: location.address
            )
            return weatherLocation
        }
        
        let collection = INObjectCollection(items: addresses)
        completion(collection, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
