//
//  JxInAppStoreManager.h
//  autokauf
//
//  Created by Jeanette Müller on 30.04.14.
//  Copyright (c) 2014 Motorpresse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerTransactionCancelledNotification @"kInAppPurchaseManagerTransactionCancelledNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerCanProvideContent @"kInAppPurchaseManagerCanProvideContent"
#define kInAppPurchaseManagerTransactionInProgressNotification @"kInAppPurchaseManagerTransactionInProgressNotification"
#define kInAppPurchaseManagerTransactionInitiatedNotification @"kInAppPurchaseManagerTransactionInitiatedNotification"



@interface JxInAppStoreManager : NSObject <SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    
    
@private
	NSMutableArray* alreadyPurchasedProductIds;
	NSArray* productIds;
    SKProductsRequest *productsRequest;
	NSTimer* progressTimer;
    
	BOOL restoreCompleted;
	int restoreAttempts;
    
}
@property (strong, nonatomic) NSMutableDictionary* products;
@property (strong, nonatomic) NSMutableDictionary* progress;


+ (void)setNeedsRestore:(BOOL)needs;
+ (BOOL)needsRestore;
+ (BOOL)canMakePurchases;

// public methods
- (id)initWithIds:(NSArray*)pids;
- (BOOL)canPurchase:(NSString*)productIdentifier;

- (void)purchase:(NSString *)productIdentifier;
- (void)purchaseCleanup:(NSString *)productIdentifier;

- (void)restore;
- (BOOL)hasAlreadyPurchased:(NSSet*)productIdentifiers;
- (void)clearAlreadyPurchased;

- (float)getProgress:(SKProduct *)product;



@end
