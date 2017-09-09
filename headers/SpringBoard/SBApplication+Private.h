#import <SpringBoard/SBApplication.h>

@interface SBApplication (Private)
@property (nonatomic,copy,readonly) NSArray * staticApplicationShortcutItems; 
@property (nonatomic,copy) NSArray * dynamicApplicationShortcutItems;
-(id)bundle;
@end