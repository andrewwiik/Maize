//#import "headers.h"

@interface MZESettingsModuleTableViewCell : UITableViewCell {
	UIColor *_iconColor;
}
@property (nonatomic, retain) UIColor *iconColor;   //@synthesize sectionColor=_sectionColor - In the implementation block
@property (nonatomic, retain) UIView *backgroundGlyphView;
- (void)layoutGlyphBackgroundView;
- (UIView *)findReorderView:(UIView *)view;
@end