#import "CCUIButtonModule.h"

@interface CCUISettingModule : CCUIButtonModule {

	BOOL _needsStateUpdateOnNextPresentation;

}

@property (assign,nonatomic) BOOL needsStateUpdateOnNextPresentation;              //@synthesize needsStateUpdateOnNextPresentation=_needsStateUpdateOnNextPresentation - In the implementation block
@property (nonatomic,readonly) UIColor * selectedStateColor; 
+(id)statusOnString;
+(id)statusOffString;
-(BOOL)_isStateOverridden;
-(UIColor *)selectedStateColor;
-(id)unavailableText;
-(id)statusUpdate;
-(void)setNeedsStateUpdateOnNextPresentation:(BOOL)arg1 ;
-(BOOL)needsStateUpdateOnNextPresentation;
-(void)warmup;
@end