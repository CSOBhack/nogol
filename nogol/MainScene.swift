//
//  MainScene.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import SceneKit
import CoreLocation

class MainScene: SCNScene {

	let view: SCNView
	
	var nodes: [Node]!
	var actors: [Actor]!
	
	// ----
	
	let goodEvents = ["config", "patch", "reroute", "release", "hotfix", "reload", "reboot"]
	let badEvents = ["phishing", "pharming", "keylog", "trojan", "dos", "ddos"]
	
	let redMaterial: SCNMaterial
	let greenMaterial: SCNMaterial
	let blueMaterial: SCNMaterial
	
	init(view: SCNView) {
		
		self.view = view
		
		self.redMaterial = SCNMaterial()
		self.redMaterial.diffuse.contents = UIColor.redColor()
		self.greenMaterial = SCNMaterial()
		self.greenMaterial.diffuse.contents = UIColor.greenColor()
		self.blueMaterial = SCNMaterial()
		self.blueMaterial.diffuse.contents = UIColor.blueColor()
		
		super.init()
		
		setupScene()
		loadData()
		
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	
	func setupScene() {
		
		let camDistance: Float = 18
		
		let cameraNode = SCNNode()
		cameraNode.camera = SCNCamera()
		cameraNode.position = SCNVector3(x: 0, y: 0, z: camDistance)
		self.rootNode.addChildNode(cameraNode)
		
		let lightNode = SCNNode()
		lightNode.light = SCNLight()
		lightNode.light!.type = SCNLightTypeOmni
		lightNode.position = SCNVector3(x: 0, y: 0, z: camDistance)
		self.rootNode.addChildNode(lightNode)
		
		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light!.type = SCNLightTypeAmbient
		ambientLightNode.light!.color = UIColor.darkGrayColor()
		self.rootNode.addChildNode(ambientLightNode)
		
		let mapPlane = SCNPlane(width: 10, height: 5.66)
		let mapNode = SCNNode(geometry: mapPlane)
		let mapMaterial = SCNMaterial()
		mapMaterial.diffuse.contents = UIImage(named: "map")
		mapPlane.firstMaterial = mapMaterial
		self.rootNode.addChildNode(mapNode)
		
	}
	
	// MARK: - Data
	
	func loadData() {
		
		let callback: (() -> ()) = {
			if self.nodes != nil && self.actors != nil {
				self.loadEvents(0)
			}
		}
		
		API.nodes() { response in
			
			self.nodes = response.nodes
			callback()
			
			for node in response.nodes {
				let coord = CLLocationCoordinate2D(latitude: node.venue_lat, longitude: node.venue_long)
				let point = Mercator.pointForCoord(coord)
				
				let size = Float(node.active_users)/Float(1E5)
				let nodeGeometry = SCNCylinder(radius: 0.1, height: 0.2)
				let nodeNode = SCNNode(geometry: nodeGeometry)
				nodeNode.name = "node-\(node.id)"
				nodeNode.scale = SCNVector3(x: 1, y: size, z: 1)
				nodeNode.eulerAngles = SCNVector3(x: Float(-M_PI_2), y: 0, z: 0)
				nodeNode.position = SCNVector3(x: point.x, y: point.y, z: 0)
				let nodeMaterial = SCNMaterial()
				nodeMaterial.diffuse.contents = UIColor.lightGrayColor()
				nodeGeometry.firstMaterial = nodeMaterial
				self.rootNode.addChildNode(nodeNode)
			}
		}
		
		API.actors() { response in
			
			var actors = response.actors
			actors.sort({ $0.id > $1.id })
			self.actors = actors
			callback()
			
			let total = count(actors)
			
			for (i, actor) in enumerate(actors) {
				
				let actorGeometry = SCNSphere(radius: 0.5)
				let actorNode = SCNNode(geometry: actorGeometry)
				actorNode.name = "actor-\(actor.id)"
				
				let point = Utilities.calcCenter(i, total: total, outRadius: 0.5, inRadius: 6, start: M_PI)
				actorNode.position = SCNVector3(x: point.x, y: point.y, z: 0)
				
				if actor.type == ActorType.admin {
					actorGeometry.firstMaterial = self.greenMaterial
				} else {
					actorGeometry.firstMaterial = self.redMaterial
				}
				
				self.rootNode.addChildNode(actorNode)
				
			}
		}
		
	}
	
	func loadEvents(page: Int) {
		
		API.events(page: page) { response, pages in
			for (i, event) in enumerate(response.events) {
				let place = event.node?.venue_name ?? "((broadcast))"
				
				let actorNode = self.rootNode.childNodeWithName("actor-\(event.actor.id)", recursively: false)
				
				if let node = event.node {
					
					let nodeNode = self.rootNode.childNodeWithName("node-\(node.id)", recursively: false)
					
					let messageGeometry = SCNSphere(radius: 0.1)
					let messageNode = SCNNode(geometry: messageGeometry)
					messageNode.name = "message-\(event.id)"
					messageNode.position = actorNode!.position
					messageNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(Double(i)*0.33), SCNAction.moveTo(nodeNode!.position, duration: 2), SCNAction.removeFromParentNode()]))
					
					if contains(self.badEvents, event.action.name) {
						messageGeometry.firstMaterial = self.redMaterial
					} else if contains(self.goodEvents, event.action.name) {
						messageGeometry.firstMaterial = self.greenMaterial
					} else {
						messageGeometry.firstMaterial = self.blueMaterial
					}
					
					self.rootNode.addChildNode(messageNode)
					
					let size = Float(node.active_users)/Float(1E5)
					let delay: Int64 = Int64(Double(i)*0.33)
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (delay * Int64(NSEC_PER_SEC))), dispatch_get_main_queue()) {
						SCNTransaction.begin()
						SCNTransaction.setAnimationDuration(0.33)
						nodeNode!.scale = SCNVector3(x: 1, y: size, z: 1)
						SCNTransaction.commit()
					}
					
				} else {
					
					let messageGeometry = SCNTorus(ringRadius: 0.5, pipeRadius: 0.1)
					let messageNode = SCNNode(geometry: messageGeometry)
					messageNode.name = "message-\(event.id)"
					messageNode.opacity = 0
					messageNode.position = actorNode!.position
					messageNode.eulerAngles = SCNVector3(x: Float(-M_PI_2), y: 0, z: 0)
					messageNode.runAction(SCNAction.sequence([SCNAction.waitForDuration(max(0, (Double(i)*0.33)-0.2)), SCNAction.fadeInWithDuration(0.2), SCNAction.group([SCNAction.scaleTo(5, duration: 2), SCNAction.fadeOutWithDuration(2)]), SCNAction.removeFromParentNode()]))
					messageGeometry.firstMaterial = self.blueMaterial
					self.rootNode.addChildNode(messageNode)
					
				}
				
			}
			
			let delay: Int64 = Int64(Double(count(response.events))*0.33)
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (delay * Int64(NSEC_PER_SEC))), dispatch_get_main_queue()) {
				self.loadEvents(page+1)
			}
		}
		
	}

	// MARK: - Tap
	
	func handleTap(gestureRecognize: UIGestureRecognizer) {
		let p = gestureRecognize.locationInView(view)
		if let hitResults = view.hitTest(p, options: nil) as? [SCNHitTestResult] {
			for result in hitResults {
				if let name = result.node.name {
					if name.hasPrefix("node") {
						println("node tapped")
					} else if name.hasPrefix("actor") {
						println("actor tapped")
					}
				}
			}
		}
	}
	
}
