%hook SBTelephonyManager
-(void)_setRegistrationStatus:(int)arg1 {
	%orig;
	[[NSNotificationCenter defaultCenter]
			postNotificationName:@"com.ioscreatix.Maize.CellularStateChanged"
			object:self];
}
%end