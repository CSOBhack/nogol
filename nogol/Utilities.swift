//
//  Utilities.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

class Utilities {
	
	class func calcCenter(index: Int, total: Int, outRadius: Double, inRadius: Double, start: Double) -> (x: Float, y: Float) {
		var x = outRadius/2
		var y = x
		let i = Double(index)
		let t = Double(total)
		let r = inRadius
		let a = (i * (2 * M_PI / t)) - M_PI_2 + start
		x += r * cos(a)
		y += r * sin(a)
		return (x: Float(x), y: Float(y))
	}
	
}