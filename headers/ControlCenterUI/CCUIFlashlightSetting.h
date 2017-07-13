#import <ControlCenterUI/CCUISettingModule.h>

@interface CCUIFlashlightSetting : CCUISettingModule {

	
	BOOL _stayWarm;
	float _flashlightLevel;
	BOOL _flashlightOn;

}

@property (assign,getter=isFlashlightOn,nonatomic) BOOL flashlightOn;              //@synthesize flashlightOn=_flashlightOn - In the implementation block
+(id)identifier;
+(id)displayName;
+(BOOL)isSupported:(int)arg1 ;
-(void)dealloc;
-(void)deactivate;
-(void)_updateState;
-(void)activate;
-(void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void*)arg4 ;
-(id)displayName;
-(void)_setTorchLevel:(float)arg1 ;
-(void)_tearDown;
-(id)aggdKey;
-(BOOL)_toggleState;
-(id)glyphImageForState:(int)arg1 section:(int)arg2 ;
-(id)unavailableText;
-(int)orbBehavior;
-(id)statusUpdate;
-(id)buttonActions;
-(void)_deviceBlockStateDidChangeNotification:(id)arg1 ;
-(void)_featureLockStateDidChangeNotification:(id)arg1 ;
-(void)_updateFlashlightPowerState;
-(BOOL)_enableTorch:(BOOL)arg1 ;
-(void)setFlashlightOn:(BOOL)arg1 ;
-(BOOL)isFlashlightOn;
-(id)_settingImageNameForState:(int)arg1 ;
-(id)_shortcutImageNameForState:(int)arg1 ;
-(id)_imageNameForState:(int)arg1 section:(int)arg2 ;
-(void)warmup;
-(void)cooldown;
@end