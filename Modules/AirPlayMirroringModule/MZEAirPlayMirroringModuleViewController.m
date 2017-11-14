#import "MZEAirPlayMirroringModuleViewController.h"
#import "MZEAirPlayMirroringModule.h"
#import <MaizeUI/MZELayoutOptions.h>

#import "macros.h"

@implementation MZEAirPlayMirroringModuleViewController
- (id)init {
	self = [super init];
	if (self) {
		_routingViewController = [[NSClassFromString(@"MPAVRoutingViewController") alloc] initWithStyle:2];
		[_routingViewController _setTableCellsContentColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
		[_routingViewController _setTableCellsBackgroundColor:[UIColor clearColor]];
		_routingViewController.iconStyle = 1;
		//[_routingViewController setAllowMirroring:YES];
		_routingViewController.mirroringStyle = 2;
		_routingViewController.mze_customDisplay = YES;
		//[_routingViewController setAllowMirroring:YES];
		//[_routingViewController setDiscoveryModeOverride:@3];

	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	if (_routingViewController && !_routingTableView) {
		_routingTableView = [_routingViewController _tableView];
		[self.containerView addArrangedSubview:_routingTableView];
		_routingTableView.backgroundColor = nil;
	}

	// [self setGlyphImage:[_module iconGlyph]];
	// [self setSelectedGlyphImage:[_module iconGlyph]];
	// [self setSelectedGlyphColor:[UIColor whiteColor]];
	[self setGlyphPackage:[_module glyphPackage]];
	// [self setEnabled:[_module isEnabled]];
	[self setAllowsHighlighting:YES];
	//[self refreshState];
}


- (void)buttonTapped:(UIControl *)button forEvent:(id)event {
	// if (_module) {
	// 	if ([_module applicationIdentifier]) {
	// 		if ([[_module applicationIdentifier] length] > 0) {
	// 			if (NSClassFromString(@"SBApplication")) {
	// 				SBApplication *app = applicationForID([_module applicationIdentifier]);
	// 				if (app) {
	// 					launchApplication(app);
	// 				}
	// 			}
	// 		}
	// 	}
	// }
	//HBLogInfo(@"THE BUTTON WAS TAPPED");
	// BOOL isSelected = [_module isSelected] ? NO : YES;
	// if ([_module shouldSelfSelect])
	// 	[self setSelected:isSelected];
	// [_module setSelected:isSelected];
	[super buttonTapped:button forEvent:event];
}

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
	[super willTransitionToExpandedContentMode:expanded];
	if (_routingViewController) {
		if (expanded) {
			[_routingViewController _beginRouteDiscovery];
		} else {
			[_routingViewController _endRouteDiscovery];
		}
	}
}

- (CGFloat)preferredExpandedContentHeight {
	return [self headerHeight] + 300;
}

- (CGFloat)_menuItemsHeight {
	return 300;
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	if (_routingViewController && !_routingTableView) {
		_routingTableView = [_routingViewController _tableView];
		[self.containerView addArrangedSubview:_routingTableView];
		_routingTableView.backgroundColor = nil;
	}

	if (_routingTableView) {
		_routingTableView.separatorInset = UIEdgeInsetsMake(0,60,0,0);
		_routingTableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	}



	if (_routingTableView && _containerView) {
		_routingTableView.frame = CGRectMake(0,0,[self preferredExpandedContentWidth], [self preferredExpandedContentHeight] - [self headerHeight]);
	}
}
@end