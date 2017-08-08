@interface SBWiFiManager : NSObject
{
    void *_manager;
    void *_device;
}

+ (id)sharedInstance;
- (void)_primaryInterfaceChanged:(BOOL)arg1;
- (void)_setPrimaryInterfaceHasBeenSet;
- (id)_wifiInterface;
- (BOOL)isPrimaryInterface;
- (void)resetSettings;
- (id)knownNetworks;
- (void)updateSignalStrength;
- (void)updateSignalStrengthFromRawRSSI:(int)arg1 andScaledRSSI:(CGFloat)arg2;
- (int)signalStrengthRSSI;
- (int)signalStrengthBars;
- (void)setWiFiEnabled:(BOOL)arg1;
- (BOOL)wiFiEnabled;
- (void)setPowered:(BOOL)arg1;
- (BOOL)isPowered;
- (id)currentNetworkName;
- (BOOL)_cachedIsAssociated;
- (BOOL)isAssociatedToIOSHotspot;
- (BOOL)isAssociated;
- (void)_updateCurrentNetwork;
- (void)_updateWiFiDevice:(id)arg1;
- (void)_linkDidChange;
- (void)_powerStateDidChange;
- (void)_updateWiFiState;
- (void *)_manager;
- (void *)_device;
- (void)updateDevicePresence;
- (BOOL)devicePresent;
- (BOOL)wifiSupported;
- (id)init;

@end