//
//  GradientView.swift
//  Survata
//
//  Created by Rex Sheng on 2/16/16.
//  Copyright © 2016 Survata. All rights reserved.
//

import UIKit

@IBDesignable
public class GradientView: UIView {
	@IBInspectable var color1: UIColor = UIColor.whiteColor() { didSet { setNeedsDisplay() } }
	@IBInspectable var color2: UIColor = UIColor.whiteColor() { didSet { setNeedsDisplay() } }
	@IBInspectable var loc1: CGPoint = CGPointMake(0, 0) { didSet { setNeedsDisplay() } }
	@IBInspectable var loc2: CGPoint = CGPointMake(1, 1) { didSet { setNeedsDisplay() } }
	
	public override func drawRect(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		CGContextSaveGState(context)
		let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [color1.CGColor, color2.CGColor], [0, 1])
		CGContextDrawLinearGradient(context, gradient,
			CGPointMake(rect.size.width * loc1.x, rect.size.height * loc1.y),
			CGPointMake(rect.size.width * loc2.x, rect.size.height * loc2.y),
			CGGradientDrawingOptions.DrawsBeforeStartLocation.union(CGGradientDrawingOptions.DrawsAfterEndLocation))
		CGContextRestoreGState(context)
		super.drawRect(rect)
	}
}