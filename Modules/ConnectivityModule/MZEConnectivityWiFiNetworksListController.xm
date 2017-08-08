#import "MZEConnectivityWiFiNetworksListController.h"
#import <AirPortSettings/APTableCell.h>
#import <objc/runtime.h>


// #ifndef __GNUC__
// #define __asm__ asm
// #endif


// __asm__(".weak_reference _OBJC_CLASS_$_APNetworksController");
// __asm__(".weak_reference _OBJC_METACLASS_$_APNetworksController");

%subclass MZEConnectivityWiFiNetworksListController : APNetworksController

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
		[(APTableCell *)cell setHidesInfoButton:YES];
		[(APTableCell *)cell setAccessoryType: UITableViewCellAccessoryNone];
		[(APTableCell *)cell setDetailText:nil];
	} else {
		cell.hidden = YES;
		cell.alpha = 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 && indexPath.section == 0) return 0.0;
	// if (indexP.)
	return %orig;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0;
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
		[(APTableCell *)cell setHidesInfoButton:YES];
		[(APTableCell *)cell setAccessoryType: UITableViewCellAccessoryNone];
		[(APTableCell *)cell setDetailText:nil];
	} else {
		cell.hidden = YES;
		cell.alpha = 0;
	}
	return cell;
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