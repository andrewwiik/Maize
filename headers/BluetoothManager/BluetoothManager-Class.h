#import "BluetoothDevice.h"

@interface BluetoothManager : NSObject
+(instancetype)sharedInstance;
-(NSArray<BluetoothDevice *> *)connectedDevices;
-(BOOL)deviceScanningInProgress;
-(void)setDeviceScanningEnabled:(BOOL)arg1;
-(void)scanForServices:(unsigned)arg1;
-(BOOL)powered;
-(BOOL)available;
-(BOOL)enabled;
-(BOOL)setPowered:(BOOL)arg1;
-(BOOL)setEnabled:(BOOL)arg1 ;
@end