#import "MZEToggleViewController.h"
#import "MZEToggleModule.h"

@implementation MZEToggleViewController

- (BOOL)shouldBeginTransitionToExpandedContentModule {
	return NO;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setGlyphImage:[_module iconGlyph]];
	[self setSelectedGlyphImage:[_module selectedIconGlyph]];
	[self setSelectedGlyphColor:[_module selectedColor]];
	[self setGlyphPackage:[_module glyphPackage]];
	[self refreshState];

}

- (void)refreshState {
	//if ([self isSelected] != [_module isSelected]) {
		[UIView performWithoutAnimation:^{
			[self setSelected:[_module isSelected]];
			[self setGlyphState:[_module glyphState]];
		}];
	//}
}

- (void)buttonTapped:(UIControl *)button forEvent:(id)event {
	HBLogInfo(@"THE BUTTON WAS TAPPED");
	BOOL isSelected = [_module isSelected] ? NO : YES;
	[self setSelected:isSelected];
	[_module setSelected:isSelected];
}

- (CGFloat)preferredExpandedContentHeight {
	return 0;
}

@end