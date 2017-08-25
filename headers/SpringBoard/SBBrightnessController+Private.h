@interface SBBrightnessController : NSObject {

	BOOL _debounce;

}
+(instancetype)sharedBrightnessController;
-(void)cancelBrightnessEvent;
-(float)_calcButtonRepeatDelay;
-(void)_setBrightnessLevel:(float)brightnessLevel showHUD:(BOOL)showHud;
-(void)increaseBrightnessAndRepeat;
-(void)adjustBacklightLevel:(BOOL)adjustLevel;
-(void)decreaseBrightnessAndRepeat;
-(void)setBrightnessLevel:(float)brightnessLevel;
@end