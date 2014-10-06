//
//  happinessViewController.swift
//  IMSOHAPPYRIGHTNOW
//
//  Created by Justin Loew on 10/4/14.
//  Copyright (c) 2014 Lustin' Joew. All rights reserved.
//

import UIKit

class happinessViewController: UIViewController, FaceViewDataSource {
	
	@IBOutlet weak var faceView: FaceView! {
		didSet {
			faceView.dataSource = self
			
			// enable pinch gestures in the FaceView using its pinch() handler
			faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "pinch:"))
			
			faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handleHappinessChange:"))
		}
	}
	
	var happiness: Int = 0 {	// 0 for sad, 100 for happy
		didSet {
			faceView.setNeedsDisplay()
		}
	}
	
	func handleHappinessChange(gesture: UIPanGestureRecognizer) {
		if gesture.state == .Changed || gesture.state == .Ended {
			let translationAmount: CGPoint = gesture.translationInView(faceView)
			happiness += Int(translationAmount.y / 2)
			if happiness < 0 {
				happiness = 0
			}
			if happiness > 100 {
				happiness = 100
			}
			
			gesture.setTranslation(CGPointZero, inView: faceView)
		}
	}
	
	func smileForFaceView(sender: FaceView) -> Float {
		// happiness is 0-100. smile range is -1 to 1.
		return Float(happiness - 50) / Float(50)
	}
	
	override func shouldAutorotate() -> Bool {
		return true	// support all orientations
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

