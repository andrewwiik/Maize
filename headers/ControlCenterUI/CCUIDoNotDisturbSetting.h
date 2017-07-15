#import "CCUISettingModule.h"

@interface CCUIDoNotDisturbSetting : CCUISettingModule {

	NSInteger _activeStatus;
	BOOL _DNDEnabled;

}

@property (assign,setter=_setDNDEnabled:,getter=_isDNDEnabled,nonatomic) BOOL DNDEnabled;              //@synthesize DNDEnabled=_DNDEnabled - In the implementation block
+(id)identifier;
+(id)displayName;
+(id)statusOnString;
+(id)statusOffString;
-(void)dealloc;
-(void)deactivate;
-(void)_updateState;
-(void)activate;
-(void)_tearDown;
-(BOOL)_stateWithEffectiveOverrides;
-(BOOL)_isStateOverridden;
-(id)aggdKey;
-(id)selectedStateColor;
-(BOOL)_toggleState;
-(id)glyphImageForState:(int)arg1 ;
-(id)statusUpdate;
-(void)_setDNDEnabled:(BOOL)arg1 ;
-(void)_setDNDEnabled:(BOOL)arg1 updateServer:(BOOL)arg2 source:(unsigned long long)arg3 ;
-(void)_setDNDStatus:(long long)arg1 ;
-(void)_updateActiveOverrides:(id)arg1 ;
-(BOOL)_isDNDEnabled;
@end
