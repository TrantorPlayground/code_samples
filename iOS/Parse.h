//
//  Parse.h
//  SW_SDK_sample_iOS
//
//  Created by OSX on 08/06/15.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"
#import "Audio.h"
#import "Comment.h"
#import "HashTag.h"
#import "SocialAccounts.h"

@interface Parse : NSObject

+(NSString*)parseDictForValue_AudioUserScreenName:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioUserName:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioName:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioLikeCount:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioCommentCount:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioPlayCount:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioShareCount:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioRepostCount:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioURL:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioType:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioImage_Medium:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioImage_Small:(NSDictionary*)dict;
+(NSString*)parseDictForValue_Running_Contest_Name:(NSDictionary*)dict;
+(NSString*)parseDictForValue_ShareAudioImage:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioID:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioUserImage_Thumb:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioUserImage_Medium:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioCreatedAt:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioProducer:(NSDictionary*)dict;
+(NSString*)parseDictForValue_Audio_Collaborators:(NSDictionary*)dict;
+(NSString*)parseDictForValue_Audio_BeatName:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioDesc:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioDuration:(NSDictionary*)dict;
+(NSString*)parseDictForValue_ContestType_VocalOrMusic:(NSDictionary*)dict;
+(NSString*)parseDictForValue_ContestType_Image:(NSDictionary*)dict;
+(NSString*)parseDictForValue_Audio_AdvertisingInfo:(NSDictionary*)dict;
+(NSString*)parseDictForValue_User_Location:(NSDictionary*)dict;
+(NSString*)parseDictForValue_Contest_TnC:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioUserID:(NSDictionary*)dict;
+(NSString*)parseDictForValue_Audio_ParentBeatID:(NSDictionary*)dict;
+(NSString*)parseDictForValue_AudioSlug:(NSDictionary*)dict;

+(BOOL)parseDictForValue_IsFeatured_Banner:(NSDictionary*)dict;
+(BOOL)parseDictForValue_Contest_Is_Running_DataAvailable:(NSDictionary*)dict;
+(BOOL)parseDictForValue_Contest_Is_Running:(NSDictionary*)dict;
+(BOOL)parseDictForValue_Contest_Results_Banner_DataAvailable:(NSDictionary*)dict;
+(BOOL)parseDictForValue_Contest_Results_Banner:(NSDictionary*)dict;
+(BOOL)parseDictForValue_Audio_isLikeFlag:(NSDictionary*)dict;

+(void)parseUpdateSingletonDataModelArray:(NSMutableDictionary*)dictionary :(NSString*) className;

+(NSDictionary*)parseDictForValue_Audio_User:(NSDictionary*)dict;
+(NSDictionary*)parseDictForValue_ParentBeatUserDetail:(NSDictionary*)dict;
+(NSDictionary*)parseDictForValue_Audio_ParentDict:(NSDictionary*)dict;

+(NSInteger)parseDictForValue_Contest_Results_Position:(NSDictionary*)dict;
+(NSNumber*)parseDictForValue_Contest_ID:(NSDictionary*)dict;

+(NSArray*)parseDictForValue_ContestTypes:(NSDictionary*)dict;
+(NSArray*)getParsedAudioArrayFromData:(NSArray*)audioData;
+(NSArray*)getParsedUsersArrayFromData:(NSArray*)userData;
+(NSArray*)getParsedTagsArrayFromData:(NSArray*)tagsData;
+(NSMutableArray*)mappingFeedsData:(NSMutableArray *)arrData;

+(Comment*)getCommentsfromData:(NSDictionary*)dictComment;
+(User*)getUserFromData:(NSDictionary*)dictUser;
+(Image*)getImageFromData:(NSDictionary*)dictImage;
+(ContestDetails *)getContestDetailsFromData:(NSDictionary *)dictContestDetails;
+(Contest*)getContestFromData:(NSDictionary*)dictContest;
+(Link*)getLinksFromData :(NSDictionary*)dictLinks;
+(Audio*)getAudioFromData:(NSDictionary*)dictAudio;
+(Audio*)compareOldAudio:(Audio*)audioOld withNewAudio:(Audio*)audioNew;
+(SocialAccounts*)getSocialAccountfromData:(NSDictionary*)dictSocialAccount ;
+(HashTag*)getTagfromData:(NSDictionary*)dictTag;

@end
