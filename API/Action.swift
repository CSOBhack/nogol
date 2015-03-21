//
//  Action.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

class Action: Mappable {
	
	var name: String!
	
	required init?(_ map: Map) {
		mapping(map)
	}
	
	// Mappable
	func mapping(map: Map) {
		name <- map["name"]
	}
	
}
