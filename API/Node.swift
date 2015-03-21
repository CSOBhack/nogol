//
//  Node.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

class Node: Mappable {
	
	var id: Int!
	var ip_address: String!
	var venue_name: String!
	var venue_address: String!
	var venue_lat: Double!
	var venue_long: Double!
	var active_users: Int!
	var layers: [Layer]!
	
	required init?(_ map: Map) {
		mapping(map)
	}
	
	// Mappable
	func mapping(map: Map) {
		id <- map["id"]
		ip_address <- map["ip_address"]
		venue_name <- map["venue_name"]
		venue_address <- map["venue_address"]
		venue_lat <- map["venue_lat"]
		venue_long <- map["venue_long"]
		active_users <- map["active_users"]
		layers <- map["_embedded.layers"]
	}
	
}
