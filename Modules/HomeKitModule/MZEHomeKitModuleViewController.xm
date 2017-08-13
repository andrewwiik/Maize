%subclass MZEHomeKitModuleViewController : HUHomeControlCenterViewController 

- (void)controlCenterWillPresent {
	[self setLayoutStyle:0];
    [[NSClassFromString(@"HFCharacteristicNotificationManager") sharedManager] enableNotificationsForSelectedHomeWithReason:@"HUHomeControlCenterNotificationsEnabledReasonPresented"];
}

- (void)setWantsVisible:(BOOL)visible {
	return;
}

-(void)_homeButtonPressed:(id)arg1 {
	return;
}

- (id)prepareForActionRequiringDeviceUnlockForGridViewController:(id)arg1 {
	return;
}

-(void)gridViewControllerWillBeginApplyingDynamicBackgrounds:(id)arg1 {
	return;
}

-(void)gridViewControllerDidEndApplyingDynamicBackgrounds:(id)arg1 {
	return;
}
%end