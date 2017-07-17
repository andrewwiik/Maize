@interface MZEModuleMetadata : NSObject {
	NSURL *_bundlePath;
	NSString *_identifier;
	NSNumber *_moduleWidth;
	NSNumber *_moduleHeight;
	NSArray *_supportedDeviceFamilies;
}
@property (nonatomic, retain, readwrite) NSURL *bundlePath;
@property (nonatomic, retain, readwrite) NSString *identifier;
@property (nonatomic, retain, readwrite) NSNumber *moduleWidth;
@property (nonatomic, retain, readwrite) NSNumber *moduleHeight;
@property (nonatomic, retain, readwrite) NSArray *supportedDeviceFamilies;
- (id)initWithBundlePath:(NSURL *)bundlePath;
@end