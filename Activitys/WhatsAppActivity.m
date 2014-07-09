//
//  WhatsAppActivity.m
//  Podcat
//
//  Created by Jeanette Müller on 09.07.14.
//  Copyright (c) 2014 Jeanette Müller. All rights reserved.
//

#import "WhatsAppActivity.h"

#define kWhatsAppURLSchema @"whatsapp://send"

@implementation WhatsAppActivity{
    NSURL *_url;
    NSString *_text;
}

- (NSString *)activityType{
    return @"de.themaverick.actifity.browserSharing";
}
- (NSString *)activityTitle{
    return @"WhatsApp";
}
- (UIImage *)activityImage{
    return [UIImage imageNamed:@"whatsapp"];
}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kWhatsAppURLSchema]];
}
- (void)prepareWithActivityItems:(NSArray *)activityItems{
    
    for(id item in activityItems)
    {
        if ([item isKindOfClass:[NSURL class]]){
            _url = item;
        }else if ([item isKindOfClass:[NSString class]]){
            _text = item;
        }
    }
}
- (void)performActivity{
    
    NSString *string = [NSString stringWithFormat:@"%@?", kWhatsAppURLSchema];
    
    if (_text) {
        string = [string stringByAppendingFormat:@"&text=%@", [_text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if (_url) {
        string = [string stringByAppendingFormat:@"%%20-%%20%@", [_url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}
@end
