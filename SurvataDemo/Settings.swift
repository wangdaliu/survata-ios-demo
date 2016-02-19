//
//  Settings.swift
//  SurvataDemo
//
//  Created by Rex Sheng on 2/19/16.
//  Copyright © 2016 InteractiveLabs. All rights reserved.
//

import Greycats

struct Settings {
	static var publisherId: String! = "survata-test"
	static var previewId: String! = "46b140a358cd4fe7b425aa361b41bed9"
	static var contentName: String!
	static var forceZipcode: String!
	static var sendZipcode: Bool = true
}

class Field: FormField {
	
	var onToggle: ((Bool) -> ())?
	
	@IBInspectable var hasToggle: Bool = true {
		didSet {
			setToggle()
		}
	}
	@IBOutlet weak var toggleSwitch: UISwitch! {
		didSet {
			setToggle()
		}
	}
	
	func setToggle() {
		toggleSwitch?.hidden = !hasToggle
	}
	
	@IBAction func didToggle(sender: AnyObject) {
		onToggle?(toggleSwitch.on)
	}
}

class SettingsViewController: UIViewController {
	@IBOutlet weak var publisherIdField: Field!
	@IBOutlet weak var previewField: Field!
	@IBOutlet weak var contentNameField: Field!
	@IBOutlet weak var zipcodeField: Field!
	
	override func viewDidLoad() {
		[publisherIdField, previewField, contentNameField, zipcodeField].createForm(self)
		contentNameField.onToggle = {[weak self] on in
			if !on {
				Settings.contentName = nil
				self?.contentNameField.text = nil
			}
		}
		zipcodeField.onToggle = { Settings.sendZipcode = $0 }
		reset()
	}
	
	@IBAction func reset() {
		Settings.publisherId = "survata-test"
		Settings.previewId = "46b140a358cd4fe7b425aa361b41bed9"
		publisherIdField.bind(&Settings.publisherId)
		previewField.bind(&Settings.previewId)
		contentNameField.bind(&Settings.contentName)
		zipcodeField.bind(&Settings.forceZipcode)
	}
}