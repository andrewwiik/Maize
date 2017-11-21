@interface MPAVRoutingTableViewCell : UITableViewCell {

	UIImageView* _iconImageView;
	UILabel* _routeNameLabel;
	UILabel* _subtitleTextLabel;
	UIActivityIndicatorView* _spinnerView;
	UILabel* _mirroringLabel;
	UISwitch* _mirroringSwitch;
	UIView* _mirroringSeparatorView;
	BOOL _mirroringSwitchVisible;
	BOOL _debugCell;
	BOOL _pendingSelection;
	NSUInteger _mirroringStyle;
	NSUInteger _iconStyle;

}

-(id)_detailTextForRoute:(id)arg1 ;
-(id)_iconImageForRoute:(id)arg1 ;
-(BOOL)_shouldShowMirroringAsEnabledForRoute:(id)arg1 ;
-(void)setMirroringSwitchVisible:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)_configureLabel:(id)arg1 ;
-(void)_mirroringSwitchValueDidChange:(id)arg1 ;
-(BOOL)_shouldShowSeparateBatteryPercentagesForBatteryLevel:(id)arg1 ;
-(id)_routingImageStyleName;
-(id)_airpodsIconImageName;
-(id)_currentDeviceRoutingIconImageName;
-(void)setMirroringSwitchVisible:(BOOL)arg1 ;
-(void)setMirroringStyle:(NSUInteger)arg1 ;
-(void)setDebugCell:(BOOL)arg1 ;
-(void)setPendingSelection:(BOOL)arg1 ;
-(void)_configureDetailLabel:(id)arg1 ;
-(BOOL)mirroringSwitchVisible;
-(NSUInteger)mirroringStyle;
-(NSUInteger)iconStyle;
-(void)setIconStyle:(NSUInteger)arg1 ;
-(BOOL)isDebugCell;
-(BOOL)isPendingSelection;
@end
