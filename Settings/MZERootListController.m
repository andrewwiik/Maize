#import "MZERootListController.h"
#import "constants.h"
#import <MaizeServices/MZEModuleMetadata.h>
#import "MZESettingsModuleTableViewCell.h"
#include <notify.h>
#import "macros.h"

@implementation MZERootListController


- (id)init {
	self = [super init];
	if (self) {
		_moduleRepository = [MZEModuleRepository repositoryWithDefaults];
		[_moduleRepository loadSettings];
		[_moduleRepository updateAllModuleMetadata];
	}
	return self;

}
- (id)initForContentSize:(CGSize)size
{
	self = [self init];
	return self;
}

- (id)readPreferenceValue:(id)arg1 {
	return nil;
}
- (id)rootController {
	return nil;
}
- (void)setParentController:(id)arg1 {
	return;
}
- (void)setPreferenceValue:(id)arg1 specifier:(id)arg2 {
	return;
}
- (void)setRootController:(id)arg1 {
	return;
}
- (void)setSpecifier:(id)arg1 {
	return;
}
- (void)showController:(id)arg1 {
	return;
}
- (void)showController:(id)arg1 animate:(bool)arg2 {
	return;
}
- (id)specifier {
	return nil;
}

- (void)handleURL:(id)arg1 {
	return;
}
- (id)parentController {
	return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_moduleRepository loadSettings];
    //[(UITableView *)self.view setEditing:YES animated:NO];
   [self.tableView registerClass:[MZESettingsModuleTableViewCell class] forCellReuseIdentifier:@"Cell"];
   //  CCUIControlCenterVisualEffect *effect = [NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect];
   // _UIVisualEffectConfig *effectConfig = [effect effectConfig];
   	//self.primaryEffectConfig = effectConfig.contentConfig;
    
   // self.view.backgroundColor = nil;

	self.settingsFilePath = [MZEModuleRepository settingsFilePath];
	self.preferencesIdentifier = [MZEModuleRepository settingsIdentifier];
	self.notificationName = [MZEModuleRepository settingsChangedNotificationName];
	self.enabledKey = [MZEModuleRepository enabledKey];
	self.disabledKey = [MZEModuleRepository disabledKey];

	NSDictionary *settings = nil;

	if (self.settingsFilePath) {
		if (self.preferencesIdentifier) {
			CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesIdentifier);
			CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)self.preferencesIdentifier, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
			if (keyList) {
				settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)self.preferencesIdentifier, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
			}
		} else {
			settings = [NSDictionary dictionaryWithContentsOfFile:self.settingsFilePath];
		}
	}
	NSArray *originalEnabled = [_moduleRepository enabledIdentifiers];
	NSArray *originalDisabled = [_moduleRepository disabledIdentifiers];

	if (!originalEnabled) {
		// NSMutableArray *originalEnabledDefaults = [NSMutableArray new];
		// originalEnabledDefaults = [[_moduleRepository class] defaultEnabledIdentifiers];
		// //originalEnabled = [originalEnabledDefaults copy];
		// //self.enabledIdentifiers = originalEnabledDefaults;
		originalEnabled = [[_moduleRepository class] defaultEnabledIdentifiers];
	}else {
		// self.enabledIdentifiers = [originalEnabled mutableCopy];
	}


	if (!self.disabledIdentifiers) {
		self.disabledIdentifiers = [NSMutableArray new];
	}
	if (!self.enabledIdentifiers) {
		self.enabledIdentifiers = [NSMutableArray new];
	}

	self.allIdentifiers = [_moduleRepository allIdentifiers];
	NSMutableArray *allIdentifiers = [self.allIdentifiers mutableCopy];
	for  (NSString *identifier in originalEnabled) {
		if ([allIdentifiers containsObject:identifier]) {
			[allIdentifiers removeObject:identifier];
			[self.disabledIdentifiers removeObject:identifier];
			[self.enabledIdentifiers addObject:identifier];
		} else {
			[self.enabledIdentifiers removeObject:identifier];
		}
	}
	for (NSString *identifier in originalDisabled) {
		if ([allIdentifiers containsObject:identifier]) {
			[allIdentifiers removeObject:identifier];
			[self.disabledIdentifiers addObject:identifier];
		} else {
			[self.disabledIdentifiers removeObject:identifier];
		}
	}

	NSMutableArray *arrayToAddNewIdentifiers = self.disabledIdentifiers;
	for (NSString *identifier in allIdentifiers) {
		[arrayToAddNewIdentifiers addObject:identifier];
	}

	[self.tableView setEditing:YES animated:NO];
	// CGFloat dummyViewHeight = 36;
	// UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
	// self.tableView.tableHeaderView = dummyView;
	// self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
	[self.tableView setSeparatorColor:[UIColor colorWithWhite:0 alpha:0.15]];
	self.tableView.allowsSelectionDuringEditing = YES;
	//[self.tableView setContentInset:UIEdgeInsetsMake(36,0,0,0)];
	// CGRect originalFrame = self.tableView.frame;
	// originalFrame.origin.y = 36;
	// originalFrame.size.height = originalFrame.size.height - 36;
	// self.tableView.frame = originalFrame;
	// [self _layoutHeaderView];
	// self.headerView.frame = CGRectMake(0,0,[self.view superview].frame.size.width, 36);
	// self.tableView.tableHeaderView = self.headerView;
	// self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
	//self.tabl
}

