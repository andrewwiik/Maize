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
	[UIView performWithoutAnimation:^{
		[self setSelected:[_module isSelected]];
		[self setGlyphState:[_module glyphState]];
	}];
}

- (void)buttonTapped:(UIControl *)button forEvent:(id)event {
	[_module setSelected:([_module isSelected] ^ 0x1) & 0xff];
	[self setSelected:[_module isSelected]];
}

- (CGFloat)preferredExpandedContentHeight {
	return 0;
}

@end