//
//  KHHAddressBook.m
//  CardBook
//
//  Created by 王国辉 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHAddressBook.h"
#import "Company.h"
#import "Address.h"
#import <AddressBook/AddressBook.h>
@implementation KHHAddressBook
//保存到通讯录
+ (BOOL)saveToCantactWithCard:(MyCard *)card
{
    BOOL result = YES;
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    if (card.mobilePhone && card.mobilePhone.length > 0) {
        NSArray *mobiles = [card.mobilePhone componentsSeparatedByString:@"|"];
        for (NSString *mobileNum in mobiles) {
            if (mobileNum.length > 0) {
                ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef)mobileNum, kABPersonPhoneMobileLabel, NULL);
            }
        }
    }
    if (card.telephone && card.telephone.length > 0 ) {
        NSArray *tels = [card.telephone componentsSeparatedByString:@"|"];
        for (NSString *tel in tels) {
            if (tel.length > 0) {
                ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef)tel, kABPersonPhoneMainLabel, NULL);
            }
        }
    }
    if (card.fax && card.fax.length > 0) {
        NSArray *faxes = [card.fax componentsSeparatedByString:@"|"];
        for (NSString *faxNum in faxes) {
            if (faxNum.length > 0) {
                ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef)faxNum, kABPersonPhoneWorkFAXLabel, NULL);
            }
        }
    }
    
    //address
     ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
//    CFStringRef keys[5] = {kABPersonAddressZIPKey,kABPersonAddressStreetKey,kABPersonAddressCityKey,kABPersonAddressStateKey,kABPersonAddressCountryKey};
//    CFStringRef values[5];
    
    //邮编
    //详细地址
//    if (card.address != nil) {
//        values[1] = (__bridge CFStringRef)card.address;
//    }else{
//        values[1] = (__bridge CFStringRef)@"";
//    }
//    CFDictionaryRef aDict = CFDictionaryCreate(kCFAllocatorDefault, (void *)keys, (void *)values, 1, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
//    ABMultiValueAddValueAndLabel(address, aDict, kABHomeLabel, NULL);
//    CFRelease(aDict);
    
    //emails
    ABMutableMultiValueRef emails = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    if (card.email && card.email.length > 0) {
        NSArray *emails = [card.email componentsSeparatedByString:@"|"];
        for (NSString *email in emails) {
            if (email.length > 0) {
                 ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef)email, kABWorkLabel, NULL);
            }
        }
    }
    ABRecordRef newPerson = ABPersonCreate();
    if (card.department && card.department.length > 0) {
        ABRecordSetValue(newPerson, kABPersonDepartmentProperty, (__bridge CFTypeRef)card.department, NULL);
    }
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)card.name, NULL);
   //判断公司名字,
    if (card.company && card.company.name.length > 0) {
		ABRecordSetValue(newPerson, kABPersonNoteProperty, (__bridge CFTypeRef)card.company.name, NULL);
	}else{
		ABRecordSetValue(newPerson, kABPersonNoteProperty, @"", NULL);
	}
    if (card.title && card.title.length > 0) {
        ABRecordSetValue(newPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)card.title, NULL);
    }
    
    ABRecordSetValue(newPerson, kABPersonEmailProperty, emails, NULL);
	ABRecordSetValue(newPerson, kABPersonPhoneProperty, phoneNumbers, NULL);
	ABRecordSetValue(newPerson, kABPersonAddressProperty, address, NULL);
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (!ABAddressBookAddRecord(addressBook, newPerson, &error)) {
        //goto SAVEADDRESSFROMCARDEND;
    }
    if (!ABAddressBookSave(addressBook,&error)) {
        //goto SAVEADDRESSFROMCARDEND;
    }
    
SAVEADDRESSFROMCARDEND:
	CFRelease(emails);
	CFRelease(address);
	CFRelease(phoneNumbers);
	CFRelease(newPerson);
	CFRelease(addressBook);
    
    if (error) {
        
        CFRelease(error);
    }

    return result;
}
@end
