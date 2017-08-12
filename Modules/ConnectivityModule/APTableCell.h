#import <AirPortSettings/APTableCell.h>
#import <MaizeUI/MZEMaterialView.h>

@interface APTableCell (MZE)
@property (nonatomic, assign) BOOL mze_isMZECell;
@property (nonatomic, retain) MZEMaterialView *vibrantSeparator;
@end