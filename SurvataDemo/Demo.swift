//
//  ViewController.swift
//  Demo
//
//  Created by Rex Sheng on 2/11/16.
//  Copyright © 2016 Survata. All rights reserved.
//

import Survata
import CoreLocation
import SVProgressHUD
import Greycats

public class SurveyDebugOption: SurveyOption, SurveyDebugOptionProtocol {
	public var preview: String?
	public var zipcode: String?
	public var sendZipcode: Bool = true

	public override var json: [String: AnyObject] {
		var option = super.json
		option["preview"] = preview
		return option
	}
}

class DemoViewController: UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var surveyMask: UIView!
	@IBOutlet weak var surveyIndicator: UIActivityIndicatorView!
	@IBOutlet weak var surveyButton: UIButton!

	var survey: Survey!

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
			if presentedViewController != nil { return }
			let controller = UIAlertController(title: "Reset Demo?", message: nil, preferredStyle: .Alert)
			let option = UIAlertAction(title: "Reset", style: .Destructive) {[weak self] _ in
				guard let window = self?.view.window, storyboard = self?.storyboard else { return }
				self?.survey = nil
				NSHTTPCookieStorage.sharedHTTPCookieStorage().removeCookiesSinceDate(NSDate(timeIntervalSince1970: 0))
				window.rootViewController = storyboard.instantiateInitialViewController()
			}
			controller.addAction(option)
			controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			presentViewController(controller, animated: true, completion: nil)
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
		survey.createSurveyWall(self) {[weak self] result in
			delay(2) {
				SVProgressHUD.dismiss()
			}
			switch result {
			case .Completed:
				SVProgressHUD.showInfoWithStatus("'surveyWall': completed")
				self?.showFull()
				return
			case .Canceled:
				SVProgressHUD.showInfoWithStatus("'surveyWall': canceled")
			case .CreditEarned:
				SVProgressHUD.showInfoWithStatus("'surveyWall': credit earned")
			case .NetworkNotAvailable:
				SVProgressHUD.showInfoWithStatus("'surveyWall': network not available")
			case .Skipped:
				SVProgressHUD.showInfoWithStatus("'surveyWall': skipped")
			}
			self?.showSurveyButton()
		}
	}

	func createSurvey() {
		if survey != nil { return }
		let option = SurveyDebugOption(publisher: Settings.publisherId)
		option.preview = Settings.previewId
		option.zipcode = Settings.forceZipcode
		option.sendZipcode = Settings.sendZipcode
		option.contentName = Settings.contentName
		survey = Survey(option: option)
		survey.create {[weak self] result in
			delay(2) {
				SVProgressHUD.dismiss()
			}
			switch result {
			case .Available:
				SVProgressHUD.showInfoWithStatus("'/create' call result: available")
				self?.showSurveyButton()
				return
			case .NetworkNotAvailable:
				SVProgressHUD.showInfoWithStatus("'/create' call result: network not available")

			case .NotAvailable:
				SVProgressHUD.showInfoWithStatus("'/create' call result: not available")
			case .ServerError:
				SVProgressHUD.showInfoWithStatus("'/create' call result: server error")
			}
			self?.showFull()
		}
	}
}