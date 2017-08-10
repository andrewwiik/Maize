#import <MaizeUI/MZEExpandingModuleDelegate-Protocol.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>

#import <MPUFoundation/MPULayoutInterpolator.h>
#import "MZEMediaLayoutHelper.h"
#import <UIKit/UIScreen+Private.h>
#import "MZEMediaMetaDataView.h"
#import "MZEMediaMetaDataView.h"

@interface MPUControlCenterMediaControlsViewController : UIViewController
@end

@interface MZEMediaModuleViewController : UIViewController <MZEContentModuleContentViewController> {
	CGFloat _prefferedContentExpandedHeight;
	BOOL _isExpanded;

}
@property (nonatomic, retain, readwrite) MZEMediaMetaDataView *metadataView;
@property (nonatomic, retain, readwrite) MPUControlCenterMediaControlsViewController *controlsView;
@property (nonatomic, readwrite) BOOL isExpanded;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (CGFloat)preferredExpandedContentWidth;
- (CGFloat)preferredExpandedContentHeight;
- (BOOL)providesOwnPlatter;
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;
- (void)willBecomeActive;
- (void)willResignActive;
@end
