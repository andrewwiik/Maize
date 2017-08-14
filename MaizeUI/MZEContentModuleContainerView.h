
@class MZEContentModuleContainerViewController;

@interface MZEContentModuleContainerView : UIView
{
    NSString *_moduleIdentifier;
    CGFloat _firstX;
    CGFloat _firstY;

}

@property(readonly, copy, nonatomic) NSString *moduleIdentifier; // @synthesize moduleIdentifier=_moduleIdentifier;
@property (nonatomic, retain) MZEContentModuleContainerViewController *viewDelegate;
- (id)initWithModuleIdentifier:(NSString *)identifier;

@end
