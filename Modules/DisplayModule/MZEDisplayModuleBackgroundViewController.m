#import "MZEDisplayModuleBackgroundViewController.h"
#import <UIKit/UIColor+Private.h>
#import <UIKit/UIImage+Private.h>
#import <MaizeUI/MZELayoutOptions.h>
#import "macros.h"

typedef struct {
    int hour;
    int minute;
} CBBlueLightTransitionTime;

typedef struct {
	BOOL active;
	BOOL enabled;
	BOOL sunSchedulePermitted;
	int mode;
	struct {
		CBBlueLightTransitionTime fromTime;
		CBBlueLightTransitionTime toTime;
	} schedule;
	NSUInteger disableFlags;
} CBBlueLightStatus;

@interface CBBlueLightClient : NSObject
+(BOOL)supportsBlueLightReduction;
-(BOOL)setEnabled:(BOOL)arg1 withOption:(int)arg2 ;
- (BOOL)getBlueLightStatus:(CBBlueLightStatus *)status;
- (void)setStatusNotificationBlock:(void (^)(CBBlueLightStatus *))callback;
-(void)enableNotifications;
@end

static CBBlueLightClient *client;
static BOOL nightShiftEnabled = NO;
MZEDisplayModuleBackgroundViewController *displayBackgroundController;

@implementation MZEDisplayModuleBackgroundViewController
- (id)init {
	self = [super init];
	if (self) {
		_bundle = [NSBundle bundleForClass:[self class]];
	}

	return self;
}
- (void)_setupNightShiftButton {
	if (!_nightShiftButton) {

		if (!_bundle) {
			_bundle = [NSBundle bundleForClass:[self class]];
		}

		UIImage *glyphImage = [[UIImage imageNamed:@"NightShift" inBundle:_bundle] _flatImageWithColor:[UIColor whiteColor]];
		UIColor *highlightColor = [UIColor systemOrangeColor];
		_nightShiftButton = [[MZELabeledRoundButtonViewController alloc] initWithGlyphImage:glyphImage highlightColor:highlightColor];
		// _nightShiftButton.useDarkTheme = YES;
		[_nightShiftButton setLabelsVisible:YES];
		[_nightShiftButton setTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_NIGHT_SHIFT_SETTING_NAME" value:@"" table:nil]];
		[_nightShiftButton setSubtitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_NIGHT_SHIFT_ON_MANUAL" value:@"" table:nil]];
		[[_nightShiftButton button] addTarget:self action:@selector(_nightShiftButtonPressed:) forControlEvents:0x40];
		[self.view addSubview:[_nightShiftButton view]];
		_nightShiftButton.useDarkTheme = YES;
		//CONTROL_CENTER_NIGHT_SHIFT_SETTING_NAME
	}
}

- (void)_nightShiftButtonPressed:(UIButton *)button {
	if (nightShiftEnabled) {
		[client setEnabled:NO withOption:3];
		nightShiftEnabled = NO;
	} else {
		[client setEnabled:YES withOption:3];
		nightShiftEnabled = YES;
	}
	[self viewWillLayoutSubviews];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	displayBackgroundController = self;
	Class CBBlueLightClientClass = NSClassFromString(@"CBBlueLightClient");
	//client = [[CBBlueLightClientClass alloc] init];
	// if ([client getBlueLightStatus:&status]) {
	// 	nightShiftEnabled = status.enabled;
	// }
	if ([CBBlueLightClientClass supportsBlueLightReduction]) {
		[self _setupNightShiftButton];

		client = [[CBBlueLightClientClass alloc] init];

		CBBlueLightStatus status;
		if ([client getBlueLightStatus:&status]) {
			nightShiftEnabled = status.enabled;
		}

		[client setStatusNotificationBlock:^(CBBlueLightStatus *status) {
			nightShiftEnabled = status->enabled;
			if (displayBackgroundController) {
				[displayBackgroundController viewWillLayoutSubviews];
			}
		    //[[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:@"com.a3tweaks.switch.night-shift"];
		}];

		[client enableNotifications];
	}
}
- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	if (_nightShiftButton) {

		if (!_bundle) {
			_bundle = [NSBundle bundleForClass:[self class]];
		}
		_nightShiftButton.useDarkTheme = YES;

		CBBlueLightStatus status;
		if ([client getBlueLightStatus:&status]) {
			nightShiftEnabled = status.enabled;
		}

		[_nightShiftButton setTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_NIGHT_SHIFT_SETTING_NAME" value:@"" table:nil]];
		if (nightShiftEnabled) {
			[_nightShiftButton setSubtitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_NIGHT_SHIFT_ON_MANUAL" value:@"" table:nil]];
		} else {
			[_nightShiftButton setSubtitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_NIGHT_SHIFT_OFF_MANUAL" value:@"" table:nil]];
		}

		// if ([client getBlueLightStatus:&status]) {
		// 	nightShiftEnabled = status.enabled;
		// }

		[_nightShiftButton setEnabled:nightShiftEnabled];
		CGRect bounds = CGRectZero;
		CGPoint centerPoint = CGPointMake(0,0);
		if (self.view) {
			bounds = [self.view bounds];
		}

		CGFloat expandedWidth = [MZELayoutOptions defaultExpandedSliderWidth];
		CGFloat buttonWidth = expandedWidth;
		if (bounds.size.width > bounds.size.height && !(isPad)) {
			CGFloat boundsWidth = CGRectGetWidth(bounds);
			CGFloat centerSpaceLeft = boundsWidth - ((boundsWidth - expandedWidth) * 0.25);
			CGFloat midY = CGRectGetMidY(bounds);
			centerPoint.y = midY;
			centerPoint.x = centerSpaceLeft;
		} else {
			CGFloat boundsHeight = CGRectGetHeight(bounds);
			CGFloat expandedHeight = [MZELayoutOptions defaultExpandedSliderHeight];
			CGFloat centerSpaceLeft = boundsHeight - ((boundsHeight - expandedHeight) * 0.25);
			CGFloat midX = CGRectGetMidX(bounds);
			centerPoint.y = centerSpaceLeft;
			centerPoint.x = midX;
		}

		centerPoint = UIPointRoundToViewScale(centerPoint, _nightShiftButton.view);
		
		_nightShiftButton.view.frame = CGRectMake(0,0,buttonWidth,[[_nightShiftButton view] intrinsicContentSize].height);
		_nightShiftButton.view.center = centerPoint;
	}
}
@end