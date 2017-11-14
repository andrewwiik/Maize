#import <MediaPlayerUI/MPAVRoutingViewController.h>

@interface MPAVRoutingViewController ()
@property (nonatomic, assign) BOOL mze_customDisplay;
@end

%hook MPAVRoutingViewController
%property (nonatomic, assign) BOOL mze_customDisplay;
- (BOOL)_shouldShowAirPlayMirroringCompactDescriptionHeader {
	if (self.mze_customDisplay) {
		return NO;
	} else return %orig;
}
%end