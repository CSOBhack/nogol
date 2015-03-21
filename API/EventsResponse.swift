//
//  EventsResponse.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

class EventsResponse: Mappable {
	
	var events: [Event]!
	
	required init?(_ map: Map) {
		mapping(map)
	}
	
	// Mappable
	func mapping(map: Map) {
		events <- map["_embedded.events"]
	}
	
}
