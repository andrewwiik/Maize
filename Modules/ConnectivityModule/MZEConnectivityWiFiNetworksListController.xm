#import "MZEConnectivityWiFiNetworksListController.h"
#import "APTableCell.h"
#import <objc/runtime.h>
#import <MaizeUI/MZELayoutOptions.h>


// #ifndef __GNUC__
// #define __asm__ asm
// #endif


// __asm__(".weak_reference _OBJC_CLASS_$_APNetworksController");
// __asm__(".weak_reference _OBJC_METACLASS_$_APNetworksController");

static CGFloat cellHeight = 0;

%subclass MZEConnectivityWiFiNetworksListController : APNetworksController
%new
+ (id)sharedInstance {
	static MZEConnectivityWiFiNetworksListController *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NSClassFromString(@"MZEConnectivityWiFiNetworksListController") alloc] init];
    });
    return _sharedInstance;
}

// + (id)alloc {
// 	static MZEConnectivityWiFiNetworksListController *_sharedInstance;
//     static dispatch_once_t onceToken;
//     dispatch_once(&onceToken, ^{
//         _sharedInstance = [[NSClassFromString(@"MZEConnectivityWiFiNetworksListController") alloc] init];
//     });
//     return _sharedInstance;
// }


- (Class)class {
	return NSClassFromString(@"APNetworksController");
}
// + (void) initialize {
// 	#pragma clang diagnostic push
// 	#pragma clang diagnostic ignored "-Wdeprecated"

// 	NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle"];
// 	NSBundle *bundle;
// 	bundle = [NSBundle bundleWithPath:fullPath];
// 	BOOL didLoad = [bundle load];

// 	if (didLoad) {
// 		Class activityClass = objc_getClass("APNetworksController");
// 	    if (activityClass) {
// 	        class_setSuperclass([MZEConnectivityWiFiNetworksListController class], activityClass);
// 	    }
// 	}
//     NSLog(@"%@", [[MZEConnectivityWiFiNetworksListController class] superclass]);
//     #pragma clang diagnostic pop
// }


- (id)init {
	self = %orig;
	if (self) {

	}
	return self;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	%orig;
	if ([cell isKindOfClass:NSClassFromString(@"APTableCell")]) {
		[(APTableCell *)cell setNoAccessory:YES];
		//[(APTableCell *)cell setHidesInfoButton:YES];
		[(APTableCell *)cell setAccessoryType: UITableViewCellAccessoryNone];
		//[(APTableCell *)cell setDetailText:nil];
		cell.backgroundColor = [UIColor clearColor];
		((APTableCell *)cell).mze_isMZECell = YES;
		 cell.hidden = NO;
		 cell.alpha = 1.0;
	} else {
		cell.hidden = YES;
		cell.alpha = 0;
		cell.frame = CGRectZero;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 && indexPath.section == 0) return 0.0;
	// if (indexP.)
	if (cellHeight == 0) {
		cellHeight = [MZELayoutOptions defaultMenuItemHeight];
	}
	return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	%orig;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = %orig;
	if ([cell isKindOfClass:NSClassFromString(@"APTableCell")]) {
		[(APTableCell *)cell setNoAccessory:YES];
		// [(APTableCell *)cell setHidesInfoButton:YES];
		[(APTableCell *)cell setAccessoryType: UITableViewCellAccessoryNone];
		cell.backgroundColor = [UIColor clearColor];
		((APTableCell *)cell).mze_isMZECell = YES;
		cell.alpha = 1.0;
		cell.hidden = NO;
		//[(APTableCell *)cell setDetailText:nil];
	} else {
		cell.hidden = YES;
		cell.alpha = 0;
		cell.frame = CGRectZero;
	}
	return cell;
}

- (void)viewWillLayoutSubviews {
	%orig;
	self.view.backgroundColor = [UIColor clearColor];
	if ([self valueForKey:@"_table"]) {
		[(UITableView *)[self valueForKey:@"_table"] setBackgroundColor:[UIColor clearColor]];
		[(UITableView *)[self valueForKey:@"_table"] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		((UITableView *)[self valueForKey:@"_table"]).sectionHeaderHeight = 0.0;
		((UITableView *)[self valueForKey:@"_table"]).sectionFooterHeight = 0.0;
	}
}
%end

%ctor {
	BOOL shouldInit = NO;
	if (!NSClassFromString(@"APTableCell")) {
		NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle"];
		NSBundle *bundle;
		bundle = [NSBundle bundleWithPath:fullPath];
		BOOL didLoad = [bundle load];
		if (didLoad) {
			shouldInit = YES;
		}
	} else {
		shouldInit = YES;
	}

	if (shouldInit) {
		%init;
	}
}