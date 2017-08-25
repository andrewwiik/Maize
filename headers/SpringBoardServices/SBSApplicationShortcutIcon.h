@interface SBSApplicationShortcutIcon : NSObject

-(id)_initForSubclass;
-(id)init;
-(id)copyWithZone:(NSZone *)zone;
-(id)initWithXPCDictionary:(id)dict;
-(void)encodeWithXPCDictionary:(id)dict;
@end