#import "ViewController.h"
#import "LWCore.h"
#import "LWInterfaceView.h"
#import "LWScrollView.h"
#import "LWPreferences.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	preferences = [LWPreferences new];
	lockwatch = [[LWCore alloc] init];
	[self.view addSubview:lockwatch.interfaceView];
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"watchSize"] isEqualToString:@"compact"]) {
		[watchSizeLabel setText:@"38mm"];
		[watchSizeSwitch setOn:NO];
	} else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"watchSize"] isEqualToString:@"regular"]) {
		[watchSizeLabel setText:@"42mm"];
		[watchSizeSwitch setOn:YES];
	}
	
	[watchSizeSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
	if (lockwatch.isEditing) {
		[lockwatch.interfaceView.scrollView setIsSelecting:YES editing:NO animated:YES didCancel:NO];
	} else if (lockwatch.isSelecting) {
		[lockwatch.interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES didCancel:YES];
	}
}

- (void)switchChanged:(UISwitch*)sender {
	if ([[preferences objectForKey:@"watchSize"] isEqualToString:@"regular"]) {
		[[NSUserDefaults standardUserDefaults] setObject:@"compact" forKey:@"watchSize"];
		[watchSizeLabel setText:@"38mm"];
	} else  {
		[[NSUserDefaults standardUserDefaults] setObject:@"regular" forKey:@"watchSize"];
		[watchSizeLabel setText:@"42mm"];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[lockwatch.interfaceView removeFromSuperview];
	preferences = [LWPreferences new];
	lockwatch = [[LWCore alloc] init];
	[self.view addSubview:lockwatch.interfaceView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
