#import "WatchColors.h"

@implementation WatchColors

+ (NSDictionary*)colors {
	return @{
			 @"white": [WatchColors whiteColor],
			 @"gray": [WatchColors grayColor],
			 @"red": [WatchColors redColor],
			 @"orange": [WatchColors orangeColor],
			 @"apricot": [WatchColors apricotColor],
			 @"lightOrange": [WatchColors lightOrangeColor],
			 @"yellow": [WatchColors yellowColor],
			 @"pollen": [WatchColors pollenColor],
			 @"flash": [WatchColors flashColor],
			 @"green": [WatchColors greenColor],
			 @"mint": [WatchColors mintColor],
			 @"turquoise": [WatchColors turquoiseColor],
			 @"lightBlue": [WatchColors lightBlueColor],
			 @"blue": [WatchColors blueColor],
			 @"royalBlue": [WatchColors royalBlueColor],
			 @"lilac": [WatchColors lilacColor],
			 @"mistBlue": [WatchColors mistBlueColor],
			 @"azure": [WatchColors azureColor],
			 @"blueCobalt": [WatchColors blueCobaltColor],
			 @"darkTeal": [WatchColors darkTealColor],
			 @"midnightBlue": [WatchColors midnightBlueColor],
			 @"oceanBlue": [WatchColors oceanBlueColor],
			 @"purple": [WatchColors purpleColor],
			 @"ultraViolet": [WatchColors ultraVioletColor],
			 @"lavender": [WatchColors lavenderColor],
			 @"pinkSand": [WatchColors pinkSandColor],
			 @"lightPink": [WatchColors lightPinkColor],
			 @"vintageRose": [WatchColors vintageRoseColor],
			 @"pink": [WatchColors pinkColor],
			 @"electricPink": [WatchColors electricPinkColor],
			 @"roseRed": [WatchColors roseRedColor],
			 @"camellia": [WatchColors camelliaColor],
			 @"flamingo": [WatchColors flamingoColor],
			 @"walnut": [WatchColors walnutColor],
			 @"stone": [WatchColors stoneColor],
			 @"antiqueWhite": [WatchColors antiqueWhiteColor],
			 @"softWhite": [WatchColors softWhiteColor],
			 @"pebble": [WatchColors pebbleColor],
			 @"cocoa": [WatchColors cocoaColor],
			 @"darkOlive": [WatchColors darkOliveColor]
			 };
}

+ (NSArray*)colorNames {
	return @[
			 @"white",
			 @"gray",
			 @"red",
			 @"orange",
			 @"apricot",
			 @"lightOrange",
			 @"yellow",
			 @"pollen",
			 @"flash",
			 @"green",
			 @"mint",
			 @"turquoise",
			 @"lightBlue",
			 @"blue",
			 @"royalBlue",
			 @"lilac",
			 @"mistBlue",
			 @"azure",
			 @"blueCobalt",
			 @"darkTeal",
			 @"midnightBlue",
			 @"oceanBlue",
			 @"purple",
			 @"ultraViolet",
			 @"lavender",
			 @"pinkSand",
			 @"lightPink",
			 @"vintageRose",
			 @"pink",
			 @"electricPink",
			 @"roseRed",
			 @"camellia",
			 @"flamingo",
			 @"walnut",
			 @"stone",
			 @"antiqueWhite",
			 @"softWhite",
			 @"pebble",
			 @"cocoa",
			 @"darkOlive"
			 ];
}

+ (UIColor*)whiteColor {
	return [UIColor colorWithRed:0.9 green:0.91 blue:0.91 alpha:1.0];
}

+ (UIColor*)grayColor {
	return [UIColor colorWithRed:0.61 green:0.63 blue:0.67 alpha:1.0];
}

+ (UIColor*)redColor {
	return [UIColor colorWithRed:0.88 green:0.04 blue:0.14 alpha:1.0];
}

+ (UIColor*)orangeColor {
	return [UIColor colorWithRed:1 green:0.32 blue:0.19 alpha:1.0];
}

+ (UIColor*)apricotColor {
	return [UIColor colorWithRed:0.99 green:0.45 blue:0.31 alpha:1.0];
}

+ (UIColor*)lightOrangeColor {
	return [UIColor colorWithRed:1 green:0.58 blue:0 alpha:1.0];
}

+ (UIColor*)yellowColor {
	return [UIColor colorWithRed:0.91 green:0.8 blue:0.05 alpha:1.0];
}

+ (UIColor*)pollenColor {
	return [UIColor colorWithRed:1 green:0.82 blue:0.36 alpha:1.0];
}

+ (UIColor*)flashColor {
	return [UIColor colorWithRed:0.88 green:0.95 blue:0.14 alpha:1.0];
}

