//
//  Actor.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

enum ActorType: String {
	case admin = "admin", hacker = "hacker"
}

class Actor: Mappable {
	
	var id: Int!
	var name: String!
	var current_action_points: Int!
	var type: ActorType!
	
	required init?(_ map: Map) {
		mapping(map)
	}
	
	// Mappable
	func mapping(map: Map) {
		id <- map["id"]
		name <- map["name"]
		current_action_points <- map["current_action_points"]
		type <- (map["type"], EnumTransform())
	}
	
}
