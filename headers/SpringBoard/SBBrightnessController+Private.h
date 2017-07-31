@interface SBBrightnessController : NSObject {

	BOOL _debounce;

}
+(instancetype)sharedBrightnessController;
-(void)cancelBrightnessEvent;
-(float)_calcButtonRepeatDelay;
-(void)_setBrightnessLevel:(float)arg1 showHUD:(BOOL)arg2 ;
-(void)increaseBrightnessAndRepeat;
-(void)adjustBacklightLevel:(BOOL)arg1 ;
-(void)decreaseBrightnessAndRepeat;
-(void)setBrightnessLevel:(float)arg1 ;
@end