#import <SpringBoard/SBCCButtonModule.h>

@interface SBCCShortcutModule : SBCCButtonModule
{
    NSString *_displayID;
    NSURL *_url;
}

+ (NSString *)identifier;
+ (Class)viewControllerClass;
@property(copy, nonatomic, setter=setURL:) NSURL *url; // @synthesize url=_url;
@property(copy, nonatomic) NSString *displayID; // @synthesize displayID=_displayID;
- (void)activateAppWithDisplayID:(NSString *)displayID url:(NSURL *)url;
- (void)activateApp;
- (BOOL)_toggleState;
- (BOOL)isRestricted;
- (NSString *)aggdKey;
- (NSString *)displayName;
- (NSString *)identifier;
- (void)dealloc;

@end