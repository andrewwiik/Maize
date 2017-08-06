#import "MZEHeaderPocketView.h"

@implementation MZEHeaderPocketView
-(id)initWithFrame:(CGRect)arg1 {
  self = [super initWithFrame:arg1];

  self.chevronAlpha = 0.65f;

  self.headerChevronView = [[NSClassFromString(@"SBUIChevronView") alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - [[UIScreen mainScreen] bounds].size.height/48,[[UIScreen mainScreen] bounds].size.height/12,[[UIScreen mainScreen] bounds].size.height/24,[[UIScreen mainScreen] bounds].size.height/24)];
  [self.headerChevronView setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
  [self addSubview:self.headerChevronView];

  self.headerChevronView.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/24,(self.frame.size.height/2)-7,self.frame.size.width/12, 14);

  self.headerDivider = [[UIView alloc] init];
  self.headerDivider.frame = CGRectMake(0,arg1.size.height-0.5, arg1.size.width, 0.5);
  self.headerDivider.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.08];
  self.headerDivider.alpha = 0;
  [self addSubview:self.headerDivider];

  self.headerBackgroundView = [[MZEPocketMaterialView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height - 0.5)];
  self.headerBackgroundView.alpha = 0;
  [self addSubview:self.headerBackgroundView];

  self.showingBackground = FALSE;
  [self toggleDividerVisibility];
  return self;
}
-(void)layoutSubviews{
  self.headerChevronView.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/20,(self.frame.size.height/2)-7,self.frame.size.width/10, 14);
  self.headerDivider.frame = CGRectMake(0,self.frame.size.height-0.5, self.frame.size.width, 0.5);
  self.headerBackgroundView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height - 0.5);
}
-(void)animateProgress:(CGFloat)arg1 {
  if(arg1 >= 0.8){
    if(!self.chevronPointingDown){
      self.chevronPointingDown = TRUE;
      [self.headerChevronView setState:1 animated:TRUE];
    }
  } else {
    [self.headerChevronView setState:0 animated:TRUE];
    self.chevronPointingDown = FALSE;
    if(self.showingBackground){
      [self toggleDividerVisibility];
    }
  }
}
-(void)toggleDividerVisibility {
  if(self.showingBackground){
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.headerDivider.alpha = 0;
      self.headerBackgroundView.alpha = 0;
    } completion:nil];
    self.showingBackground = FALSE;
  } else {
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
      self.headerDivider.alpha = 1;
      self.headerBackgroundView.alpha = 1;
    } completion:nil];
    self.showingBackground = TRUE;
  }
}
@end