// %new
// - (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     return NO;
// }


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self arrayForSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    MZESettingsModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MZESettingsModuleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    //CCXSectionsPanel *panel = (CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance];
    NSString *sectionIdentifier = [[self arrayForSection:indexPath.section] objectAtIndex:indexPath.row];
    MZEModuleMetadata *data = [_moduleRepository metadataForIdentifier:sectionIdentifier];

    cell.textLabel.text = data.displayName;
	cell.imageView.image = data.settingsIconGlyph;
	cell.iconColor = data.settingsIconBackgroundColor;
	// cell.imageView.tintColor = [UIColor whiteColor];
	// cell.imageView.backgroundColor = data.settingsIconBackgroundColor;
	// cell.imageView.layer.cornerRadius = 29.0*0.2237;

	//cell.controllerClass = data.controllerClass;
	//((CCXSettingsTableViewCell *)cell).iconColor = data.settingsIconBackgroundColor;

    // if (data.settingsControllerClass) {
    // 	cell.settingsControllerClass = data.settingsControllerClass;
    // 	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // }
    return cell;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    //     [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    // }

    // if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    //     [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    // }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 28;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (!_bundle) {
		_bundle = [NSBundle bundleForClass:[self class]];
	}

	if (section == 0) {
		return [_bundle localizedStringForKey:@"ENABLED_MODULES_SECTION_TITLE" value:@"" table:@"ControlCenterSettings"]; // ENABLED_MODULES_SECTION_TITLE
	} else if (section == 1) {
		return [_bundle localizedStringForKey:@"DISABLED_MODULES_SECTION_TITLE" value:@"" table:@"ControlCenterSettings"]; // DISABLED_MODULES_SECTION_TITLE
	} else return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
 //    CCXPunchOutView *view = [[NSClassFromString(@"CCXPunchOutView") alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
 //    /* Create custom view to display section header... */
 //    view.cornerRadius = 13;
 //    view.roundCorners = 0;
 //    view.style = 0;
 //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
 //    [label setFont:[[self class] sectionHeaderFont]];
 //    NSString *text;
 //    // if (section == 0)
 //    // 	text = @"Toggles (Enabled)";
 //    // else if (section == 1)
 //    // 	text = @"Toggles (Disabled)";
 //     if (section == 0)
 //    	text = @"Sections (Enabled)";
 //    else if (section == 1)
 //    	text = @"Sections (Disabled)";
 //    /* Section header is in 0th index... */
 //    [label setText:text];
 //    [view addSubview:label];

 //    // [self.primaryEffectConfig configureLayerView:label];
 //    label.textColor = [UIColor whiteColor];
 //    label.backgroundColor = [UIColor clearColor];
 //   // [[NSClassFromString(@"CUIControlCenterVisualEffect")  effectWithControlState:0 inContext:6].effectConfig.contentConfig configureLayerView:label.layer];
 //    // CUIControlCenterVisualEffect

 //    label.translatesAutoresizingMaskIntoConstraints = NO;
	// [view addConstraint:[NSLayoutConstraint constraintWithItem:label
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:view
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             multiplier:1
	// 	                                               constant:0]];
	// [view addConstraint:[NSLayoutConstraint constraintWithItem:label
	// 	                                             attribute:NSLayoutAttributeLeft
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:view
	// 	                                             attribute:NSLayoutAttributeLeft
	// 	                                             multiplier:1
	// 	                                               constant:15]];
	// [view addConstraint:[NSLayoutConstraint constraintWithItem:label
	// 	                                             attribute:NSLayoutAttributeRight
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:view
	// 	                                             attribute:NSLayoutAttributeRight
	// 	                                             multiplier:1
	// 	                                               constant:0]];
	// [view addConstraint:[NSLayoutConstraint constraintWithItem:label
	// 	                                             attribute:NSLayoutAttributeHeight
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:view
	// 	                                             attribute:NSLayoutAttributeHeight
	// 	                                             multiplier:1
	// 	                                               constant:0]];
		
 //    [view setBackgroundColor:nil];
 //    return view;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// if ([CCXSharedResources sharedInstance].settingsNavigationController) {
	// 	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	// 	CCXSettingsTableViewCell *cell = (CCXSettingsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	// 	if ([cell.controllerClass respondsToSelector:@selector(configuredSettingsController)] && cell.settingsControllerClass) {
	// 		if ([cell.controllerClass configuredSettingsController])
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setHeaderText:cell.textLabel.text];
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setIconImage:cell.imageView.image];
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setIconColor:cell.iconColor];
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setShowingBackButton:YES];
	// 		[[CCXSharedResources sharedInstance].settingsNavigationController pushViewController:(UIViewController *)[cell.controllerClass configuredSettingsController] animated:YES];
	// 	} else if (cell.settingsControllerClass) {
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setHeaderText:cell.textLabel.text];
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setIconImage:cell.imageView.image];
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setIconColor:cell.iconColor];
	// 		[((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar setShowingBackButton:YES];
	// 		[[CCXSharedResources sharedInstance].settingsNavigationController pushViewController:[[cell.settingsControllerClass alloc] init] animated:YES];
	// 	}
	// } else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath  {
	// if (indexPath.section == 0)
	// 	return UITableViewCellEditingStyleDelete;
	// else 
	// 	return UITableViewCellEditingStyleInsert;
	return UITableViewCellEditingStyleNone;
}

 - (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
 	return NO;
 }

 - (BOOL) tableView: (UITableView *) tableView canMoveRowAtIndexPath: (NSIndexPath *) indexPath {
 	return YES;
 }

 - (void)tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) fromIndexPath toIndexPath: (NSIndexPath *) toIndexPath {
	
	//[(UIPanGestureRecognizer *)[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:NO];
	
	NSMutableArray *fromArray = fromIndexPath.section ? self.disabledIdentifiers : self.enabledIdentifiers;
	NSMutableArray *toArray = toIndexPath.section ? self.disabledIdentifiers : self.enabledIdentifiers;
	NSString *identifier = [fromArray objectAtIndex:fromIndexPath.row];
	[fromArray removeObjectAtIndex:fromIndexPath.row];
	[toArray insertObject:identifier atIndex:toIndexPath.row];
	[self _flushSettings];
	//[(UIPanGestureRecognizer *)[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:YES];
	//[(UIPanGestureRecognizer *)[[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:YES];
 	return;
}


 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }    
}

