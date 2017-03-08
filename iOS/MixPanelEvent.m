//
//  MixPanelEvent.m
//  SW_SDK_sample_iOS
//
//  Created by Harjot Singh on 13/04/15.
//

#import "MixPanelEvent.h"
#import "Constant.h"
#import "Utilities.h"
#import "GAI.h"


#define UserSession @"User Session"
#define LoginSucess @"Login Successful"
#define Likes @"Likes"
#define Comment @"Comment"
#define ContestTnCClicked @"Contest TnC Click"
#define SearchExplore  @"Search Under Explore"
#define FeedsViewCount @"Feeds View Count"
#define Play  @"Song Played"
#define UploadBeat  @"Beats Uploaded"
#define UploadTrack @"Tracks Uploaded"
#define ShareAudio  @"Share Audio"
#define FollowUser  @"Follow User"
#define PresetApplied @"Presets Applied"
#define VisitUserProfile @"Profile Views"
#define FlagAudio @"Flag Audio"
#define Registration @"Registration"
#define DeleteBeatOrTrack @"Delete Beat Or Track"
#define Hashtags @"Hashtags"
#define RecordingStarted @"RecordingStarted"
#define RecommendedAudio @"Recommended Audios"
#define RecommendedUsers @"Recommended Users"
#define AdvertisingUrlClicked @"Advertising Url Click"
#define trackCountIncrementKey @"Track Count"
#define beatCountIncrementKey  @"Beat Count"
#define shareCountIncrementKey @"Shares"
#define shareCountEmailIncrementKey @"Email Count"
#define shareCountFbIncrementKey @"Facebook Count"
#define shareCountTwitterIncrementKey @"Twitter Count"
#define sharePlatformEmail     @"email"
#define sharePlatformFb        @"facebook"
#define sharePlatformTwitter   @"twitter"

#define name      1
#define userId    2
#define email     3
#define username  4


@implementation MixPanelEvent

#pragma mark - Add the MixPanel agent
+(void)startTrackingMixPanel {
    
    if ([strPortToBeUsed isEqual:ProdServer_MyApp_com]) {
        [Mixpanel sharedInstanceWithToken:MixPanelProdToken];
    }
    else {
        [Mixpanel sharedInstanceWithToken:MixPanelStagingToken];
    }
}

#pragma mark - Add the New Relic agent
+(void)startTrackingNewRelic {
    
    if ([strPortToBeUsed isEqual:ProdServer_MyApp_com]) {
        [NewRelicAgent startWithApplicationToken:NewRelicProdToken];
    }
    else {
        [NewRelicAgent startWithApplicationToken:NewRelicStagingToken];
    }
}

#pragma mark- Google Anaytics
+(void)startTrackingGoogleAnalytics {
    
    //only needs to work on production server
    if (![strPortToBeUsed isEqual:ProdServer_MyApp_com]) {
        return;
    }
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:GoogleAnalyticsProdToken];
}

#pragma mark - Inititate User Session
+(void) trackEventInitiateUserSession {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    //track when user has initiated the session
    [mixpanel timeEvent:UserSession];
}

