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
#import <AddressBookUI/AddressBookUI.h>

@implementation KHHAddressBook

//保存到通讯录
+ (BOOL)saveToCantactWithCard:(Card *)card
{
    BOOL result = YES;
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    if (card.mobilePhone && card.mobilePhone.length > 0) {
        NSArray *mobiles = [card.mobilePhone componentsSeparatedByString:KHH_SEPARATOR];
        for (NSString *mobileNum in mobiles) {
            if (mobileNum.length > 0) {
                ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef)mobileNum, kABPersonPhoneMobileLabel, NULL);
            }
        }
    }
    if (card.telephone && card.telephone.length > 0 ) {
        NSArray *tels = [card.telephone componentsSeparatedByString:KHH_SEPARATOR];
        for (NSString *tel in tels) {
            if (tel.length > 0) {
                ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFTypeRef)tel, kABPersonPhoneMainLabel, NULL);
            }
        }
    }
    if (card.fax && card.fax.length > 0) {
        NSArray *faxes = [card.fax componentsSeparatedByString:KHH_SEPARATOR];
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
        NSArray *emails = [card.email componentsSeparatedByString:KHH_SEPARATOR];
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
		ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)card.company.name, NULL);
	}else{
		ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"", NULL);
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

+ (NSArray *)getAddressBookData
{
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:12];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef array = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i = 0; i < CFArrayGetCount(array); ++i) {
        ABRecordRef person = CFArrayGetValueAtIndex(array, i);
        
        NSString *first = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *last =  (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        NSString *name = [NSString stringWithFormat:@"%@%@", last?:@"", first?:@""];
        
        CFStringRef company= ABRecordCopyValue(person, kABPersonOrganizationProperty);
        NSString *companyStr = (company && CFStringGetLength(company) > 0)?(__bridge NSString *)company:@"";
        
        NSString *phone = nil;
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSMutableArray *phoneArr = [NSMutableArray arrayWithCapacity:ABMultiValueGetCount(phones)];
        
        if (ABMultiValueGetCount(phones) > 0) {
            phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
        }
        
        for(int i=0; i<ABMultiValueGetCount(phones); ++i){
            NSString *number = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            [phoneArr addObject:number];
        }
        
        CFRelease(phones);
        
        if([name stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
            name = phone;
            if(name.length == 0){
                ABMultiValueRef emailsMultiRef = ABRecordCopyValue(person, kABPersonEmailProperty);
                
                NSArray *emails =  (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailsMultiRef);
                name = emails.count>0 ? [emails objectAtIndex:0] : @"无名称";
                
                CFRelease(emailsMultiRef);
            }
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"name",
                              companyStr, @"company",
                              phone, @"phone", phoneArr, @"phoneArr", nil];
        [datas addObject:dict];
    }
    CFRelease(array);
    CFRelease(addressBook);
    
    return datas;
}
@end
