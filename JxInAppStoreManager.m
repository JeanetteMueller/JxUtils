//
//  JxInAppStoreManager.m
//  autokauf
//
//  Created by Jeanette Müller on 30.04.14.
//  Copyright (c) 2014 Motorpresse. All rights reserved.
//

#import "JxInAppStoreManager.h"
#import "SKProduct+LocalizedPrice.h"
#import "NSString+NSStringAdditions.h"
#import "SFHFKeychainUtils.h"
#import "NSNotificationAdditions.h"

#import "Logging.h"

static BOOL needsRestore;

static NSString* const KEYCHAIN_PRODUCT_ID_USER = @"productId";
static NSString* const KEYCHAIN_SERVICE_NAME = @"MY_STORE_NAME";


@implementation JxInAppStoreManager



#pragma -
#pragma Public methods


-(id) initWithIds:(NSArray*)pids{
	if (self = [super init]){
        
		productIds = pids;
        
        _products = [NSMutableDictionary dictionary];
        
        
		progressTimer = nil;
        
		restoreCompleted = NO;
		restoreAttempts = 0;
        
		self.progress = [NSMutableDictionary dictionary];
        
		[self loadStore];
        
		NSError* error;
		NSString* pass = [SFHFKeychainUtils getPasswordForUsername:KEYCHAIN_PRODUCT_ID_USER andServiceName:KEYCHAIN_SERVICE_NAME error:&error];
        
        NSLog(@"pass: %@", pass);
		if (pass != nil){
            
            [SFHFKeychainUtils storeUsername:KEYCHAIN_PRODUCT_ID_USER andPassword:pass forServiceName:KEYCHAIN_SERVICE_NAME updateExisting:YES error:nil];
            
			alreadyPurchasedProductIds = [[NSMutableArray alloc] initWithArray:[pass componentsSeparatedByString: @"|"]];
        }else{
			alreadyPurchasedProductIds = [NSMutableArray new];
        }
        
        NSLog(@"alreadyPurchasedProductIds: %@", alreadyPurchasedProductIds);
        
        
		[self checkNeedsRestore];
        
        
	}
	return self;
}
- (void)dealloc{
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void) checkNeedsRestore{
    LLog();
	if (needsRestore) {
        
		NSString* title = @"RESTORE PURCHASED CONTENT";
		NSString* msg = @"Would you like to check the App Store for previously purchased video content?";
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    LLog();
	if (buttonIndex == 1){
		[self restore];
	} else {
		needsRestore = NO;
		restoreCompleted = YES;
	}
    
}

//
// call this method once on startup
//
- (void) loadStore {
    LLog();
	if ([JxInAppStoreManager canMakePurchases]){
		// restarts any purchases if they were interrupted last time the app was open
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
		// get the product description (defined in early sections)
		[self requestProductData:productIds];
        
	}
}

//
// call this before making a purchase
//
+ (BOOL)canMakePurchases
{
    LLog();
    return [SKPaymentQueue canMakePayments];
}

#pragma mark -
#pragma mark Restore methods

- (void)restore{
    LLog();
	restoreAttempts++;
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    LLog();
	[self paymentQueue:queue updatedTransactions:queue.transactions];
	restoreCompleted = YES;
	if (_products != nil) {
		needsRestore = NO;
		[self notifyProductsFetched];
	}
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    LLog();
	NSString* title = @"Restore Purchases Failed";
	NSString* msg;
	if (restoreAttempts == 1)
        msg = @"An attempt to restore previously purchased content has failed. Trying again";
	else
        msg = @"Two attempts to restore previously purchased content have failed. Please re-install app";
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[alert show];
	if (restoreAttempts == 1){
		[self restore];
	} else {
		restoreCompleted = YES;
		if (_products != nil) {
			[self notifyProductsFetched];
			needsRestore = NO;
		}
	}
    
}

#pragma mark -

-(void)updateProgress:(NSTimer*)timer {
	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kInAppPurchaseManagerTransactionInProgressNotification object:self userInfo:nil];
	for (NSString* ID in [_progress allKeys]){
        
		NSNumber* prog = [_progress valueForKey:ID];
		NSNumber* newProg = [NSNumber numberWithFloat:([prog floatValue] + 0.01)];
		[_progress setValue:newProg forKey:ID];
        
	}
}

- (float)getProgress:(SKProduct *)product{
    LLog();
	NSNumber* prog = [_progress valueForKey:product.productIdentifier];
    if (prog == nil)
		return -1;
	else
		return [prog floatValue];
}

//
// kick off the transaction
//
- (void)purchase:(NSString *)productIdentifier
{
    LLog();
	BOOL newTimer = [_progress count] == 0;
	[_progress setValue:[NSNumber numberWithFloat:0] forKey:productIdentifier];
	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kInAppPurchaseManagerTransactionInitiatedNotification object:self userInfo:nil];
    
	if (newTimer) {
		[progressTimer invalidate];
		progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
	}
    SKProduct *product = [_products objectForKey:productIdentifier];
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark -
#pragma mark Purchase helpers


