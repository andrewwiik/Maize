#import <UIKit/UIButton.h>
#import <MediaPlayerUI/MPUEmptyNowPlayingViewDelegate-Protocol.h>

@interface MPUEmptyNowPlayingView : UIButton {

	UIImageView* _appIconImageView;
	UILabel* _appDisplayNameLabel;
	UILabel* _continueListeningLabel;
	BOOL _shouldShowActionText;
	id<MPUEmptyNowPlayingViewDelegate> _delegate;
	NSString* _appBundleIdentifier;

}

@property (assign,nonatomic) id<MPUEmptyNowPlayingViewDelegate> delegate;
@property (nonatomic,copy) NSString * appBundleIdentifier;
@property (assign,nonatomic) BOOL shouldShowActionText;
-(id)initWithFrame:(CGRect)frame;
-(void)layoutSubviews;
-(void)setDelegate:(id<MPUEmptyNowPlayingViewDelegate>)arg1 ;
-(id<MPUEmptyNowPlayingViewDelegate>)delegate;
-(void)setHighlighted:(BOOL)highlighted;
-(NSString *)appBundleIdentifier;
-(void)setAppBundleIdentifier:(NSString *)identifier;
-(void)setShouldShowActionText:(BOOL)shouldShow;
-(UIImage *)_desaturatedImageWithImage:(UIImage *)image;
-(BOOL)shouldShowActionText;
@end
