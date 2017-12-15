#import "ViewController.h"
#import "LWCore.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	LWCore* lockwatch = [[LWCore alloc] init];
	[self.view addSubview:lockwatch.interfaceView];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
