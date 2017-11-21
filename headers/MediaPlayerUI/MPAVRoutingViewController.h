@interface MPAVRoutingViewController : UIViewController
@property (assign,nonatomic) NSUInteger iconStyle;
@property (assign,nonatomic) NSUInteger mirroringStyle;
-(id)initWithStyle:(NSInteger)style;
-(UITableView *)_tableView;
-(void)_setTableCellsBackgroundColor:(UIColor *)color;
-(void)_setTableCellsContentColor:(UIColor *)color;
-(void)_beginRouteDiscovery;
-(void)_updateDisplayedRoutes;
-(void)_endRouteDiscovery;
-(void)_setRouteDiscoveryMode:(NSInteger)mode;
-(void)setDiscoveryModeOverride:(NSNumber *)modeOverride;
-(void)setAllowMirroring:(BOOL)allowMirroring;
-(UITableViewCell *)tableView:(UITableViewCell *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end