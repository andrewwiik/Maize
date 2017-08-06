%hook SBWiFiManager
%new
- (void *)_device {
	return MSHookIvar<void *>(self, "_device");
}

%new
- (void *)_manager {
	return MSHookIvar<void *>(self, "_manager");
}
%end