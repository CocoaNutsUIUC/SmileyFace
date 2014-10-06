//
//  FaceView.swift
//  IMSOHAPPYRIGHTNOW
//
//  Created by Justin Loew on 10/4/14.
//  Copyright (c) 2014 Lustin' Joew. All rights reserved.
//

import Foundation


import UIKit


class FaceView: UIView {
	
	var scale: CGFloat = 0.90 {
		// didSet is called every time scale is set (after it has the new value)
		didSet {
			// don't allow zero scale
			if scale == 0 {
				scale = CGFloat(0.90)
			}
			// any time our scale changes, call for redraw
			setNeedsDisplay()
		}
	}
	
	var dataSource: FaceViewDataSource? = nil
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
	}
	
	
	func drawCircleAtPoint(p: CGPoint, withRadius r: CGFloat, inContext context: CGContextRef) {
		UIGraphicsPushContext(context)
		
		CGContextBeginPath(context)
		CGContextAddArc(context, p.x, p.y, r, CGFloat(0.0), CGFloat(2*M_PI), 1)
		CGContextStrokePath(context)
		
		UIGraphicsPopContext()
	}
	
	func pinch(gesture: UIPinchGestureRecognizer) {
		if (gesture.state == .Changed) || (gesture.state == .Ended) {
			scale *= CGFloat(gesture.scale)	// adjust our scale
			gesture.scale = 1	// reset gestures scale to 1 (so future changes are incremental, not cumulative)
		}
	}
	
	override func drawRect(rect: CGRect) {
		var context = UIGraphicsGetCurrentContext()
		
		var midpoint = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2)
		
		var faceSize: CGFloat
		if self.bounds.size.width < self.bounds.size.height {
			faceSize = self.bounds.size.width / 2.0 * self.scale
		} else {
			faceSize = self.bounds.size.height / 2 * self.scale
		}
		
		CGContextSetLineWidth(context, 5)
		UIColor.blueColor().setStroke()
		
		drawCircleAtPoint(midpoint, withRadius: faceSize, inContext: context)
		
		let EYE_H = CGFloat(0.35)
		let EYE_V = CGFloat(0.35)
		let EYE_RADIUS = CGFloat(0.10)
		
		var eyePoint = CGPointMake(midpoint.x - faceSize * EYE_H, midpoint.y - faceSize * EYE_V)
		
		drawCircleAtPoint(eyePoint, withRadius: faceSize * EYE_RADIUS, inContext: context)	// left eye
		eyePoint.x += faceSize * EYE_H * 2
		drawCircleAtPoint(eyePoint, withRadius: faceSize * EYE_RADIUS, inContext: context)	// right eye
		
		let MOUTH_H = CGFloat(0.45)
		let MOUTH_V = CGFloat(0.40)
		let MOUTH_SMILE = CGFloat(0.25)
		
		var mouthStart = CGPointMake(midpoint.x - MOUTH_H * faceSize, midpoint.y + MOUTH_V * faceSize)
		var mouthEnd: CGPoint = mouthStart
		mouthEnd.x += MOUTH_H * faceSize * 2
		var mouthCP1: CGPoint = mouthStart
		mouthCP1.x += MOUTH_H * faceSize * 2/3
		var  mouthCP2: CGPoint = mouthEnd
		mouthCP2.x -= MOUTH_H * faceSize * 2/3
		
		var smile = CGFloat(dataSource!.smileForFaceView(self))
		if smile < -1 {
			smile = -1;
		}
		if smile > 1 {
			smile = 1;
		}
		
		var smileOffset: CGFloat = MOUTH_SMILE * faceSize * smile
		mouthCP1.y += smileOffset
		mouthCP2.y += smileOffset
		
		CGContextBeginPath(context)
		CGContextMoveToPoint(context, mouthStart.x, mouthStart.y)
		CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y)	// bezier curve
		CGContextStrokePath(context)
	}
}


protocol FaceViewDataSource {
	func smileForFaceView(sender: FaceView) -> Float
}