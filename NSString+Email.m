//
//  NSString+Email.m
//  mps_news
//
//  Created by Jeanette Müller on 13.10.14.
//
//

#import "NSString+Email.h"

@implementation NSString (Email)

- (BOOL)isValidEmail{
    //Quick return if @ Or . not in the string
    if([self rangeOfString:@"@"].location==NSNotFound || [self rangeOfString:@"."].location==NSNotFound){
        return NO;
    }
    if ([self rangeOfString:@".."].location != NSNotFound) {
        return NO;
    }
    
    //Break email address into its components
    
    NSArray *components = [self componentsSeparatedByString:@"@"];
    
    if ([components count] != 2) {
        return NO;
    }
    NSString *accountName = [components objectAtIndex:0];
    NSString *accountDomain = [components objectAtIndex:1];

    //’.’ not present in substring
    if([accountDomain rangeOfString:@"."].location==NSNotFound){

        return NO;
    }
    NSString *domainName = [accountDomain substringToIndex:[accountDomain rangeOfString:@"."].location];
    NSString *subDomain = [accountDomain substringFromIndex:[accountDomain rangeOfString:@"."].location+1];
    
    //username, domainname and subdomain name should not contain the following charters below
    //filter for user name
    NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;’:\"<>,?/`";
    //filter for domain
    NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;’:\"<>,+?/`";
    //filter for subdomain
    NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:\";’<>,?/1234567890";
    
    //subdomain should not be less that 2 and not greater 6
    if(!(subDomain.length>=2 && subDomain.length<=6)){
        return NO;
    }
    
    if([accountName isEqualToString:@""] ||
		[accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound ||
		[domainName isEqualToString:@""] ||
		[domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound ||
		[subDomain isEqualToString:@""] ||
		[subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound){

		return NO;
    }

    return YES;
}

@end
