@interface BSUIAnimationFactory : NSObject
+(id)factoryWithSettings:(id)arg1 ;
+ (void)animateWithFactory:(id)arg1 actions:(id /* block */)arg2;
+ (void)animateWithFactory:(id)arg1 actions:(id /* block */)arg2 completion:(id /* block */)arg3;
@end