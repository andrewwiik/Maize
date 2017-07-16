@interface MZEContentModuleContainerView : UIView
{
    NSString *_moduleIdentifier;
}

@property(readonly, copy, nonatomic) NSString *moduleIdentifier; // @synthesize moduleIdentifier=_moduleIdentifier;
- (id)initWithModuleIdentifier:(NSString *)identifier;

@end
