#include "LWPRootListController.h"

@implementation LWPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	
	return _specifiers;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (void)killSpringBoard {
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@""
																			 message:@"Restarting SpringBoard will apply all changed settings."
																	  preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
														   style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Restart SpringBoard"
															style:UIAlertActionStyleDestructive
														  handler:^(UIAlertAction* action) {
															  system("killall SpringBoard");
														  }];
	
	[alertController addAction:cancelAction];
	[alertController addAction:confirmAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

#pragma GCC diagnostic pop

@end
