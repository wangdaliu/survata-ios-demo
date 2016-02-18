//
//  ViewController.swift
//  Demo
//
//  Created by Rex Sheng on 2/11/16.
//  Copyright © 2016 Survata. All rights reserved.
//

import Survata
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet weak var surveyMask: UIView!
	@IBOutlet weak var surveyIndicator: UIActivityIndicatorView!
	@IBOutlet weak var surveyButton: UIButton!
	
	var created = false
	var locationManager: CLLocationManager!
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if CLLocationManager.authorizationStatus() == .NotDetermined {
			locationManager = CLLocationManager()
			locationManager.delegate = self
			locationManager.requestWhenInUseAuthorization()
		} else {
			createSurvey()
		}
	}
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {
			createSurvey()
		}
		if status != .NotDetermined {
			locationManager = nil
		}
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
		if motion == .MotionShake {
			let controller = UIAlertController(title: "Reset Demo?", message: nil, preferredStyle: .Alert)
			let option = UIAlertAction(title: "Reset", style: .Destructive) {[weak self] _ in
				guard let window = self?.view.window, storyboard = self?.storyboard else { return }
				NSHTTPCookieStorage.sharedHTTPCookieStorage().removeCookiesSinceDate(NSDate(timeIntervalSince1970: 0))
				window.rootViewController = storyboard.instantiateInitialViewController()
			}
			controller.addAction(option)
			controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			self.presentViewController(controller, animated: true, completion: nil)
		}
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
		Survey.presentFromController(self, option: SurveyOption()) {[weak self] result in
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
		print("Survey.create...")
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