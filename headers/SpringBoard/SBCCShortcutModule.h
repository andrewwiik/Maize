#import <SpringBoard/SBCCButtonModule.h>

@interface SBCCShortcutModule : SBCCButtonModule
{
    NSString *_displayID;
    NSURL *_url;
}

+ (id)identifier;
+ (Class)viewControllerClass;
@property(copy, nonatomic, setter=setURL:) NSURL *url; // @synthesize url=_url;
@property(copy, nonatomic) NSString *displayID; // @synthesize displayID=_displayID;
- (void)activateAppWithDisplayID:(id)arg1 url:(id)arg2;
- (void)activateApp;
- (_Bool)_toggleState;
- (_Bool)isRestricted;
- (id)aggdKey;
- (id)displayName;
- (id)identifier;
- (void)dealloc;

@end