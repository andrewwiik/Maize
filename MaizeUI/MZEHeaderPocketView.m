#import "MZEHeaderPocketView.h"

@implementation MZEHeaderPocketView
-(id)initWithFrame:(CGRect)arg1 {
  self = [super initWithFrame:arg1];

  self.chevronAlpha = 0.65f;

  self.headerChevronView = [[NSClassFromString(@"SBUIChevronView") alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - [[UIScreen mainScreen] bounds].size.height/48,[[UIScreen mainScreen] bounds].size.height/12,[[UIScreen mainScreen] bounds].size.height/24,[[UIScreen mainScreen] bounds].size.height/24)];
  [self.headerChevronView setColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
  [self addSubview:self.headerChevronView];

  self.headerChevronView.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/24,(self.frame.size.height/2)-7,self.frame.size.width/12, 14);

  return self;
}
-(void)layoutSubviews{
  self.headerChevronView.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/24,(self.frame.size.height/2)-7,self.frame.size.width/12, 14);
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
  }
}
@end
