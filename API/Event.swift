//
//  Event.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

class Event: Mappable {
	
	var id: Int!
	var action: Action!
	var actor: Actor!
	var node: Node?
	var date: NSDate!
	
	required init?(_ map: Map) {
		mapping(map)
	}
	
	// Mappable
	func mapping(map: Map) {
		id <- map["id"]
		action <- map["_embedded.action"]
		actor <- map["_embedded.actor"]
		node <- map["_embedded.node"]
		date <- (map["happened_at"], ISO8601DateTransform())
	}
	
}
