#import <objc/runtime.h>
#import <dlfcn.h>

#import "CCUIFlashlightSetting+MZE.h"

@interface NSObject (TerribleProxy)
-(void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void*)arg4;
@end

@interface AVFlashlight : NSObject
@end

CCUIFlashlightSetting *sharedFlashlightSetting;


%hook CCUIFlashlightSetting 
%property (nonatomic, retain) NSObject *proxyKeyValueObject;
%property (nonatomic, retain) AVFlashlight *flashlight;

%new
+ (instancetype)mze_sharedFlashlight {
	if (sharedFlashlightSetting) {
		return sharedFlashlightSetting;
	} else {
		return [NSClassFromString(@"CCUIFlashlightSetting") new];
	}
}

- (id)init {
	CCUIFlashlightSetting *orig = %orig;
	sharedFlashlightSetting = orig;
	[orig activate];
	return orig;
}

- (void)activate {
	id flashlight = [NSClassFromString(@"AVFlashlight") mze_sharedFlashlight];
	if (flashlight) {
		[self setValue:flashlight forKey:@"_flashlight"];
	}
	%orig;
}


-(void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void*)arg4  {
	%orig;
	if (self.proxyKeyValueObject) {
		if ([self.proxyKeyValueObject respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
			[self.proxyKeyValueObject observeValueForKeyPath:arg1 ofObject:arg2 change:arg3 context:arg4];
		}
	}
}

// - (void)setFlashlight:(AVFlashlight *)flashlight {

// }
%end

%ctor {
	dlopen("/System/Library/PrivateFrameworks/ControlCenterUI.framework/ControlCenterUI", RTLD_NOW);
	%init;
}