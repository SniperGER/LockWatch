#import "ViewController.h"
#import "LWCore.h"
#import "LWInterfaceView.h"
#import "LWScrollView.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	lockwatch = [[LWCore alloc] init];
	[self.view addSubview:lockwatch.interfaceView];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
	if (lockwatch.isEditing) {
		[lockwatch.interfaceView.scrollView setIsSelecting:YES editing:NO animated:YES];
	} else if (lockwatch.isSelecting) {
		[lockwatch.interfaceView.scrollView setIsSelecting:NO editing:NO animated:YES];
	}
}

@end
