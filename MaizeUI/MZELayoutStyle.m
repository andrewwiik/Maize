#import "MZELayoutStyle.h"
#import "MZELayoutOptions.h"
#import <MaizeServices/MZEModuleRepository.h>

static BOOL isDebug = NO;
static BOOL isIOS11Mode = YES;

@implementation MZELayoutStyle
- (id)initWithSize:(CGSize)size isLandscape:(BOOL)isLandscape {
	self = [super init];
	if (self) {
		isDebug = [MZEModuleRepository isDebug];
		_isLandscape = isLandscape;
		if (isLandscape) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				if (isDebug) {
					_isLandscape = NO;
					self.rows = -1;
					if (isIOS11Mode)
						self.columns = 13;
					else
						self.columns = 9;
				} else {
					_isLandscape = YES;
					self.rows = 2;
					self.columns = -1;
				}
			} else {
				self.rows = 3;
				self.columns = -1;
			}
		} else {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				if (isDebug) {
					_isLandscape = NO;
					self.rows = -1;
					if (isIOS11Mode)
						self.columns = 13;
					else
						self.columns = 9;
				} else {
					_isLandscape = YES;
					self.rows = 2;
					self.columns = -1;
				}
			} else {
				self.columns = 4;
				self.rows = -1;
			}
		}

		self.spacing = [MZELayoutOptions itemSpacingSize];
		self.inset = [MZELayoutOptions edgeInsetSize];
		self.moduleSize = [MZELayoutOptions edgeSize];
	}
	return self;
}

- (BOOL)isLandscape {
	return _isLandscape;
}
@end