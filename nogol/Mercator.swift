//
//  Mercator.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import CoreLocation
import MapKit

class _Mercator {
	
	let minLat = 48.5
	let maxLat = 51.1
	let minLong = 12.0
	let maxLong = 19.1
	var xScale: Double, yScale: Double
	
	private init() {
		xScale = 10.0/(maxLong - minLong)
		yScale = 5.66/(maxLat - minLat)
	}
	
	func pointForCoord(coord: CLLocationCoordinate2D) -> (x: Float, y: Float) {
		let x = Float(((coord.longitude - minLong) * xScale) - 5)
		let y = Float((((coord.latitude - minLat) * yScale)) - 2.83)
		return (x, y)
	}
	
}

let Mercator = _Mercator()
