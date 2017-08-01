#import "RadiosPreferencesDelegate-Protocol.h"

@interface RadiosPreferences : NSObject {

	int _applySkipCount;
	id<RadiosPreferencesDelegate> _delegate;
	BOOL _isCachedAirplaneModeValid;
	BOOL _cachedAirplaneMode;
	BOOL notifyForExternalChangeOnly;

}

@property (assign,nonatomic) BOOL airplaneMode; 
@property (assign,nonatomic) id<RadiosPreferencesDelegate> delegate;              //@synthesize delegate=_delegate - In the implementation block
@property (assign,nonatomic) BOOL notifyForExternalChangeOnly; 
+(BOOL)shouldMirrorAirplaneMode;
-(void)initializeSCPrefs:(id)arg1 ;
-(void)setAirplaneModeWithoutMirroring:(BOOL)arg1 ;
-(BOOL)notifyForExternalChangeOnly;
-(id)init;
-(void)setDelegate:(id<RadiosPreferencesDelegate>)arg1 ;
-(id<RadiosPreferencesDelegate>)delegate;
-(void)synchronize;
-(id)initWithQueue:(id)arg1 ;
-(void)refresh;
-(BOOL)airplaneMode;
-(void)setAirplaneMode:(BOOL)arg1 ;
-(void)setNotifyForExternalChangeOnly:(BOOL)arg1 ;
@end