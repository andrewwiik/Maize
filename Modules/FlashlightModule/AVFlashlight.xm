
AVFlashlight *sharedFlashlight;

%hook AVFlashlight
%new
+ (AVFlashlight *)sharedFlashlight {
	if (sharedFlashlight) {
		return sharedFlashlight;
	} else {
		return [[NSClassFromString(@"AVFlashlight") alloc] init];
	}
}

- (AVFlashlight *)init {
	AVFlashlight *orig = %orig;
	if (orig) {
		sharedFlashlight = orig;
	}
	return orig;
}
%end