#pragma mark - Ends User Session
+(void) trackEventEndsUserSession {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    //end the user session
    [mixpanel track:UserSession
         properties:[NSDictionary dictionaryWithObjectsAndKeys:
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark - Send user details on the mixpanel
+(void) trackEventUserLoginDetailsMixPanel:(NSDictionary *)dictDetails loginPaltrofm:(NSString *)strPlatform {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSString *struserId = [NSString stringWithFormat:@"%@",[dictDetails objectForKey:@"id"]];
    
    // mixpanel identify: must be called before
    // people properties can be set
    [mixpanel identify:struserId];
    
    //replace key for name and email
    NSMutableDictionary *dictNew = [[NSMutableDictionary alloc]initWithDictionary:dictDetails];
    NSMutableDictionary *dictData = [MixPanelEvent replaceKeysForNameAndEmail:dictNew];
    
    // Set user details
    [mixpanel.people set:dictData];
    
    // track successful login event
    [mixpanel track:LoginSucess
         properties:[NSDictionary dictionaryWithObjectsAndKeys:strPlatform,@"$platform",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
    
}

//replace the olde keys with new one
+ (NSMutableDictionary *)replaceKeysForNameAndEmail:(NSMutableDictionary *)dictDetails {
    
    //for name
    NSString *original  = @"screen_name";
    NSString *new       = @"$name";
    
    id value = [dictDetails objectForKey:original];
    [dictDetails removeObjectForKey:original];
    [dictDetails setObject:value forKey:new];
    
    //for email
    original  = @"email";
    new       = @"$email";
    
    id value1 = [dictDetails objectForKey:original];
    [dictDetails removeObjectForKey:original];
    [dictDetails setObject:value1 forKey:new];
    
    original = new = nil;
    
    return dictDetails;
}


#pragma mark Track like made on the mixpanel
+(void) trackEventLikeMadeToMixPanel:(NSString *)audioId withName:(NSString *)strAudioName {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track successful like event: when a beat or track is liked
    [mixpanel track:Likes
         properties:[NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audioId",
                     strAudioName,@"audioName",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Track comments made on the mixpanel
+(void) trackEventCommentMadeToMixPanel:(NSString *)audioId withName:(NSString *)audioName {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track successful comment event: when a beat or track is liked
    [mixpanel track:Comment
         properties:[NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audioId",
                     audioName,@"audioName",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Track comments made on the mixpanel
+(void) trackEventContestTnCClicked:(NSString *)strContestType forContestId:(NSNumber *)contestId {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track successful ContestTnC_Clicked event: when user agree to the Terms and conditions to the contest
    // Contest type is Music or Vocal
    [mixpanel track:ContestTnCClicked
         properties:[NSDictionary dictionaryWithObjectsAndKeys:strContestType,@"ContestType",contestId,@"ContestId",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}


#pragma mark Explore Search on the mixpanel
//Type can be hashtag, user, beat and tracks
+(void) trackEventSearchUnderExploreToMixPanel:(NSString *)searchText forType:(NSString *)strType {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track successful comment event: when a beat or track is liked
    [mixpanel track:SearchExplore
         properties:[NSDictionary dictionaryWithObjectsAndKeys:searchText,@"searchText",
                     strType,@"searchType",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Feeds View Count on the mixpanel
//We have created the milestone for feeds count. What numbers of feeds users load casually. This helps to know the request count for feeds load more.
// Milestones would be like 50, 100, 200, 350 and 500 above
+(void) trackEventFeedsViewCountToMixPanel:(NSNumber *)countOfFeeds {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:FeedsViewCount
         properties:[NSDictionary dictionaryWithObjectsAndKeys:countOfFeeds,@"countOfFeeds",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Recommended Users count-scroll mixpanel
//For recommended users we need to track how many users scrolls it to bottom. As soon users scroll to the bottom of the row, we need to send event to Mixpanel. This will help to track how many users scrolls the USERS to bottom so we can increase or decrease the count for same.
+(void) trackEventRecommendedUsersLoadedToMixPanel:(NSNumber *)countOfUsers {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:RecommendedUsers
         properties:[NSDictionary dictionaryWithObjectsAndKeys:countOfUsers,@"countOfUsers",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Recommended Audios count-scroll mixpanel
//For recommended audios we need to track how many users scrolls it to bottom. As soon users scroll to the bottom of the row, we need to send event to Mixpanel. This will help to track how many users scrolls the audios to bottom so we can increase or decrease the count for same.
// The type would be beat or track
+(void) trackEventRecommendedAudiosLoadedToMixPanel:(NSNumber *)countOfAudios forType:(NSString *)strType {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:RecommendedAudio
         properties:[NSDictionary dictionaryWithObjectsAndKeys:countOfAudios,@"countOfAudios",strType,@"typeOfAudio",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Track - 'beat' upload on the mixpanel
+(void) trackEventBeatUploadedToMixPanel:(NSString *)audioId :(NSString*)audioName {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track successful event: when a beat is uploaded
    [mixpanel track:UploadBeat
         properties:[NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audioId",
                     audioName,@"audioName",@"iOS",@"platform",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
    
    //first identify the user and then incremnet the key for the track count
    [mixpanel identify:[MixPanelEvent getUserDetail:userId]];
    [mixpanel.people increment:beatCountIncrementKey by:[NSNumber numberWithInteger:1]];
    
}

#pragma mark Track - 'track' upload on the mixpanel
+(void) trackEventTrackUploadedToMixPanel:(NSString *)audioId :(NSString*)audioName isVideoOrAudioTrack:(NSString *)strTrackFormat presetSelected:(NSString *)strPreset contestId:(NSString *)strContestId {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSDictionary *dictParams ;
    
    if (strContestId.length > 0 && strContestId.integerValue > 0 && strContestId != nil) {
        
        dictParams = [NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audioId",
                      audioName,@"audioName",strContestId,@"contestId",strTrackFormat,@"trackFormat",strPreset,@"presetApplied",@"iOS",@"platform",
                      [MixPanelEvent getUserDetail:userId],@"UserId",
                      [MixPanelEvent getUserDetail:name],@"$name",
                      [MixPanelEvent getUserDetail:email],@"$email",
                      [MixPanelEvent getUserDetail:username],@"Username", nil];
    }
    else {
        
        dictParams = [NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audioId",
                      audioName,@"audioName",strTrackFormat,@"trackFormat",strPreset,@"presetApplied",@"iOS",@"platform",
                      [MixPanelEvent getUserDetail:userId],@"UserId",
                      [MixPanelEvent getUserDetail:name],@"$name",
                      [MixPanelEvent getUserDetail:email],@"$email",
                      [MixPanelEvent getUserDetail:username],@"Username", nil];
    }
    
    
    // track successful event: when a track is uploaded
    [mixpanel track:UploadTrack properties:dictParams];
    
    //first identify the user and then incremnet the key for the track count
    [mixpanel identify:[MixPanelEvent getUserDetail:userId]];
    [mixpanel.people increment:trackCountIncrementKey by:[NSNumber numberWithInteger:1]];
    
}
#pragma mark Track - Advertising Url Click on the mixpanel
+(void) trackEventAdvertisingUrlClickToMixPanel:(NSString *)urlClicked {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track successful event: when a track is uploaded
    [mixpanel track:AdvertisingUrlClicked
         properties:[NSDictionary dictionaryWithObjectsAndKeys:urlClicked,@"url",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Track audio played on the mixpanel
+(void) trackEventAudioPlayedToMixPanel:(NSString *)audioId audioName:(NSString *)strAudioName belongsTo:(NSString *)strArtist isVideoOrAudio:(NSString *)audioType {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track event: when song is played
    [mixpanel track:Play
         properties:[NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audioId",
                     strAudioName,@"audioName",
                     strArtist,@"Artist",audioType,@"trackFormat",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Track audio shared on the mixpanel
+(void) trackEventAudioSharedToMixPanel:(NSString *)audioId :(NSString*)sharedOn :(NSString*)audioType :(NSString*)strAudioName :(NSString*)strArtist :(int)intShareCount {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track event: audio shared
    [mixpanel track:ShareAudio
         properties:[NSDictionary dictionaryWithObjectsAndKeys:audioId,@"audioId",
                     sharedOn,@"SharedPlatform",
                     audioType,@"audioType",
                     strAudioName,@"audioName",
                     strArtist,@"artist",
                     [NSNumber numberWithInt:intShareCount], @"shareCount",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
    
    
    //first identify the user and then incremnet the key for the share count
    [mixpanel identify:[MixPanelEvent getUserDetail:userId]];
    
    NSDictionary *dictKeys;
    
    if ([sharedOn isEqualToString:sharePlatformEmail]) {
        dictKeys = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1],shareCount_IncrementKey,[NSNumber numberWithInteger:1],shareCount_email_IncrementKey, nil];
    }
    else if ([sharedOn isEqualToString:sharePlatformFb]) {
        dictKeys = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1],shareCount_IncrementKey,[NSNumber numberWithInteger:1],shareCount_fb_IncrementKey, nil];
    }
    else if ([sharedOn isEqualToString:sharePlatformTwitter]) {
        dictKeys = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1],shareCount_IncrementKey,[NSNumber numberWithInteger:1],shareCount_twitter_IncrementKey, nil];
    }
    
    [mixpanel.people increment:dictKeys];
    
}

#pragma mark Presets applied on the mixpanel
+(void) trackEventPresetsAppliedToMixPanel:(NSString *)presetName withAudioID:(NSString *)audioId withName:(NSString *)audioName {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track event: presets applied
    [mixpanel track:PresetApplied
         properties:[NSDictionary dictionaryWithObjectsAndKeys:presetName,@"presetName",audioId,@"audioId",
                     audioName,@"audioName",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Follower Event on the mixpanel
+(void) trackEventFollowUserToMixPanel:(NSString *)followerName withUsername:(NSString *)follUsername withUserID:(NSString *)followerId {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // track event: follow user
    [mixpanel track:FollowUser
         properties:[NSDictionary dictionaryWithObjectsAndKeys:followerName,@"followerScreenName",followerId,@"followerUserId",
                     follUsername,@"followerUsername",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Visit User Profile View Event on the mixpanel
+(void) trackEventVisitUserProfileToMixPanel:(NSString *)strName withUsername:(NSString *)strUserName withUserID:(NSString *)strUserId {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:VisitUserProfile
         properties:[NSDictionary dictionaryWithObjectsAndKeys:strName,@"ProfileScreenName",strUserId,@"ProfileUserId",
                     strUserName,@"ProfileUsername",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
    
}

#pragma mark Flag Audio Event on the mixpanel
+(void) trackEventFlagAudioToMixPanel:(NSString *)strAudioName audioId:(NSString *)strAudioId category:(NSString *)strCatId desc:(NSString *)strDesc {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:FlagAudio
         properties:[NSDictionary dictionaryWithObjectsAndKeys:strAudioId,@"audioId",
                     strAudioName,@"audioName",
                     strCatId,@"Category",
                     strDesc,@"reasonDescription",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
    
}

#pragma mark Sign Up on the mixpanel
+(void) trackEventSignUpToMixPanel:(NSString *)strPlatform :(NSMutableDictionary*)dictDetails {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSString *struserId = [NSString stringWithFormat:@"%@",[dictDetails objectForKey:@"id"]];
    
    // mixpanel identify: must be called before
    // people properties can be set
    [mixpanel identify:struserId];
    
    //replace key for name and email
    NSMutableDictionary *dictNew = [[NSMutableDictionary alloc]initWithDictionary:dictDetails];
    NSMutableDictionary *dictData = [MixPanelEvent replaceKeysForNameAndEmail:dictNew];
    
    // Set user details
    [mixpanel.people set:dictData];
    
    // track successful login event
    [mixpanel track:Registration
         properties:[NSDictionary dictionaryWithObjectsAndKeys:strPlatform,@"$platform",
                     [MixPanelEvent getUserDetail:userId],@"$UserId",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
    
}

#pragma mark Delete Beat/Track on the mixpanel
+(void) trackEventDeleteBeatOrTrackToMixPanel:(NSString *)audioName audioId:(NSString *)strAudioId type:(NSString *)strType {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:DeleteBeatOrTrack
         properties:[NSDictionary dictionaryWithObjectsAndKeys:strAudioId,@"audioId",
                     audioName,@"audioName",strType,@"type",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark Hashta on the mixpanel
+(void) trackEventHashtagsToMixPanel:(NSArray *)arrHashtags audioName:(NSString *)strAudioName audioId:(NSString *)strAudioId {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:Hashtags
         properties:[NSDictionary dictionaryWithObjectsAndKeys:arrHashtags,@"hashtags",strAudioId,@"audioId",
                     strAudioName,@"audioName",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

+(void) trackEventRecordStartedToMixPanelAudioName:(NSString *)strAudioName audioId:(NSString *)strAudioId {
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:RecordingStarted
         properties:[NSDictionary dictionaryWithObjectsAndKeys:strAudioId,@"audioId",
                     strAudioName,@"audioName",
                     [MixPanelEvent getUserDetail:userId],@"UserId",
                     [MixPanelEvent getUserDetail:name],@"$name",
                     [MixPanelEvent getUserDetail:email],@"$email",
                     [MixPanelEvent getUserDetail:username],@"Username", nil]];
}

#pragma mark - Get User details
+(NSString*) getUserDetail:(NSInteger)selOption {
    
    switch (selOption) {
        case name:{
            NSDictionary *userDetails = (NSDictionary*)[Utilities getUserDetailsFromUserDefaults];
            return [userDetails objectForKey:@"screen_name"];
        }
            break;
        case userId:
            return [Utilities getUserIdFromUserDefaults];
            break;
        case username:
            return [Utilities getUsernameFromUserDefaults];
            break;
        case email:{
            NSDictionary *userDetails = (NSDictionary*)[Utilities getUserDetailsFromUserDefaults];
            return [userDetails objectForKey:@"email"];
        }
            break;
        default:
            return @"";
            break;
    }
}

@end