- (BOOL) validateReceipt:(SKPaymentTransaction*)transaction
{
    LLog();
	//NSData* receipt = transaction.transactionReceipt;
    
	//NSString* codedReceipt = [NSString base64StringFromData:receipt length:[receipt length]];
    
	//hit web service to validate receipt
    
	return YES;
    
    
}

- (BOOL)hasAlreadyPurchased:(NSSet*)productIdentifiers{
	BOOL donePurchased = NO;
	for (NSString* pid in productIdentifiers){
		if ([alreadyPurchasedProductIds containsObject:pid] ) {
		    donePurchased = YES;
			break;
            
		}
	}
    DLog(@"donePurchased %d", donePurchased);
	return donePurchased;
}

-(BOOL) canPurchase:(NSString *)productIdentifier{
    LLog();
	SKProduct* product = [_products valueForKey:productIdentifier];
	return !(product == nil || needsRestore );
    
}

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    LLog();
	NSError* error;
	NSString* pass = [SFHFKeychainUtils getPasswordForUsername:KEYCHAIN_PRODUCT_ID_USER andServiceName:KEYCHAIN_SERVICE_NAME error:&error];
    
	NSString* newPass;
	NSString* productID = transaction.payment.productIdentifier;
	if (pass == nil || [pass length] == 0)
		newPass = productID;
	else
        newPass = [pass stringByAppendingFormat:@"|%@",productID];
    
	[alreadyPurchasedProductIds addObject:productID];
    
	[SFHFKeychainUtils storeUsername:KEYCHAIN_PRODUCT_ID_USER andPassword:newPass forServiceName:KEYCHAIN_SERVICE_NAME updateExisting:YES error:&error];
    
    
}

- (void)clearAlreadyPurchased{
    LLog();
	NSError* error;
	[SFHFKeychainUtils storeUsername:KEYCHAIN_PRODUCT_ID_USER andPassword:@"" forServiceName:KEYCHAIN_SERVICE_NAME updateExisting:YES error:&error];
	[alreadyPurchasedProductIds removeAllObjects];
	needsRestore = YES;
	restoreCompleted = NO;
	[self checkNeedsRestore];
}


- (void)provideContent:(NSString *)productId
{
    LLog();
	// send out a notification that content can be provided
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:productId forKey:@"productId"];
	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kInAppPurchaseManagerCanProvideContent object:self userInfo:userInfo];
    
    
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    DLog(@"wasSuccessful %d", wasSuccessful);
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
	//do notifications and cleanup on original transaction if this is a restore
	if (transaction.transactionState == SKPaymentTransactionStateRestored)
		transaction = transaction.originalTransaction;
    
	[self purchaseCleanup:transaction.payment.productIdentifier];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        LLog();
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        LLog();
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}



- (void)purchaseCleanup:(NSString *)productIdentifier{
    LLog();
	[_progress removeObjectForKey:productIdentifier];
	if ([_progress count] == 0){
		[progressTimer invalidate];
		progressTimer = nil;
	}
    
}


#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    LLog();
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
	}
}


//
// called when the transaction was successfull
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    LLog();
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    LLog();
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    LLog();
	[self purchaseCleanup:transaction.payment.productIdentifier];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
		[self purchaseCleanup:transaction.payment.productIdentifier];
        
		// this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
		[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kInAppPurchaseManagerTransactionCancelledNotification object:self userInfo:userInfo];
        
    }
    
}


- (void)requestProductData:(NSArray*)myProductIds
{
    LLog();
	//remove product ids that have already been purchased
	NSMutableSet* productIdentifiers = [[NSMutableSet alloc] initWithArray:myProductIds];
	for (NSString* pid in alreadyPurchasedProductIds){
		[productIdentifiers removeObject:pid];
        
	}
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    LLog();
	//store list of products
    
    NSLog(@"response %@", response);
    NSLog(@"response.products %@", response.products);
    
	for (SKProduct* product in response.products){
		[_products setObject:product forKey:product.productIdentifier];
	}

    
	//log invalid product ids
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProductData

    
	//if restore has been requested, but hasn't received a response, then don't notify
    
    if (!needsRestore)
		[self notifyProductsFetched];
	else if (restoreCompleted){  //restore has already received response
		needsRestore = NO;
		[self notifyProductsFetched];
	}
}

-(void) notifyProductsFetched{
    LLog();
	//notify observers
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
    
}

+ (void) setNeedsRestore:(BOOL)needs{
    
	needsRestore = needs;;	
}

+(BOOL) needsRestore{
    
	return needsRestore;	
}

@end
