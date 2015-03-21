//
//  API.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import Foundation

let BASE_URL = "http://csob-hackathon.herokuapp.com:80/api/v1"

class _API {
	
	let networkQueue = NSOperationQueue()
	
	// MARK: Init
	
	private init() { }
	
	// MARK: Endpoints
	
	func nodes(callback: ((NodesResponse) -> ())) {
		let request = NSURLRequest(URL: NSURL(string: "\(BASE_URL)/nodes.json")!)
		NSURLConnection.sendAsynchronousRequest(request, queue: networkQueue) { response, data, error in
			let string = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
			let response = Mapper<NodesResponse>().map(string: string)
			dispatch_async(dispatch_get_main_queue()) {
				callback(response!)
			}
		}
	}
	
	func actors(callback: ((ActorsResponse) -> ())) {
		let request = NSURLRequest(URL: NSURL(string: "\(BASE_URL)/actors.json")!)
		NSURLConnection.sendAsynchronousRequest(request, queue: networkQueue) { response, data, error in
			let string = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
			let response = Mapper<ActorsResponse>().map(string: string)
			dispatch_async(dispatch_get_main_queue()) {
				callback(response!)
			}
		}
	}
	
	func events(page: Int = 0, callback: ((EventsResponse, Int) -> ())) {
		let request = NSURLRequest(URL: NSURL(string: "\(BASE_URL)/traffic.json?per_page=50&page=\(page)")!)
		NSURLConnection.sendAsynchronousRequest(request, queue: networkQueue) { response, data, error in
			
			let httpResponse = response as! NSHTTPURLResponse
			let pages = httpResponse.allHeaderFields["X-Total-Pages"] as! String
			
			let string = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
			let response = Mapper<EventsResponse>().map(string: string)
			dispatch_async(dispatch_get_main_queue()) {
				callback(response!, pages.toInt()!)
			}
			
		}
	}
	
}

let API = _API()
