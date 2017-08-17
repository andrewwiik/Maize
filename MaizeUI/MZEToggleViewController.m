#import "MZEToggleViewController.h"
#import "MZEToggleModule.h"

@implementation MZEToggleViewController

- (BOOL)shouldBeginTransitionToExpandedContentModule {
	return NO;
}

- (BOOL)allowHighlighting {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setGlyphImage:[_module iconGlyph]];
	[self setSelectedGlyphImage:[_module selectedIconGlyph]];
	[self setSelectedGlyphColor:[_module selectedColor]];
	[self setGlyphPackage:[_module glyphPackage]];
	[self setEnabled:[_module isEnabled]];
	[self setAllowsHighlighting:[_module allowsHighlighting]];
	[self refreshState];

}

- (void)refreshState {
	//if ([self isSelected] != [_module isSelected]) {
		[UIView performWithoutAnimation:^{
			[self setSelected:[_module isSelected]];
			[self setEnabled:[_module isEnabled]];
			[self setGlyphState:[_module glyphState]];
		}];
	//}
}

- (void)buttonTapped:(UIControl *)button forEvent:(id)event {
	//HBLogInfo(@"THE BUTTON WAS TAPPED");
	BOOL isSelected = [_module isSelected] ? NO : YES;
	if ([_module shouldSelfSelect])
		[self setSelected:isSelected];
	[_module setSelected:isSelected];
	[super buttonTapped:button forEvent:event];
}

- (CGFloat)preferredExpandedContentHeight {
	return 0;
}

- (void)setAllowsHighlighting:(BOOL)allowsHighlighting {
	[super setAllowsHighlighting:allowsHighlighting];
}

@end