#import <QuartzCore/CAState+Private.h>

@interface CALayer (Private)
@property (assign) CGColorRef contentsMultiplyColor; 
- (void)setAllowsGroupBlending:(BOOL)allowed;
- (CAState *)stateWithName:(NSString *)name;
@end