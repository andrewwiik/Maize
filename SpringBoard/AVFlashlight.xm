#import <AVFoundation/AVFlashlight.h>
#import <ControlCenterUI/CCUIFlashlightSetting.h>

@interface CCUIFlashlightSetting (MZE)
+ (instancetype)mze_sharedFlashlight;
@property (nonatomic, retain) AVFlashlight *flashlight;
@end

AVFlashlight *sharedFlashlight;


@interface MZEFlashlightModuleViewController : NSObject
+ (AVFlashlight *)currentFlashlight;
+ (instancetype)sharedFlashlightModule;
@end

%hook AVFlashlight
%new
+ (AVFlashlight *)mze_sharedFlashlight {
	if (sharedFlashlight != nil) {
		return sharedFlashlight;
	} else {
		return [[NSClassFromString(@"AVFlashlight") alloc] init];
	}
}

%new
+ (void)mze_setSharedFlashlight:(AVFlashlight *)flashlight {
	if (flashlight != sharedFlashlight) {
		CCUIFlashlightSetting *sharedSetting = [NSClassFromString(@"CCUIFlashlightSetting") mze_sharedFlashlight];
		if (sharedSetting) {
			if (sharedFlashlight) {
				@try {
					[sharedFlashlight removeObserver:sharedSetting forKeyPath:@"available" context:0x0];
	                [sharedFlashlight removeObserver:sharedSetting forKeyPath:@"overheated" context:0x0];
	                [sharedFlashlight removeObserver:sharedSetting forKeyPath:@"flashlightLevel" context:0x0];
				} @catch(id anException) {
					
				}
			}

			[sharedSetting setValue:flashlight forKey:@"_flashlight"];
			sharedSetting.flashlight = flashlight;

			@try {
				[flashlight addObserver:sharedSetting forKeyPath:@"available" options:0x0 context:0x0];
		        [flashlight addObserver:sharedSetting forKeyPath:@"overheated" options:0x0 context:0x0];
		        [flashlight addObserver:sharedSetting forKeyPath:@"flashlightLevel" options:0x0 context:0x0];
			} @catch(id anException) {

			}
		}
		sharedFlashlight = flashlight;
	}
}

- (AVFlashlight *)init {
	AVFlashlight *orig = %orig;
	if (orig) {
		CCUIFlashlightSetting *sharedSetting = [NSClassFromString(@"CCUIFlashlightSetting") mze_sharedFlashlight];
		if (sharedSetting) {

			if (sharedFlashlight && sharedFlashlight != nil) {
				@try {
					[sharedFlashlight removeObserver:sharedSetting forKeyPath:@"available" context:0x0];
	                [sharedFlashlight removeObserver:sharedSetting forKeyPath:@"overheated" context:0x0];
	                [sharedFlashlight removeObserver:sharedSetting forKeyPath:@"flashlightLevel" context:0x0];
				} @catch(id anException) {
					
				}
			}

			[sharedSetting setValue:orig forKey:@"_flashlight"];
			sharedSetting.flashlight = orig;

			@try {
				[orig addObserver:sharedSetting forKeyPath:@"available" options:0x0 context:0x0];
                [orig addObserver:sharedSetting forKeyPath:@"overheated" options:0x0 context:0x0];
                [orig addObserver:sharedSetting forKeyPath:@"flashlightLevel" options:0x0 context:0x0];
			} @catch(id anException) {

			}
		}
		// if (sharedFlashlight) {

		// 	// if (NSClassFromString(@"MZEFlashlightModuleViewController")) {
		// 	// 	MZEFlashlightModuleViewController *currentController = [NSClassFromString(@"MZEFlashlightModuleViewController") sharedFlashlightModule];
		// 	// 	if (currentController) {
		// 	// 		@try{
		// 	// 			[sharedFlashlight removeObserver:currentController forKeyPath:@"available" context:NULL];
		// 	// 			[sharedFlashlight removeObserver:currentController forKeyPath:@"flashlightLevel" context:NULL];
		// 	// 		} @catch(id anException){
		// 	// 			   //do nothing, obviously it wasn't attached because an exception was thrown
		// 	// 		}
		// 	// 	}
		// 	// }

		// 	sharedFlashlight = nil;
		// }
		sharedFlashlight = orig;
		//[orig performSelector:NSSelectorFromString(@"reatin") withObject:nil];
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
		// if (NSClassFromString(@"MZEFlashlightModuleViewController")) {
		// 	[[NSNotificationCenter defaultCenter] postNotificationName:@"MZENewFlashlightMade" object:nil];
		// }

		// MZEFlashlightModuleViewController *currentController = [NSClassFromString(@"MZEFlashlightModuleViewController") sharedFlashlightModule];
		// if (currentController) {
		// 	@try{
		// 		[orig addObserver:currentController forKeyPath:@"available" options:0 context:NULL];
		// 		[orig addObserver:currentController forKeyPath:@"flashlightLevel" options:0 context:NULL];
		// 	} @catch(id anException){
		// 		   //do nothing, obviously it wasn't attached because an exception was thrown
		// 	}
		// }
	}
	return orig;
}

- (void)dealloc {
	sharedFlashlight = nil;
	if (NSClassFromString(@"CCUIFlashlightSetting")) {
		CCUIFlashlightSetting *sharedSetting = [NSClassFromString(@"CCUIFlashlightSetting") mze_sharedFlashlight];
		if (sharedSetting) {
			@try {
				[self removeObserver:sharedSetting forKeyPath:@"available" context:0x0];
                [self removeObserver:sharedSetting forKeyPath:@"overheated" context:0x0];
                [self removeObserver:sharedSetting forKeyPath:@"flashlightLevel" context:0x0];
			} @catch(id anException) {
				
			}
		}
	}
	%orig;
}
%end


%ctor {
	if (NSClassFromString(@"AVFlashlight")) {
		if ([NSClassFromString(@"AVFlashlight") hasFlashlight]) {
			%init;
		}
	}
}