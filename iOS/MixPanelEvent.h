//
//  MixPanelEvent.h
//  SW_SDK_sample_iOS
//
//  Created by Harjot Singh on 13/04/15.
//

#import <Foundation/Foundation.h>
#import "Mixpanel.h"

@interface MixPanelEvent : NSObject

+(void) startTrackingNewRelic;
+(void) startTrackingMixPanel;
+(void) startTrackingGoogleAnalytics;
+(void) trackEventInitiateUserSession;
+(void) trackEventEndsUserSession;
+(void) trackEventUserLoginDetailsMixPanel:(NSDictionary *)dictDetails loginPaltrofm:(NSString *)strPlatform;
+(void) trackEventLikeMadeToMixPanel:(NSString *)audioId withName:(NSString *)strAudioName;
+(void) trackEventCommentMadeToMixPanel:(NSString *)audioId withName:(NSString *)audioName;
+(void) trackEventContestTnCClicked:(NSString *)strContestType forContestId:(NSNumber *)contestId;
+(void) trackEventSearchUnderExploreToMixPanel:(NSString *)searchText forType:(NSString *)strType;
+(void) trackEventFeedsViewCountToMixPanel:(NSNumber *)countOfFeeds;
+(void) trackEventRecommendedUsersLoadedToMixPanel:(NSNumber *)countOfUsers;
+(void) trackEventRecommendedAudiosLoadedToMixPanel:(NSNumber *)countOfAudios forType:(NSString *)strType;
+(void) trackEventBeatUploadedToMixPanel:(NSString *)audioId :(NSString*)audioName;
+(void) trackEventTrackUploadedToMixPanel:(NSString *)audioId :(NSString*)audioName isVideoOrAudioTrack:(NSString *)strTrackFormat presetSelected:(NSString *)strPreset contestId:(NSString *)strContestId;
+(void) trackEventAdvertisingUrlClickToMixPanel:(NSString *)urlClicked;
+(void) trackEventAudioPlayedToMixPanel:(NSString *)audioId audioName:(NSString *)strAudioName belongsTo:(NSString *)strArtist isVideoOrAudio:(NSString *)audioType;
+(void) trackEventAudioSharedToMixPanel:(NSString *)audioId :(NSString*)sharedOn :(NSString*)audioType :(NSString*)strAudioName :(NSString*)strArtist :(int)intShareCount;
+(void) trackEventPresetsAppliedToMixPanel:(NSString *)presetName withAudioID:(NSString *)audioId withName:(NSString *)audioName;
+(void) trackEventFollowUserToMixPanel:(NSString *)followerName withUsername:(NSString *)follUsername withUserID:(NSString *)followerId;
+(void) trackEventVisitUserProfileToMixPanel:(NSString *)strName withUsername:(NSString *)strUserName withUserID:(NSString *)strUserId;
+(void) trackEventFlagAudioToMixPanel:(NSString *)strAudioName audioId:(NSString *)strAudioId category:(NSString *)strCatId desc:(NSString *)strDesc;
+(void) trackEventSignUpToMixPanel:(NSString *)strPlatform :(NSMutableDictionary*)dictDetails;
+(void) trackEventDeleteBeatOrTrackToMixPanel:(NSString *)audioName audioId:(NSString *)strAudioId type:(NSString *)strType;
+(void) trackEventHashtagsToMixPanel:(NSArray *)arrHashtags audioName:(NSString *)strAudioName audioId:(NSString *)strAudioId;
+(void) trackEventRecordStartedToMixPanel_audioName:(NSString *)strAudioName audioId:(NSString *)strAudioId;
+(NSString*) getUserDetail:(NSInteger)selOption;

@end
