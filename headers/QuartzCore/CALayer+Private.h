#import <QuartzCore/CAState+Private.h>

@interface CALayer (Private)
@property (assign) CGColorRef contentsMultiplyColor; 
@property (nonatomic, retain) NSArray *backgroundFilters;
@property BOOL hitTestsAsOpaque;
- (void)setAllowsGroupBlending:(BOOL)allowed;
- (CAState *)stateWithName:(NSString *)name;
-(void)setFillMode:(NSString *)arg1 ;
@end