#import "SFAirDropDiscoveryControllerDelegate-Protocol.h"


@interface SFAirDropDiscoveryController : NSObject
@property (assign) NSInteger discoverableMode; 
@property (__weak) id<SFAirDropDiscoveryControllerDelegate> delegate;
-(void)setDiscoverableMode:(long long)arg1;
-(id)discoverableModeToString:(long long)arg1;
@end