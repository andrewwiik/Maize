#import <MaizeUI/MZEToggleModule.h>

@interface BBSettingsGateway : NSObject
-(id)initWithQueue:(id)arg1;
- (void)setBehaviorOverrideStatus:(BOOL)enabled;
-(void)setBehaviorOverrideStatus:(NSInteger)arg1 source:(NSUInteger)arg2 ;
- (void)setActiveBehaviorOverrideTypesChangeHandler:(void (^)(BOOL))block;
- (void)getBehaviorOverridesEnabledWithCompletion:(void (^)(BOOL))block;
@end

@interface SBStatusBarDataManager : NSObject
+ (id)sharedDataManager;
- (void)setStatusBarItem:(int)arg1 enabled:(BOOL)arg2;
@end

@interface MZEDoNotDisturbModule : MZEToggleModule {
	BBSettingsGateway *_settingsGateway;
	BOOL _dndIsEnabled;
}
- (void)_observeSystemNotifications;
- (CAPackage *)glyphPackage;
- (NSString *)glyphState;
- (id)init;
- (BOOL)isSelected;
- (void)setSelected:(BOOL)arg1;
- (NSString *)statusText;
@end