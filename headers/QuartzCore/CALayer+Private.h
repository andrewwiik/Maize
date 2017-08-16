#import <QuartzCore/CAState+Private.h>
#import <QuartzCore/CAFilter+Private.h>

@interface CALayer (Private)
@property (assign) CGColorRef contentsMultiplyColor; 
@property (nonatomic, retain) NSArray *backgroundFilters;
@property (nonatomic, retain) CAFilter *compositingFilter;
@property (assign) CGRect cornerContentsCenter;
@property (nonatomic, retain) NSString *groupName;
@property(getter=isFrozen) BOOL frozen;
@property BOOL hitTestsAsOpaque;
- (void)setAllowsGroupBlending:(BOOL)allowed;
- (CAState *)stateWithName:(NSString *)name;
-(void)setFillMode:(NSString *)arg1 ;
@end