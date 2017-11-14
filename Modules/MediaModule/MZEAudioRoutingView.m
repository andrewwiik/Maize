#import "MZEAudioRoutingView.h"

@implementation MZEAudioRoutingView
- (id)init {
	self = [super init];
	if (self) {
		_routingViewController = [[NSClassFromString(@"MPAVRoutingViewController") alloc] initWithStyle:2];
		[_routingViewController _setTableCellsContentColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
		[_routingViewController _setTableCellsBackgroundColor:[UIColor clearColor]];
		_routingViewController.iconStyle = 1;
		//[_routingViewController setAllowMirroring:YES];
		_routingViewController.mirroringStyle = 1;
		_routingViewController.mze_customDisplay = YES;
		//[_routingViewController setAllowMirroring:YES];
		//[_routingViewController setDiscoveryModeOverride:@3];

		if (_routingViewController && !_routingTableView) {
			_routingTableView = [_routingViewController _tableView];
			[self addSubview:_routingTableView];
			_routingTableView.backgroundColor = nil;
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if (_routingViewController && !_routingTableView) {
		_routingTableView = [_routingViewController _tableView];
		[self addSubview:_routingTableView];
		_routingTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
	}

	if (_routingTableView) {
		//_routingTableView.separatorInset = UIEdgeInsetsMake(0,60,0,0);
		_routingTableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.16];
	}

	if (_routingTableView) {
		_routingTableView.frame = self.bounds;
	}

}
@end