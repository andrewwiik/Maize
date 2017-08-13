#import <AVFoundation/AVFlashlight.h>


static AVFlashlight *sharedFlashlight;


// @interface MZEFlashlightModuleViewController : NSObject
// + (AVFlashlight *)currentFlashlight;
// + (instancetype)sharedFlashlightModule;
// @end

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
		// if (NSClassFromString(@"MZEFlashlightModuleViewController")) {
		// 	AVFlashlight *otherFlashlight = [NSClassFromString(@"MZEFlashlightModuleViewController") sharedFlashlight];
		// 	if (otherFlashlight) {
		// 		MZEFlashlightModuleViewController *controller = [NSClassFromString(@"MZEFlashlightModuleViewController") sharedFlashlightModule];
		// 		if (controller) {
		// 			[otherFlashlight removeObserver:controller forKeyPath:@"available" context:NULL];
		// 			[otherFlashlight removeObserver:controller forKeyPath:@"flashlightLevel" context:NULL];
		// 		}
		// 	}
		// }
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MZENewFlashlightMade" object:nil];
	}
	return orig;
}
%end