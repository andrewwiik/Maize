#import "CCUIButtonModule.h"

@interface CCUIShortcutModule : CCUIButtonModule
+(id)identifier;
-(id)identifier;
-(void)activateAppWithDisplayID:(id)arg1 url:(id)arg2 unlockIfNecessary:(BOOL)arg3 ;
-(void)activateApp;
@end