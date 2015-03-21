//
//  System.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

class Layer: Mappable {
	
	var id: Int!
	var name: String!
	var level: Int!
	var current_robustness: Int!
	var max_robustness: Int!
	var user_capacity: Int!
	
	required init?(_ map: Map) {
		mapping(map)
	}
	
	// Mappable
	func mapping(map: Map) {
		id <- map["id"]
		name <- map["name"]
		level <- map["level"]
		current_robustness <- map["current_robustness"]
		max_robustness <- map["max_robustness"]
		user_capacity <- map["user_capacity"]
	}
	
}
