//
//  Action.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

class Action: Mappable {
	
	var id: Int!
	var name: String!
	var power: Int!
	var price: Int!
	
	required init?(_ map: Map) {
		mapping(map)
	}
	
	// Mappable
	func mapping(map: Map) {
		id <- map["id"]
		name <- map["name"]
		power <- map["power"]
		price <- map["price"]
	}
	
}
