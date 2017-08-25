#import <MediaPlayerUI/MPUMediaRemoteControlsView.h>

@protocol MPUControlCenterMediaControlsViewDelegate
@optional
-(void)mediaControlsView:(MPUMediaRemoteControlsView *)mediaControlsView willTransitionToCompactView:(BOOL)willTransition;
-(void)mediaControlsViewPrimaryActionTriggered:(UIButton *)buttonTriggered;

@end