+ (UIColor*)greenColor {
	return [UIColor colorWithRed:0.55 green:0.89 blue:0.16 alpha:1.0];
}

+ (UIColor*)mintColor {
	return [UIColor colorWithRed:0.68 green:0.93 blue:0.62 alpha:1.0];
}

+ (UIColor*)turquoiseColor {
	return [UIColor colorWithRed:0.62 green:0.84 blue:0.8 alpha:1.0];
}

+ (UIColor*)lightBlueColor {
	return [UIColor colorWithRed:0.42 green:0.77 blue:0.87 alpha:1.0];
}

+ (UIColor*)blueColor {
	return [UIColor colorWithRed:0.1 green:0.71 blue:0.99 alpha:1.0];
}

+ (UIColor*)royalBlueColor {
	return [UIColor colorWithRed:0.39 green:0.68 blue:0.93 alpha:1.0];
}

+ (UIColor*)lilacColor {
	return [UIColor colorWithRed:0.76 green:0.85 blue:0.99 alpha:1.0];
}

+ (UIColor*)mistBlueColor {
	return [UIColor colorWithRed:0.7 green:0.72 blue:0.65 alpha:1.0];
}

+ (UIColor*)azureColor {
	return [UIColor colorWithRed:0.53 green:0.6 blue:0.63 alpha:1.0];
}

+ (UIColor*)blueCobaltColor {
	return [UIColor colorWithRed:0.28 green:0.49 blue:0.62 alpha:1.0];
}

+ (UIColor*)darkTealColor {
	return [UIColor colorWithRed:0.21 green:0.45 blue:0.58 alpha:1.0];
}

+ (UIColor*)midnightBlueColor {
	return [UIColor colorWithRed:0.38 green:0.52 blue:0.75 alpha:1.0];
}

+ (UIColor*)oceanBlueColor {
	return [UIColor colorWithRed:0.45 green:0.53 blue:0.78 alpha:1.0];
}

+ (UIColor*)purpleColor {
	return [UIColor colorWithRed:0.6 green:0.49 blue:0.97 alpha:1.0];
}

+ (UIColor*)ultraVioletColor {
	return [UIColor colorWithRed:0.44 green:0.34 blue:0.75 alpha:1.0];
}

+ (UIColor*)lavenderColor {
	return [UIColor colorWithRed:0.7 green:0.6 blue:0.65 alpha:1.0];
}

+ (UIColor*)pinkSandColor {
	return [UIColor colorWithRed:0.96 green:0.76 blue:0.74 alpha:1.0];
}

+ (UIColor*)lightPinkColor {
	return [UIColor colorWithRed:0.96 green:0.69 blue:0.67 alpha:1.0];
}

+ (UIColor*)vintageRoseColor {
	return [UIColor colorWithRed:0.96 green:0.67 blue:0.65 alpha:1.0];
}

+ (UIColor*)pinkColor {
	return [UIColor colorWithRed:1 green:0.35 blue:0.39 alpha:1.0];
}

+ (UIColor*)electricPinkColor {
	return [UIColor colorWithRed:1.0 green:0.31 blue:0.32 alpha:1.0];
}

+ (UIColor*)roseRedColor {
	return [UIColor colorWithRed:0.73 green:0.16 blue:0.27 alpha:1];
}

+ (UIColor*)camelliaColor {
	return [UIColor colorWithRed:0.79 green:0.27 blue:0.27 alpha:1.0];
}

+ (UIColor*)flamingoColor {
	return [UIColor colorWithRed:0.83 green:0.51 blue:0.42 alpha:1.0];
}

+ (UIColor*)walnutColor {
	return [UIColor colorWithRed:0.69 green:0.53 blue:0.39 alpha:1.0];
}

+ (UIColor*)stoneColor {
	return [UIColor colorWithRed:0.69 green:0.6 blue:0.5 alpha:1.0];
}

+ (UIColor*)antiqueWhiteColor {
	return [UIColor colorWithRed:0.83 green:0.71 blue:0.58 alpha:1.0];
}

+ (UIColor*)softWhiteColor {
	return [UIColor colorWithRed:0.87 green:0.82 blue:0.73 alpha:1.0];
}

+ (UIColor*)pebbleColor {
	return [UIColor colorWithRed:0.68 green:0.62 blue:0.56 alpha:1.0];
}

+ (UIColor*)cocoaColor {
	return [UIColor colorWithRed:0.61 green:0.56 blue:0.55 alpha:1.0];
}

+ (UIColor*)darkOliveColor {
	return [UIColor colorWithRed:0.55 green:0.55 blue:0.46 alpha:1.0];
}

@end