- (NSArray *)arrayForSection:(NSInteger)section {
	return section ? self.disabledIdentifiers : self.enabledIdentifiers;
}

- (void)_flushSettings {

	_moduleRepository.enabledIdentifiers = self.enabledIdentifiers;
	_moduleRepository.disabledIdentifiers = self.disabledIdentifiers;
	[_moduleRepository _saveSettings];
	// if (self.preferencesIdentifier && (self.enabledKey || self.disabledKey)) {
	// 	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	// 	if (self.enabledKey) {
	// 		[dict setObject:self.enabledIdentifiers forKey:self.enabledKey];
	// 	}
	// 	if (self.disabledKey) {
	// 		[dict setObject:self.disabledIdentifiers forKey:self.disabledKey];
	// 	}
	// 	CFPreferencesSetMultiple((CFDictionaryRef)dict, NULL, (__bridge CFStringRef)self.preferencesIdentifier, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	// 	CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesIdentifier);
	// }
	// if (self.settingsFilePath) {
	// 	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:self.settingsFilePath] ?: [NSMutableDictionary dictionary];
	// 	if (self.enabledKey) {
	// 		[dict setObject:self.enabledIdentifiers forKey:self.enabledKey];
	// 	}
	// 	if (self.disabledKey) {
	// 		[dict setObject:self.disabledIdentifiers forKey:self.disabledKey];
	// 	}
	// 	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
	// 	[data writeToFile:self.settingsFilePath atomically:YES];
	// }
	if (self.notificationName) {
		notify_post([self.notificationName UTF8String]);
		CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (__bridge CFStringRef)self.notificationName, nil, nil, true);
	}

	//CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), self.notificationName, nil, nil, true);

	//[_moduleRepository loadSettings];
}
@end
