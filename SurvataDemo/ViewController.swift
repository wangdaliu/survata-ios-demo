//
//  ViewController.swift
//  Demo
//
//  Created by Rex Sheng on 2/11/16.
//  Copyright © 2016 Survata. All rights reserved.
//

import Survata

@IBDesignable
public class GradientView: UIView {
	@IBInspectable public var color1: UIColor = UIColor.whiteColor() { didSet { setNeedsDisplay() } }
	@IBInspectable public var color2: UIColor = UIColor.whiteColor() { didSet { setNeedsDisplay() } }
	@IBInspectable public var loc1: CGPoint = CGPointMake(0, 0) { didSet { setNeedsDisplay() } }
	@IBInspectable public var loc2: CGPoint = CGPointMake(1, 1) { didSet { setNeedsDisplay() } }
	
	override public func drawRect(rect: CGRect) {
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

class ViewController: UIViewController {
	
	@IBOutlet weak var surveyMask: GradientView!
	@IBOutlet weak var surveyIndicator: UIActivityIndicatorView!
	@IBOutlet weak var surveyButton: UIButton!
	
	var created = false
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		createSurvey()
	}
	
	func showFull() {
		surveyMask.hidden = true
	}
	
	func showSurveyButton() {
		surveyMask.hidden = false
		surveyButton.hidden = false
		surveyIndicator.stopAnimating()
	}
	
	@IBAction func startSurvey() {
		Survey.presentFromController(self, brand: "", explainer: "") {[weak self] result in
			switch result {
			case .Completed:
				self?.showFull()
			default:
				self?.showSurveyButton()
			}
		}
	}
	
	func createSurvey() {
		if created { return }
		Survey.create("survata-test") {[weak self] result in
			self?.created = true
			switch result {
			case .Available:
				self?.showSurveyButton()
			default:
				self?.showFull()
			}
		}
	}
}