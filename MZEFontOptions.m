#import "MZEFontOptions.h"


static UIFont *roundButtonTitleFont;
static UIFont *roundButtonSubtitleFont;
@implementation MZEFontOptions
+ (UIFont *)roundButtonTitleFont {
	if (!roundButtonTitleFont) {
		UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption1];
		descriptor = [descriptor fontDescriptorByAddingAttributes:@{UIFontDescriptorFaceAttribute:@"Semibold"}];
		descriptor = [descriptor fontDescriptorWithSymbolicTraits:16386];
		roundButtonTitleFont = [UIFont fontWithDescriptor:descriptor size:0];
	}
	return roundButtonTitleFont;
}
+ (UIFont *)roundButtonSubtitleFont {
	if (!roundButtonSubtitleFont) {
		UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption1];
		roundButtonSubtitleFont = [UIFont fontWithDescriptor:descriptor size:0];
	}
	return roundButtonSubtitleFont;
}
@end