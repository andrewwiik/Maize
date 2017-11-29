//#import "headers.h"

#import <MaizeServices/MZEModuleMetadata.h>

@interface MZESettingsModuleTableViewCell : UITableViewCell {
	UIColor *_iconColor;
	MZEModuleMetadata *_metadata;
}
@property (nonatomic, retain) UIColor *iconColor;   //@synthesize sectionColor=_sectionColor - In the implementation block
@property (nonatomic, retain) UIView *backgroundGlyphView;
@property (nonatomic, retain, readwrite) MZEModuleMetadata *metadata;
- (void)layoutGlyphBackgroundView;
- (UIView *)findReorderView:(UIView *)view;
@end