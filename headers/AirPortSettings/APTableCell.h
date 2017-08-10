#import "WiFiNetwork.h"

@interface APTableCell : UITableViewCell

@property (nonatomic,retain) WiFiNetwork * network;              //@synthesize network=_network - In the implementation block

+(id)__cellularProtocolStringForTetherDevice:(id)arg1 ;
-(void)layoutSubviews;
-(void)dealloc;
-(void)setDetailText:(id)arg1 ;
-(void)setSpinner:(BOOL)arg1 ;
-(WiFiNetwork *)network;
-(void)setNetwork:(WiFiNetwork *)arg1 ;
-(void)updateImages;
-(void)setNoAccessory:(BOOL)arg1 ;
-(void)setLabelOnly;
-(void)setHidesInfoButton:(BOOL)arg1 ;
-(BOOL)_displayCheckmark;
-(BOOL)_displaySpinner;
-(double)_rightBarsPadding;
-(void)__layoutRemoteHotspotDevice;
-(void)__layoutNetwork;
-(void)_dumpCellLayout;
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 ;
-(void)refreshCellContentsWithSpecifier:(id)arg1 ;
@end