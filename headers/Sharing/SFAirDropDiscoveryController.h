#import "SFAirDropDiscoveryControllerDelegate-Protocol.h"

@interface SFAirDropDiscoveryController : NSObject
@property (assign) NSInteger discoverableMode; 
@property (nonatomic) __weak id<SFAirDropDiscoveryControllerDelegate> delegate;
-(void)setDiscoverableMode:(NSInteger)discoverableMode;
-(id)discoverableModeToString:(NSInteger)discoverableMode;
-(id)init;
@end