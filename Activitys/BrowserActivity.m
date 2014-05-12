//
//  BrowserActivity.m
//  mps_news
//
//  Created by Jeanette Müller on 29.04.14.
//
//

#import "BrowserActivity.h"

@implementation BrowserActivity{
    NSURL *_url;
}

- (NSString *)activityType{
    return @"de.motorpresse.actifity.browserSharing";
}
- (NSString *)activityTitle{
    return @"Adresse im Safari öffnen";
}
- (UIImage *)activityImage{
    return [UIImage imageNamed:@"safari"];
}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    return YES;
}
- (void)prepareWithActivityItems:(NSArray *)activityItems{
    
    for(id item in activityItems)
    {
        if ([item isKindOfClass:[NSURL class]])
        {
            _url = item;
        }
    }
}
- (void)performActivity{
    
    [[UIApplication sharedApplication] openURL:_url];
}


@end
