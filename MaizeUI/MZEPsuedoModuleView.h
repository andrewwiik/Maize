@interface MZEPsuedoModuleView : UIView {
	NSString *_moduleIdentifier;
}
@property (nonatomic, retain, readwrite) NSString *moduleIdentifier;
- (id)initWithIdentifier:(NSString *)identifier;
@end