#import "MZEMaterialView.h"

@interface MZEContentModuleContentContainerView : UIView
{
    BOOL _expanded;
    BOOL _moduleProvidesOwnPlatter;
    BOOL _clipsContentInCompactMode;
    MZEMaterialView *_moduleMaterialView;
    UIView *_psuedoCompactView;
    UIView *_psuedoExpandedView;
    CGRect _compactFrame;
    CGRect _expandedFrame;
}

@property(nonatomic, readwrite) BOOL clipsContentInCompactMode; // @synthesize clipsContentInCompactMode=_clipsContentInCompactMode;
@property(nonatomic, readwrite) BOOL moduleProvidesOwnPlatter; // @synthesize moduleProvidesOwnPlatter=_moduleProvidesOwnPlatter;
- (void)layoutSubviews;
- (void)addSubview:(id)arg1;
@property(readonly, nonatomic) MZEMaterialView *moduleMaterialView; // @synthesize moduleMaterialView=_moduleMaterialView;
- (void)_configureModuleMaterialViewIfNecessary;
- (void)transitionToExpandedMode:(BOOL)arg1;
- (void)_transitionToExpandedMode:(BOOL)arg1 force:(BOOL)arg2;
- (id)initWithFrame:(CGRect)arg1;
- (id)init;


#pragma mark stupid corners

@property (nonatomic, assign) CGRect compactFrame;
@property (nonatomic, assign) CGRect expandedFrame;
@property (nonatomic, retain, readwrite) UIView *psuedoCompactView; 
@property (nonatomic, retain, readwrite) UIView *psuedoExpandedView; 


@end