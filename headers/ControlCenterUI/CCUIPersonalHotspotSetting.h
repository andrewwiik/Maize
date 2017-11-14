
#import "CCUISettingModule.h"

@interface CCUIPersonalHotspotSetting : CCUISettingModule
+(id)identifier;
+(id)displayName;
+(id)statusOnString;
+(id)statusOffString;
+(BOOL)isSupported:(int)arg1 ;
+(BOOL)isInternalButton;
-(void)dealloc;
-(void)deactivate;
-(void)_updateState;
-(void)activate;
-(id)aggdKey;
-(id)selectedStateColor;
-(BOOL)_toggleState;
-(id)glyphImageForState:(int)arg1 ;
@end