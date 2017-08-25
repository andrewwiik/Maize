#import <MediaPlayerUI/MPUEmptyNowPlayingView.h>
#import <SpringBoard/SBApplication.h>

@protocol MPUEmptyNowPlayingViewDelegate
@optional
-(void)emptyNowPlayingView:(MPUEmptyNowPlayingView *)emptyNowPlayingView couldNotLoadApplication:(SBApplication *)application;

@end