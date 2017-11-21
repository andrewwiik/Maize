#import "MZEAudioRoutingView.h"
#import "MZEAVRoutingViewController.h"
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>

@implementation MZEAudioRoutingView
- (id)init {
	self = [super init];
	if (self) {
		_routingViewController = [[NSClassFromString(@"MZEAVRoutingViewController") alloc] initWithStyle:2];
		[_routingViewController _setTableCellsContentColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
		[_routingViewController _setTableCellsBackgroundColor:[UIColor clearColor]];
		_routingViewController.iconStyle = 0;
		//[_routingViewController setAllowMirroring:YES];
		_routingViewController.mirroringStyle = 1;
		_routingViewController.mze_customDisplay = YES;
		_routingViewController.allowMirroring = NO;
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
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
		_routingTableView.backgroundColor = nil;
		_routingViewController.allowMirroring = NO;

	}

	if (_routingTableView) {
		//_routingTableView.separatorInset = UIEdgeInsetsMake(0,60,0,0);
		if (!_routingTableView.layer.filters || [_routingTableView.layer.filters count] == 0) {
			CAFilter *filter = [NSClassFromString(@"CAFilter") filterWithType:@"vibrantDark"];
			// // [filter setValue:(id)[[UIColor colorWithWhite:0.3 alpha:0.6] CGColor] forKey:@"inputColor0"];
			// // [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.15] CGColor] forKey:@"inputColor1"];
			// // [filter setValue:(id)[[UIColor colorWithWhite:0.45 alpha:0.7] CGColor] forKey:@"inputColor0"];
			// // [filter setValue:(id)[[UIColor colorWithWhite:0.65 alpha:0.3] CGColor] forKey:@"inputColor1"];
			// [filter setValue:(id)[[UIColor colorWithWhite:0.4 alpha:0.6] CGColor] forKey:@"inputColor0"];
			// [filter setValue:(id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor] forKey:@"inputColor1"];
			// [filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
			[filter setValue:(id)[[UIColor colorWithWhite:0.7 alpha:0.7] CGColor] forKey:@"inputColor0"];
			[filter setValue:(id)[[UIColor colorWithWhite:0.7 alpha:0.5] CGColor] forKey:@"inputColor1"];
			[filter setValue:[NSNumber numberWithBool:YES] forKey:@"inputReversed"];
			// CAFilter *filter2 = [NSClassFromString(@"CAFilter") filterWithType:@"colorBrightness"];
			// [filter2 setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputAmount"];

			_routingTableView.layer.filters = [NSArray arrayWithObjects:filter, nil];
		}
		_routingTableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.16];
	}

	if (_routingTableView) {
		_routingTableView.frame = self.bounds;
	}

}
@end