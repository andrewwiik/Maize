#import "MZEAVRoutingViewController.h"
#import "MPAVRoutingTableViewCell+MZE.h"

@implementation MZEAVRoutingViewController

-(UITableViewCell *)tableView:(UITableViewCell *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:NSClassFromString(@"MPAVRoutingTableViewCell")]) {
		MPAVRoutingTableViewCell *routingCell = (MPAVRoutingTableViewCell *)cell;
		routingCell.mze_isMZECell = YES;
		if ([cell valueForKey:@"_iconImageView"]) {
			UIImageView *iconImageView = (UIImageView *)[cell valueForKey:@"_iconImageView"];
			iconImageView.tintColor = [UIColor whiteColor];
		}
	}

	return cell;
}
@end