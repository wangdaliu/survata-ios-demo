//
//  ViewController.m
//  SurvataObjcDemo
//
//  Created by Rex Sheng on 2/22/16.
//  Copyright © 2016 InteractiveLabs. All rights reserved.
//

#import "ViewController.h"
@import Survata;
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet UIView *surveyMask;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *surveyIndicator;
@property (nonatomic, weak) IBOutlet UIButton *surveyButton;
@end

@implementation ViewController
{
	BOOL created;
	CLLocationManager *locationManager;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
		locationManager = [CLLocationManager new];
		locationManager.delegate = self;
		[locationManager requestWhenInUseAuthorization];
	} else {
		[self createSurvey];
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
		[self createSurvey];
	}
	if (status != kCLAuthorizationStatusNotDetermined) {
		locationManager = nil;
	}
}


- (void)showFull {
	self.surveyMask.hidden = YES;
}

- (void)showSurveyButton {
	self.surveyMask.hidden = NO;
	self.surveyButton.hidden = NO;
	[self.surveyIndicator stopAnimating];
}

- (IBAction)startSurvey {
	__weak __typeof(self) weakSelf = self;
	[SVSurvey presentFromController:self completion:^(enum SVSurveyResult result) {
		if (result == SVSurveyResultCompleted) {
			[weakSelf showFull];
		} else {
			[weakSelf showSurveyButton];
		}
	}];
}

- (void)createSurvey {
	if (created) return;
	SVSurveyOption *option = [[SVSurveyOption alloc] initWithPublisher:@"survata-test"];
	option.preview = @"46b140a358cd4fe7b425aa361b41bed9";
	__weak __typeof(self) weakSelf = self;
	[SVSurvey create:option completion:^(enum SVSurveyAvailability availability) {
		__strong __typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) return;
		strongSelf->created = YES;
		if (availability == SVSurveyAvailabilityAvailable) {
			[weakSelf showSurveyButton];
		} else {
			[weakSelf showFull];
		}
	}];
}

@end
