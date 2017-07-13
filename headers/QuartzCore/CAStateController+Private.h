#import <QuartzCore/CAState+Private.h>

@interface CAStateController : NSObject {
}

@property (readonly) CALayer * layer; 
-(void)_removeTransition:(id)arg1 layer:(CALayer *)arg2 ;
-(void)_applyTransition:(id)arg1 layer:(CALayer *)arg2 undo:(id)arg3 speed:(float)arg4 ;
-(void)_nextStateTimer:(id)arg1 ;
-(void)setInitialStatesOfLayer:(CALayer *)arg1 transitionSpeed:(float)arg2 ;
-(void)_applyTransitionElement:(id)arg1 layer:(CALayer *)arg2 undo:(id)arg3 speed:(float)arg4 ;
-(void)_addAnimation:(id)arg1 forKey:(id)arg2 target:(id)arg3 undo:(id)arg4 ;
-(CAState *)stateOfLayer:(CALayer *)arg1 ;
-(void)setInitialStatesOfLayer:(CALayer *)arg1 ;
-(id)removeAllStateChanges;
-(void)restoreStateChanges:(id)arg1 ;
-(void)cancelTimers;
-(CALayer *)layer;
-(id)initWithLayer:(CALayer *)arg1 ;
-(void)setState:(CAState *)arg1 ofLayer:(CALayer *)arg2 transitionSpeed:(float)arg3 ;
-(void)setState:(CAState *)arg1 ofLayer:(CALayer *)arg2 ;
@end