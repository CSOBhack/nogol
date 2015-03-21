//
//  GameViewController.swift
//  nogol
//
//  Created by Alex Studnicka on 21/03/15.
//  Copyright (c) 2015 Nogol. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ViewController: UIViewController {

    override func viewDidLoad() {
		super.viewDidLoad()
		
		let label = UILabel()
		label.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
		label.textAlignment = .Center
		label.text = ""
		self.view.addSubview(label)
		
		// ----
		
		let scnView = self.view as! SCNView
		
		let scene = MainScene(view: scnView) { newValue in
			label.text = newValue
		}
		
		scnView.scene = scene
		scnView.allowsCameraControl = true
		scnView.showsStatistics = false
		scnView.backgroundColor = UIColor.whiteColor()
		
        let tapGesture = UITapGestureRecognizer(target: scene, action: "handleTap:")
        var gestureRecognizers = [AnyObject]()
        gestureRecognizers.append(tapGesture)
        if let existingGestureRecognizers = scnView.gestureRecognizers {
            gestureRecognizers.extend(existingGestureRecognizers)
        }
        scnView.gestureRecognizers = gestureRecognizers
		
    }
    	
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
