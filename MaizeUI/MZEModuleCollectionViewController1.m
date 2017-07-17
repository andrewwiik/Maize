#import "MZEModuleCollectionViewController.h"
#import "MZEModuleContainerViewController.h"
#import "MZELayoutOptions.h"

@implementation MZEModuleCollectionViewController
- (id)initWithFrame:(CGRect)frame {
	self = [super init];
	if (self) {
		_firstFrame = frame;
		self.moduleViewControllers = [NSMutableArray new];
		_itemEdgeSize = [MZELayoutOptions edgeSize];
    	_itemSpacingSize = [MZELayoutOptions itemSpacingSize];
    	_edgeInsetSize = [MZELayoutOptions edgeInsetSize];
	}
	return self;
}

- (void)loadView {
	[super loadView];

	NSMutableArray *inputRectangles = [NSMutableArray new];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,0,2,2)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(2,0,2,2)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,2,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(1,2,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(2,2,1,2)]]; //
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(3,2,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,3,2,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(3,3,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,4,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(1,4,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(2,4,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(3,4,1,1)]];
    [inputRectangles addObject:[NSValue valueWithCGRect:CGRectMake(0,5,1,1)]];

    CGRect superviewFrame = _firstFrame;

	if ([self.view superview]) {
    	superviewFrame = [self.view.superview frame];
    }
    CGRect lastBlock = [(NSValue *)[inputRectangles objectAtIndex:[inputRectangles count]-1] CGRectValue];

    CGFloat yOrigin = 0 + (_itemEdgeSize*((lastBlock.origin.y+1)-1)) + (_itemSpacingSize*((lastBlock.origin.y+1)-1));
    CGFloat lastHeight = (_itemEdgeSize*lastBlock.size.height)+(_itemSpacingSize*(lastBlock.size.height-1));
    CGFloat yOriginProper = superviewFrame.size.height - (yOrigin + lastHeight + _edgeInsetSize);
    CGFloat properHeight = yOrigin + lastHeight + _edgeInsetSize;

    self.view.frame = CGRectMake(0,yOriginProper+properHeight,superviewFrame.size.width,properHeight);
	self.openFrame = CGRectMake(0,yOriginProper,superviewFrame.size.width,properHeight);
	self.closedFrame = self.view.frame;

    for (NSValue *placement in inputRectangles) {
    	MZEModuleContainerViewController *moduleController = [[MZEModuleContainerViewController alloc] initWithIdentifier:@"com.ioscreatix.test"];
    	moduleController.collectionViewController = self;
    	[self.view addSubview:moduleController.view];
    	[self addChildViewController:moduleController];
    	[moduleController didMoveToParentViewController:self];
    	moduleController.modulePosition = [placement CGRectValue];


    }
}

#pragma mark UIPreviewInteractionDelegateMethods

-(BOOL)previewInteractionShouldBegin:(UIPreviewInteraction *)previewInteraction {
	if (self.view && [self.view superview]) {
	    if ([((MZEModuleContainerViewController *)previewInteraction.delegate).view isDescendantOfView:self.view]) {
	    	_expandingModule = (MZEModuleContainerViewController *)previewInteraction.delegate;
	    	CGRect newFrame = [[self.view superview] convertRect:_expandingModule.view.frame fromView:self.view];
	    	_expandingModule.darkBackground.frame = newFrame;
	    	CGRect superviewFrame = [self.view.superview frame];
	    	_expandingModule.view.frame = CGRectMake(0,0,superviewFrame.size.width,superviewFrame.size.height);
	    	[[self.view superview] addSubview:_expandingModule.view];

	    	self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveEaseOut animations:^{
				self.view.alpha = 0.0f;
			}];
	        return YES;
	    }
	}
    return NO;
}

-(void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction {
	if (self.animator) {

		MZEModuleContainerViewController* __weak __expandingModule = _expandingModule;

		[self.animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
			MZEModuleContainerViewController* __strong expandingModule = __expandingModule;

			expandingModule.view.frame = [expandingModule compactModuleSize];
			expandingModule.darkBackground.frame = CGRectMake(0,0,[expandingModule compactModuleSize].size.width,[expandingModule compactModuleSize].size.height);
			
			[((MZEModuleCollectionViewController *)expandingModule.collectionViewController).view addSubview:expandingModule.view];
			[(MZEModuleCollectionViewController *)expandingModule.collectionViewController addChildViewController:expandingModule];
	    	[expandingModule didMoveToParentViewController:(MZEModuleCollectionViewController *)expandingModule.collectionViewController];
		}];
		[self.animator stopAnimation:NO];
		[self.animator finishAnimationAtPosition:UIViewAnimatingPositionStart];
	}

	// ((MZEModuleContainerViewController *)previewInteraction.delegate).view
	// [self.delegate previewInteractionDidCancel:previewInteraction];
 //    [self.view removeFromSuperview];
 //    [self.delegate.view addSubview:self.darkBackground];
 //    [self.view sendSubviewToBack:self.darkBackground];
}

-(void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdatePreviewTransition:(CGFloat)transitionProgress ended:(BOOL)ended {
	if (self.animator) {
		self.animator.fractionComplete = transitionProgress;
	}
	if (ended) {
		[self.animator stopAnimation:NO];
		[self.animator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
	}
}

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdateCommitTransition:(CGFloat)transitionProgress ended:(BOOL)ended {
	// if (self.animator) {
	// 	self.animator.fractionComplete = transitionProgress;
	// }

	// if (ended) {
	// 	[self.animator stopAnimation:NO];
	// 	[self.animator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
	// }
}


@end