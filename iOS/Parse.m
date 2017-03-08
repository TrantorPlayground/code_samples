//
//  Parse.m
//  SW_SDK_sample_iOS
//
//  Created by OSX on 08/06/15.
//
//

#import "Parse.h"
#import "APIMyApp.h"
#import "AppDelegate.h"
#import "AllActivityViewController.h"

@implementation Parse

#pragma mark - Parse Tags
+(NSArray*)getParsedTagsArrayFromData:(NSArray *)tagsData {
    @try {
        NSMutableArray *tagsArray = [NSMutableArray new];
        if (tagsData!= nil && tagsData.count > 0) {
            
            for (NSDictionary *dictTag in tagsData) {
                HashTag *tag = [ self getTagfromData:dictTag];
                [tagsArray addObject:tag];
            }
        }
        return tagsArray;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse Tag Data

+(HashTag *)getTagfromData:(NSDictionary *)dictTag {
    @try {
        HashTag *tag = [HashTag new];
        
        // count
        if (![[dictTag objectForKey:ApiKeyTagCount] isEqual:[NSNull null]] && [dictTag objectForKey:ApiKeyTagCount] != nil) {
            tag.count = [[dictTag objectForKey:ApiKeyTagCount] integerValue];
        }
        
        //id
        if (![[dictTag objectForKey:ApiKeyTagId] isEqual:[NSNull null]] && [dictTag objectForKey:ApiKeyTagId] != nil) {
            tag.tagID = [[dictTag objectForKey:ApiKeyTagId] integerValue];
        }
        
        //name
        if (![[dictTag objectForKey:ApiKeyTagName] isEqual:[NSNull null]] && [dictTag objectForKey:ApiKeyTagName] != nil) {
            tag.tagName = [dictTag objectForKey:ApiKeyTagName];
        }
        
        return tag;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}


#pragma mark - Parse Users

+(NSArray*)getParsedUsersArrayFromData:(NSArray *)userData {
    @try {
        NSMutableArray *userArray = [NSMutableArray new];
        if (userData!= nil && userData.count > 0) {
            
            for (NSDictionary *dictUser in userData) {
                User *userChunk = [ self getUserFromData:dictUser];
                [userArray addObject:userChunk];
            }
        }
        return userArray;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma mark - Parse Audio chunk

+(NSArray*)getParsedAudioArrayFromData:(NSArray *)audioData {
    @try {
        NSMutableArray *audioArray = [NSMutableArray new];
        if (audioData!= nil && audioData.count > 0) {
            
            for (NSDictionary *dictAudio in audioData) {
                Audio *audioChunk = [ self getAudioFromData:dictAudio];
                [audioArray addObject:audioChunk];
            }
        }
        return audioArray;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

+(Audio*)compareOldAudio:(Audio *)audioOld withNewAudio:(Audio*)audioNew {
    @try {
        Audio *audioChunk = audioOld;
        //song_type
        if (audioOld.audioType == nil && audioNew.audioType != nil) {
            audioChunk.audioType = audioNew.audioType;
        }
        
        //collaborations: Update count always
        audioChunk.collaborations = audioNew.collaborations;
        
        //comments
        if (audioOld.comments == nil && audioNew.comments != nil) {
            audioChunk.comments = audioNew.comments;
        }
        
        //comments_count: Update count always
        audioChunk.commentsCount = audioNew.commentsCount;
        
        //contest_detail
        if (audioOld.contestDetails == nil && audioNew.contestDetails != nil) {
            audioChunk.contestDetails = audioNew.contestDetails;
        }
        
        //created_at
        if (audioOld.createdAt == nil && audioNew.createdAt != nil) {
            audioChunk.createdAt = audioNew.createdAt;
        }
        
        //description
        if (audioOld.audioDescription == nil && audioNew.audioDescription != nil) {
            audioChunk.audioDescription = audioNew.audioDescription;
        }
        
        //duration: Update duration always
        audioChunk.duration = audioNew.duration;
        
        //featured
        NSNumber *oldIsFeatured =  [NSNumber numberWithBool:audioOld.isFeatured];
        NSNumber *newIsFeatured =  [NSNumber numberWithBool:audioNew.isFeatured];
        
        if (oldIsFeatured != newIsFeatured ) {
            audioChunk.isFeatured = audioNew.isFeatured;
        }
        
        //image
        if (audioOld.image == nil && audioNew.image != nil) {
            audioChunk.image = audioNew.image;
        }
        
        //is_liked
        NSNumber *oldIsLiked =  [NSNumber numberWithBool:audioOld.isLiked];
        NSNumber *newIsLiked =  [NSNumber numberWithBool:audioNew.isLiked];
        
        if (oldIsLiked != newIsLiked ) {
            audioChunk.isLiked = audioNew.isLiked;
        }
        
        //is_reposted
        NSNumber *oldIsReposted =  [NSNumber numberWithBool:audioOld.isReposted];
        NSNumber *newIsReposted =  [NSNumber numberWithBool:audioNew.isReposted];
        
        if (oldIsReposted != newIsReposted ) {
            audioChunk.isReposted = audioNew.isReposted;
        }
        
        //likes: Update count always
        audioChunk.likes = audioNew.likes;
        
        //links
        if (audioOld.links == nil && audioNew.links != nil) {
            audioChunk.links = audioNew.links;
        }
        
        //media_format
        if (audioOld.mediaFormat == nil && audioNew.mediaFormat != nil) {
            audioChunk.mediaFormat = audioNew.mediaFormat;
        }
        
        //name
        if (audioOld.audioName == nil && audioNew.audioName != nil) {
            audioChunk.audioName = audioNew.audioName;
        }
        
        //parent
        if (audioOld.parent == nil && audioNew.parent != nil) {
            audioChunk.parent = audioNew.parent;
        }
        
        //plays: Update count always
        audioChunk.plays = audioNew.plays;
        
        //reposts: Update count always
        audioChunk.reposts = audioNew.reposts;
        
        //slug
        if (audioOld.slug == nil && audioNew.slug != nil) {
            audioChunk.slug = audioNew.slug;
        }
        
        //song_url
        if (audioOld.songUrl == nil && audioNew.songUrl != nil) {
            audioChunk.songUrl = audioNew.songUrl;
        }
        
        //type
        if (audioOld.type == nil && audioNew.type != nil) {
            audioChunk.type = audioNew.type;
        }
        
        //user
        if (audioOld.user == nil && audioNew.user != nil) {
            audioChunk.user = audioNew.user;
        }
        
        return audioChunk;
        
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

+(NSMutableArray *)mappingFeedsData:(NSMutableArray *)arrData {
    
    @try {
        
        NSMutableArray *arrDataFinal = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [arrData count]; i++) {
            
            NSMutableArray *arrDataMap = [[NSMutableArray alloc] init];
            Audio *objAudio = [arrData objectAtIndex:i];
            
            [arrDataMap addObject:CellMappingType_AudioImage];
            [arrDataMap addObject:CellMappingType_TapAction];
            [arrDataMap addObject:CellMappingType_AudioDesc];//Now by default keys will be there.
            
            if ([[objAudio.audioType lowercaseString] isEqualToString:AudioTypeBeat]) {
                [arrDataMap addObject:CellMappingType_AudioCount];
            }
            else {
                [arrDataMap addObject:CellMappingType_AudioCountExcludeCollab];
            }
            
            BOOL isLinePartitionAdded = FALSE;
            
            //check for description commentCell1 + linePartition
            if (objAudio.audioDescription.length > 0) {
                
                //one for description and one for the line partition
                [arrDataMap addObject:CellMappingType_LinePartition];
                isLinePartitionAdded = TRUE;    //as soon line added, this will not be added again
                
                [arrDataMap addObject:CellMappingType_Comment1];
                
                //This padding is just beneath the comments if viewallcomments cell is not there
                // SO the comments have valid space before start of another cell
                if (objAudio.comments.count == 0) {
                    [arrDataMap addObject:CellMappingType_BottomPadding];
                }
            }
            
            if (objAudio.comments.count > 0) {
                
                if (objAudio.comments.count > 0) {
                    
                    if (isLinePartitionAdded) {
                        [arrDataMap addObject:CellMappingType_Comment2];
                    }
                    else{
                        //one for description and one for the line partition
                        [arrDataMap addObject:CellMappingType_LinePartition];
                        [arrDataMap addObject:CellMappingType_Comment2];
                    }
                }
 
                //for 2nd comment
                if (objAudio.comments.count > 1) {
                    [arrDataMap addObject:CellMappingType_Comment3];
                }
                
                //for all comments, if comments count is more than 2, than we show the comment button
                if (objAudio.commentsCount > 2) {
                    [arrDataMap addObject:CellMappingType_ViewAllComments];
                }
                else {
                    [arrDataMap addObject:CellMappingType_BottomPadding];
                }
            }
            
            //for all activity feeds we need a separator bottom line. If we have only one activity feed then we dont require that or not in the end
            
            if (arrData.count != 1) {
                [arrDataMap addObject:CellMappingType_BottommLinePartition];
            }
            
            [arrDataFinal addObject:[NSDictionary dictionaryWithObjectsAndKeys:objAudio,AUDIO_DATA,arrDataMap,MAPPING_DATA, nil]];
            
        }
        
        return arrDataFinal;
        
    } @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
    
}

#pragma  mark - Parse Audio Data

+(Audio *)getAudioFromData:(NSDictionary *)dictAudio {
    @try {
        Audio *audioChunk = [Audio new];
        //song_type
        if (![[dictAudio objectForKey:ApiKeySongType] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongType] != nil) {
            audioChunk.audioType = [dictAudio objectForKey:ApiKeySongType];
        }
        
        //collaborations
        if (![[dictAudio objectForKey:ApiKeySongCollaboration] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongCollaboration] != nil) {
            audioChunk.collaborations = [[dictAudio objectForKey:ApiKeySongCollaboration] integerValue];
        }
        
        //comments
        if (![[dictAudio objectForKey:ApiKeySongComments] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongComments] != nil) {
            
            NSArray *commentsArrayData = (NSArray *)[dictAudio objectForKey:ApiKeySongComments];
            NSMutableArray *commentsArray = [NSMutableArray new];
            
            for (NSDictionary *dictComment in commentsArrayData) {
                Comment *comment = [self getCommentsfromData:dictComment];
                [commentsArray addObject:comment];
            }
            audioChunk.comments = commentsArray;
        }
        
        //comments_count
        if (![[dictAudio objectForKey:ApiKeySongCommentsCount] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongCommentsCount] != nil) {
            audioChunk.commentsCount = [[dictAudio objectForKey:ApiKeySongCommentsCount] integerValue];
        }
        
        //----- CONTEST PARSING ----//
        
        //Under Contests for Beat we have only one chunk coming for the running contests. And in tracks it has contestdetails chunk which have contest_reult along with runningcontest details.
        //So parsing of both will be done differently
        
        if ([[audioChunk.audioType lowercaseString] isEqualToString:AudioTypeBeat]) {
            
            //running_contest
            // As winner of coca-cola contest will be decided and announced on its profile. No banner will be going to show under this API version.
            // Earlier api version 3.0 will works the same way as it was running.
            
            if (![[[dictAudio objectForKey:ApiKeySongContestDetails] objectForKey:ApiKeyContestDetailsRunning] isEqual:[NSNull null]] && [[dictAudio objectForKey:ApiKeySongContestDetails] objectForKey:ApiKeyContestDetailsRunning] != nil ) {
                
                ContestDetails *contestDetails = [ContestDetails new];
                
                Contest *contest = [self getContestFromData:[[dictAudio objectForKey:ApiKeySongContestDetails] objectForKey:ApiKeyContestDetailsRunning]];
                
                contestDetails.runningContest = contest;
                audioChunk.contestDetails = contestDetails;
                
                //if contest id is valid then the running contest is true
                if (contest.contestID > 0)
                    audioChunk.isContestRunning = TRUE;
                else
                    audioChunk.isContestRunning = FALSE;
            }
        }
        else
        {
            //contest_detail
            // for now the contest deatils would be nil in this version. As the winner is not going to announce as per the previous flow.
            // Winner will be judge by the coca-cola by looking the collaborators
            if (![[dictAudio objectForKey:ApiKeySongContestDetails] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongContestDetails] != nil) {
                
                ContestDetails *contestDetails = [self getContestDetailsFromData:[dictAudio objectForKey:ApiKeySongContestDetails]];
                audioChunk.contestDetails = contestDetails;
                
                //if contest id is valid then the running contest is true
                if (audioChunk.contestDetails.runningContest.contestID > 0)
                    audioChunk.isContestRunning = TRUE;
                else
                    audioChunk.isContestRunning = FALSE;
            }
        }
        
        //--- CONTEST ENDS ---//
        
        //created_at
        if (![[dictAudio objectForKey:ApiKeySongCreatedAt] isKindOfClass:[NSNull class]] && [dictAudio objectForKey:ApiKeySongCreatedAt] != nil) {
            audioChunk.createdAt = [Utilities changeTheDateFormat:[dictAudio objectForKey:ApiKeySongCreatedAt]];
        }
        else {
            audioChunk.createdAt = @"";
        }
        
        //description
        if (![[dictAudio objectForKey:ApiKeySongDescription] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongDescription] != nil) {
            audioChunk.audioDescription = [dictAudio objectForKey:ApiKeySongDescription];
        }
        
        //duration
        if (![[dictAudio objectForKey:ApiKeySongDuration] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongDuration] != nil) {
            audioChunk.duration = [[dictAudio objectForKey:ApiKeySongDuration] integerValue];
        }
        
        //featured
        if (![[dictAudio objectForKey:ApiKeySongIsFeatured] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongIsFeatured] != nil) {
            audioChunk.isFeatured = [[dictAudio objectForKey:ApiKeySongIsFeatured] boolValue];
        }
        
        //id
        if (![[dictAudio objectForKey:ApiKeySongId] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongId] != nil) {
            audioChunk.audioID = [[dictAudio objectForKey:ApiKeySongId] integerValue];
        }
        
        //image
        if (![[dictAudio objectForKey:ApiKeySongImage] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongImage] != nil) {
            Image *audioImage = [self getImageFromData:[dictAudio objectForKey:ApiKeySongImage]];
            audioChunk.image = audioImage;
        }
        
        //is_liked
        if (![[dictAudio objectForKey:ApiKeySongIsLiked] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongIsLiked] != nil) {
            audioChunk.isLiked = [[dictAudio objectForKey:ApiKeySongIsLiked] boolValue];
        }
        
        //is_reposted
        if (![[dictAudio objectForKey:ApiKeySongIsReposted] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongIsReposted] != nil) {
            audioChunk.isReposted = [[dictAudio objectForKey:ApiKeySongIsReposted] boolValue];
        }
        
        //likes
        if (![[dictAudio objectForKey:ApiKeySongLikes] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongLikes] != nil) {
            audioChunk.likes = [[dictAudio objectForKey:ApiKeySongLikes] integerValue];
        }
        
        //links
        if (![[dictAudio objectForKey:ApiKeySongLinks] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongLinks] != nil) {
            audioChunk.links = [self getLinksFromData:[dictAudio objectForKey:ApiKeySongLinks]];
        }
        
        //media_format
        if (![[dictAudio objectForKey:ApiKeySongMediaFormat] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongMediaFormat] != nil) {
            audioChunk.mediaFormat = [dictAudio objectForKey:ApiKeySongMediaFormat];
        }
        
        //name
        if (![[dictAudio objectForKey:ApiKeySongName] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongName] != nil) {
            audioChunk.audioName = [dictAudio objectForKey:ApiKeySongName];
        }
        
        //parent
        if (![[dictAudio objectForKey:ApiKeySongParent] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongParent] != nil) {
            NSDictionary *parentDict = [dictAudio objectForKey:ApiKeySongParent];
            Audio *parentAudio = [self getAudioFromData:parentDict];
            audioChunk.parent = parentAudio;
        }
        
        //plays
        if (![[dictAudio objectForKey:ApiKeySongPlays] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongPlays] != nil) {
            audioChunk.plays = [[dictAudio objectForKey:ApiKeySongPlays] integerValue];
        }
        
        //repost
        if (![[dictAudio objectForKey:ApiKeySongRepost] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongRepost] != nil) {
            Repost *repost = [self getRepostFromData:[dictAudio objectForKey:ApiKeySongRepost]];
            audioChunk.repost = repost;
        }
        
        //reposts
        if (![[dictAudio objectForKey:ApiKeySongReposts] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongReposts] != nil) {
            audioChunk.reposts = [[dictAudio objectForKey:ApiKeySongReposts] integerValue];
        }
        
        //slug
        if (![[dictAudio objectForKey:ApiKeySongSlug] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongSlug] != nil) {
            audioChunk.slug = [dictAudio objectForKey:ApiKeySongSlug];
        }
        
        //song_url
        if (![[dictAudio objectForKey:ApiKeySongURL] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongURL] != nil) {
            NSString *strUrl = [[dictAudio objectForKey:ApiKeySongURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            audioChunk.songUrl = [NSURL URLWithString:strUrl];
        }
        
        //type
        if (![[dictAudio objectForKey:ApiKeySongFileExtension] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongFileExtension] != nil) {
            audioChunk.type = [dictAudio objectForKey:ApiKeySongFileExtension];
        }
        
        //user
        if (![[dictAudio objectForKey:ApiKeySongUser] isEqual:[NSNull null]] && [dictAudio objectForKey:ApiKeySongUser] != nil) {
            NSDictionary *userDict = [dictAudio objectForKey:ApiKeySongUser];
            User *user = [self getUserFromData:userDict];
            audioChunk.user = user;
        }
        
        return audioChunk;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse Comment Data

+(Comment *)getCommentsfromData:(NSDictionary *)dictComment {
    @try {
        Comment *comment = [Comment new];
        
        // body
        if (![[dictComment objectForKey:ApiKeyCommentBody] isEqual:[NSNull null]] && [dictComment objectForKey:ApiKeyCommentBody] != nil) {
            comment.body = [dictComment objectForKey:ApiKeyCommentBody];
        }
        
        //created_at
        if (![[dictComment objectForKey:ApiKeyCommentCreatedAt] isKindOfClass:[NSNull class]]  && [dictComment objectForKey:ApiKeyCommentCreatedAt] != nil) {
            comment.createdAt = [Utilities changeTheDateFormat:[dictComment objectForKey:ApiKeyCommentCreatedAt]];
        }
        else {
            comment.createdAt = @"";
        }
        
        //id
        if (![[dictComment objectForKey:ApiKeyCommentId] isEqual:[NSNull null]] && [dictComment objectForKey:ApiKeyCommentId] != nil) {
            comment.commentID = [[dictComment objectForKey:ApiKeyCommentId] integerValue];
        }
        
        //user
        if (![[dictComment objectForKey:ApiKeyCommentUser] isEqual:[NSNull null]] && [dictComment objectForKey:ApiKeyCommentUser] != nil) {
            NSDictionary *userDict = [dictComment objectForKey:ApiKeyCommentUser];
            User *user = [self getUserFromData:userDict];
            comment.user = user;
        }
        
        return comment;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse Social Accounts Data

+(SocialAccounts *)getSocialAccountfromData:(NSDictionary *)dictSocialAccount {
    @try {
        SocialAccounts *socialAccount = [SocialAccounts new];
        
        // name
        if (![[dictSocialAccount objectForKey:ApiKeySocialAccountName] isEqual:[NSNull null]] && [dictSocialAccount objectForKey:ApiKeySocialAccountName] != nil) {
            socialAccount.name = [dictSocialAccount objectForKey:ApiKeySocialAccountName];
        }
        
        // url
        if (![[dictSocialAccount objectForKey:ApiKeySocialAccountUrl] isEqual:[NSNull null]] && [dictSocialAccount objectForKey:ApiKeySocialAccountUrl] != nil) {
            socialAccount.url = [dictSocialAccount objectForKey:ApiKeySocialAccountUrl];
        }
        
        return socialAccount;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse user data

+(User *)getUserFromData:(NSDictionary *)dictUser {
    @try {
        User *user = [User new];
        // beats
        if (![[dictUser objectForKey:ApiKeyUserBeats] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserBeats] != nil) {
            user.beats = [[dictUser objectForKey:ApiKeyUserBeats] integerValue];
        }
        
        // tracks
        if (![[dictUser objectForKey:ApiKeyUserTracks] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserTracks] != nil) {
            user.tracks = [[dictUser objectForKey:ApiKeyUserTracks] integerValue];
        }
        
        // reposts
        if (![[dictUser objectForKey:ApiKeyUserReposts] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserReposts] != nil) {
            user.reposts = [[dictUser objectForKey:ApiKeyUserReposts] integerValue];
        }
        
        //bio
        if (![[dictUser objectForKey:ApiKeyUserBio] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserBio] != nil) {
            user.bio = [dictUser objectForKey:ApiKeyUserBio];
        }
        
        //email
        if (![[dictUser objectForKey:ApiKeyUserEmail] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserEmail] != nil) {
            user.email = [dictUser objectForKey:ApiKeyUserEmail];
        }
        
        // fans
        if (![[dictUser objectForKey:ApiKeyUserFans] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserFans] != nil) {
            user.fans = [[dictUser objectForKey:ApiKeyUserFans] integerValue];
        }
        
        // following
        if (![[dictUser objectForKey:ApiKeyUserFollowing] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserFollowing] != nil) {
            user.followings = [[dictUser objectForKey:ApiKeyUserFollowing] integerValue];
        }
        
        // user id
        if (![[dictUser objectForKey:ApiKeyUserId] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserId] != nil) {
            user.userId = [[dictUser objectForKey:ApiKeyUserId] integerValue];
        }
        
        //image
        if (![[dictUser objectForKey:ApiKeyUserImage] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserImage] != nil) {
            Image *userImage = [self getImageFromData:[dictUser objectForKey:ApiKeyUserImage]];
            user.userImage = userImage;
        }
        
        //is_following
        if (![[dictUser objectForKey:ApiKeyUserIsFollowing] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserIsFollowing] != nil) {
            user.isFollowing = [[dictUser objectForKey:ApiKeyUserIsFollowing] boolValue];
        }
        
        //is_verified
        if (![[dictUser objectForKey:ApiKeyUserIsVerified] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserIsVerified] != nil) {
            user.isVerified = [[dictUser objectForKey:ApiKeyUserIsVerified] boolValue];
        }
        
        //location
        if (![[dictUser objectForKey:ApiKeyUserLocation] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserLocation] != nil) {
            user.location = [dictUser objectForKey:ApiKeyUserLocation];
        }
        
        //auth_token
        if (![[dictUser objectForKey:ApiKeyUserAuthToken] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserAuthToken] != nil) {
            user.authToken = [dictUser objectForKey:ApiKeyUserAuthToken];
        }
        
        
        //username
        if (![[dictUser objectForKey:ApiKeyUserName] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserName] != nil) {
            user.userName = [dictUser objectForKey:ApiKeyUserName];
        }
        
        //screenname
        if (![[dictUser objectForKey:ApiKeyUserScreenName] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserScreenName] != nil) {
            user.screenName = [dictUser objectForKey:ApiKeyUserScreenName];
        }
        
        //social_accounts
        if (![[dictUser objectForKey:ApiKeyUserSocialAccounts] isEqual:[NSNull null]] && [dictUser objectForKey:ApiKeyUserSocialAccounts] != nil) {
            
            NSArray *socialAccountArrayData = (NSArray *)[dictUser objectForKey:ApiKeyUserSocialAccounts];
            NSMutableArray *socialAccountsArray = [NSMutableArray new];
            
            for (NSDictionary *dictSocialAccount in socialAccountArrayData) {
                SocialAccounts *socialAccount = [self getSocialAccountfromData:dictSocialAccount];
                [socialAccountsArray addObject:socialAccount];
            }
            user.socialAccounts = socialAccountsArray;
        }
        
        return user;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}



#pragma  mark - Parse Repost data

+(Repost *)getRepostFromData:(NSDictionary *)dictRepost {
    @try {
        Repost *rp = [Repost new];
        
        //reposted_at
        if (![[dictRepost objectForKey:ApiKeyRepostedAt] isKindOfClass:[NSNull class]]  && [dictRepost objectForKey:ApiKeyRepostedAt] != nil) {
            
            rp.repostedAt = @"";
        }
        else {
            rp.repostedAt = @"";
        }
        
        //user
        if (![[dictRepost objectForKey:ApiKeyCommentUser] isEqual:[NSNull null]] && [dictRepost objectForKey:ApiKeyCommentUser] != nil) {
            NSDictionary *userDict = [dictRepost objectForKey:ApiKeyCommentUser];
            User *user = [self getUserFromData:userDict];
            rp.user = user;
        }
        
        return rp;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse Image data

+(Image *)getImageFromData:(NSDictionary *)dictImage {
    @try {
        Image *userImage = [Image new];
        //hasimage
        if (![[dictImage objectForKey:ApiKeyHasImage] isEqual:[NSNull null]] && [dictImage objectForKey:ApiKeyHasImage] != nil) {
            userImage.hasImage = [[dictImage objectForKey:ApiKeyHasImage] boolValue];
        }
        //medium
        if (![[dictImage objectForKey:ApiKeyImageMedium] isEqual:[NSNull null]] && [dictImage objectForKey:ApiKeyImageMedium] != nil) {
            userImage.medium = [NSURL URLWithString:(NSString *)[dictImage objectForKey:ApiKeyImageMedium]] ;
        }
        //thumb
        if (![[dictImage objectForKey:ApiKeyImageThumb] isEqual:[NSNull null]] && [dictImage objectForKey:ApiKeyImageThumb] != nil) {
            userImage.thumb = [NSURL URLWithString:(NSString *)[dictImage objectForKey:ApiKeyImageThumb]] ;
        }
        //small
        if (![[dictImage objectForKey:ApiKeyImageSmall] isEqual:[NSNull null]] && [dictImage objectForKey:ApiKeyImageSmall] != nil) {
            userImage.small = [NSURL URLWithString:(NSString *)[dictImage objectForKey:ApiKeyImageSmall]] ;
        }
        return userImage;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse Contest details data

+(ContestDetails *)getContestDetailsFromData:(NSDictionary *)dictContestDetails {
    @try {
        ContestDetails *contestDetails = [ContestDetails new];
        //contest_result
        if (![[dictContestDetails objectForKey:ApiKeyContestDetailsResult] isEqual:[NSNull null]] && [dictContestDetails objectForKey:ApiKeyContestDetailsResult] != nil) {
            Contest *contest = [self getContestFromData:[dictContestDetails objectForKey:ApiKeyContestDetailsResult]];
            contestDetails.contestResults = contest;
        }
        //running_contest
        if (![[dictContestDetails objectForKey:ApiKeyContestDetailsRunning] isEqual:[NSNull null]] && [dictContestDetails objectForKey:ApiKeyContestDetailsRunning] != nil) {
            Contest *contest = [self getContestFromData:[dictContestDetails objectForKey:ApiKeyContestDetailsRunning]];
            contestDetails.runningContest = contest;
        }
        return contestDetails;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse Contest data

+(Contest *)getContestFromData:(NSDictionary *)dictContest {
    @try {
        Contest *contest = [Contest new];
        //advertising_info
        if (![[dictContest objectForKey:ApiKeyContestAdvertisingInfo] isEqual:[NSNull null]] && [dictContest objectForKey:ApiKeyContestAdvertisingInfo] != nil) {
            contest.advertisingInfo = [dictContest objectForKey:ApiKeyContestAdvertisingInfo];
        }
        //id
        if (![[dictContest objectForKey:ApiKeyContestId] isEqual:[NSNull null]] && [dictContest objectForKey:ApiKeyContestId] != nil) {
            contest.contestID = [[dictContest objectForKey:ApiKeyContestId] integerValue];
        }
        //name
        if (![[dictContest objectForKey:ApiKeyContestName] isEqual:[NSNull null]] && [dictContest objectForKey:ApiKeyContestName] != nil) {
            contest.contestName = [dictContest objectForKey:ApiKeyContestName];
        }
        //position
        if (![[dictContest objectForKey:ApiKeyContestPosition] isEqual:[NSNull null]] && [dictContest objectForKey:ApiKeyContestPosition] != nil) {
            contest.position = [[dictContest objectForKey:ApiKeyContestPosition] integerValue];
        }
        
        //tnc link
        if (![[dictContest objectForKey:ApiKeyContestTncLink] isEqual:[NSNull null]] && [dictContest objectForKey:ApiKeyContestTncLink] != nil) {
            contest.tnc = [NSURL URLWithString:[dictContest objectForKey:ApiKeyContestTncLink]];
        }
        
        //show banner or not
        // As per flow this needs to be for 2 cases. One for the beat for whom the contest is running. And the rest would be for the tracks uploaded under the contest. Which shows the winner of the contest as per the positions.
        if (contest.contestID > 0) {
            contest.haveBanner = TRUE;
        }
        
        return contest;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma  mark - Parse Links data

+(Link *)getLinksFromData :(NSDictionary *)dictLinks {
    @try {
        Link *link = [Link new];
        //self
        if (![[dictLinks objectForKey:ApiKeyLinkSelf] isEqual:[NSNull null]] && [dictLinks objectForKey:ApiKeyLinkSelf] != nil) {
            link.selfUrl = [NSURL URLWithString:(NSString *)[dictLinks objectForKey:ApiKeyLinkSelf]] ;
        }
        //share_image
        if (![[dictLinks objectForKey:ApiKeyLinkShareImage] isEqual:[NSNull null]] && [dictLinks objectForKey:ApiKeyLinkShareImage] != nil) {
            link.shareImage = [NSURL URLWithString:(NSString *)[dictLinks objectForKey:ApiKeyLinkShareImage]] ;
        }
        return link;
    }
    @catch (NSException *exception) {
        [MyAppLogException LogError:NSStringFromClass([self class]) methodName:NSStringFromSelector(_cmd) exception:exception];
    }
}

#pragma mark - Parse Dictionary Keys for value --- Beat/Track detail---- -

+(NSString*)parseDictForValue_AudioName:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"name"] isEqual:[NSNull null]] && [dict objectForKey:@"name"] != nil) {
        returnString = [[dict objectForKey:@"name"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    else
        returnString = @"";
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioSlug:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"slug"] isEqual:[NSNull null]] && [dict objectForKey:@"slug"] != nil) {
        returnString = [dict objectForKey:@"slug"];
    }
    else
        returnString = @"";
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioLikeCount:(NSDictionary*)dict {
    
    NSString *returnString;
    if (![[dict objectForKey:@"likes"] isEqual:[NSNull null]] && [dict objectForKey:@"likes"] != nil) {
        returnString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"likes"]];
    }
    else
        returnString = @"0";
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioCommentCount:(NSDictionary*)dict {
    
    NSString  *returnString;
    if (![[dict objectForKey:@"comments"] isEqual:[NSNull null]] && [dict objectForKey:@"comments"] != nil) {
        returnString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comments"]];
    }
    else
        returnString = @"0";
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioPlayCount:(NSDictionary*)dict {
    
    NSString *returnString;
    if (![[dict objectForKey:@"plays"] isEqual:[NSNull null]] && [dict objectForKey:@"plays"] != nil) {
        returnString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"plays"]];
    }
    else
        returnString = @"0";
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioShareCount:(NSDictionary*)dict {
    
    NSString *returnString;
    if (![[dict objectForKey:@"shares"] isEqual:[NSNull null]] && [dict objectForKey:@"shares"]!= nil) {
        returnString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shares"]];
    }
    else
        returnString = @"0";
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioRepostCount:(NSDictionary*)dict {
    
    NSString *returnString;
    if (![[dict objectForKey:@"reposts"] isEqual:[NSNull null]] && [dict objectForKey:@"reposts"]!= nil) {
        returnString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"reposts"]];
    }
    else
        returnString = @"0";
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioURL:(NSDictionary*)dict {
    
    NSString *returnString;
    if (![[dict objectForKey:@"song"] isEqual:[NSNull null]] && [dict objectForKey:@"song"] != nil) {
        
        returnString = [dict objectForKey:@"song"];
    }
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioType:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"audio_type"] isEqual:[NSNull null]] && [dict objectForKey:@"audio_type"] != nil) {
        
        returnString = [dict objectForKey:@"audio_type"];
    }
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioImage_Medium:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"image"] isEqual:[NSNull null]] && [dict objectForKey:@"image"] != nil) {
        
        id isKey = [dict objectForKey:@"image"];
        if ([isKey isKindOfClass:[NSDictionary class]]) {
            returnString = [[dict objectForKey:@"image"] objectForKey:@"medium"];
        }
        
        if ([returnString length]>0) {
            
            return returnString;
        }
        else
            return returnString=DEFAULT_SONG_IMAGE;
    }
    else {
        return returnString=DEFAULT_SONG_IMAGE;
    }
    
};

+(NSString*)parseDictForValue_AudioImage_Small:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"image"] isEqual:[NSNull null]] && [dict objectForKey:@"image"] != nil) {
        
        id isKey = [dict objectForKey:@"image"];
        if ([isKey isKindOfClass:[NSDictionary class]]) {
            returnString = [[dict objectForKey:@"image"] objectForKey:@"small"];
        }
        
        if ([returnString length]>0) {
            
            return returnString;
        }
        else
            return returnString=DEFAULT_SONG_IMAGE;
    }
    else {
        return returnString=DEFAULT_SONG_IMAGE;
    }
    
};

+(NSString*)parseDictForValue_ShareAudioImage:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"links"] isEqual:[NSNull null]] && [dict objectForKey:@"links"] != nil) {
        
        id isKey = [dict objectForKey:@"links"];
        if ([isKey isKindOfClass:[NSDictionary class]]) {
            returnString = [[dict objectForKey:@"links"] objectForKey:@"share_image"];
        }
        
        if ([returnString length]>0) {
            
            return returnString;
        }
        else
            return returnString=DEFAULT_SONG_IMAGE;
    }
    else {
        return returnString=DEFAULT_SONG_IMAGE;
    }
}

+(BOOL)parseDictForValue_Contest_Is_Running_DataAvailable:(NSDictionary*)dict {
    
    BOOL returnVal = FALSE;
    
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            returnVal = TRUE;
        }
        
        return returnVal;
    }
    else {
        return returnVal;
    }
    
};


+(BOOL)parseDictForValue_Contest_Is_Running:(NSDictionary*)dict {
    
    BOOL returnVal = FALSE;
    
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            NSNumber *contestId = [isValue objectForKey:@"id"];
            if (contestId.integerValue > 0) {
                returnVal = TRUE;
            }
        }
        
        return returnVal;
    }
    else {
        return returnVal;
    }
};

+(NSNumber*)parseDictForValue_Contest_ID:(NSDictionary*)dict {
    
    NSNumber *contestId;
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            contestId = [isValue objectForKey:@"id"];
            if (contestId.integerValue > 0) {
                return contestId;
            }
        }
        return contestId;
    }
    else {
        return contestId;
    }
};

+(NSString*)parseDictForValue_Contest_TnC:(NSDictionary*)dict {
    
    NSString *contesTnC=@"";
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            contesTnC =[NSString stringWithFormat:@"%@", [isValue objectForKey:@"tnc_link"]];
            if ([contesTnC length] > 0) {
                return contesTnC;
            }
        }else {
            return contesTnC;
        }
    }
    else {
        return contesTnC;
    }
    
};

+(BOOL)parseDictForValue_IsFeatured_Banner:(NSDictionary*)dict {
    
    if (![[dict objectForKey:@"featured"] isEqual:[NSNull null]] && [dict objectForKey:@"featured"] != nil) {
        NSNumber *isFeatured = [dict objectForKey:@"featured"];
        return isFeatured.boolValue;
    }
    else {
        return FALSE;
    }
};


+(NSString*)parseDictForValue_Running_Contest_Name:(NSDictionary*)dict {
    
    NSString *returnString = @"";
    
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            NSNumber *contestId = [isValue objectForKey:@"id"];
            if (contestId.integerValue > 0) {
                returnString = [NSString stringWithFormat:@"%@",[isValue objectForKey:@"name"]];
            }
        }
        
        return returnString;
    }
    else {
        return returnString;
    }
};


+(BOOL)parseDictForValue_Contest_Results_Banner_DataAvailable:(NSDictionary*)dict {
    
    BOOL returnVal = FALSE;
    
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            returnVal = TRUE;
        }
        
        return returnVal;
    }
    else {
        return returnVal;
    }
};

+(BOOL)parseDictForValue_Contest_Results_Banner:(NSDictionary*)dict {
    
    BOOL returnVal = FALSE;
    
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            NSNumber *contestId = [isValue objectForKey:@"id"];
            if (contestId.integerValue > 0) {
                NSNumber *position = [isValue objectForKey:@"show_banner"];
                returnVal = position.boolValue;
            }
        }
        
        return returnVal;
    }
    else {
        return returnVal;
    }
    
};


+(NSInteger)parseDictForValue_Contest_Results_Position:(NSDictionary*)dict {
    
    NSInteger returnVal = 0;
    
    if (![[[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] isEqual:[NSNull null]] && [[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] != nil) {
        
        id isValue = [[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"];
        if ([isValue isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)isValue allKeys] count] > 0)
        {
            NSNumber *contestId = [isValue objectForKey:@"id"];
            if (contestId.integerValue > 0) {
                NSNumber *position = [isValue objectForKey:@"position"];
                returnVal = position.integerValue;
            }
        }
        
        return returnVal;
    }
    else {
        return returnVal;
    }
};


+(NSString*)parseDictForValue_AudioID:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"id"] isEqual:[NSNull null]] && [dict objectForKey:@"id"] != nil) {
        
        returnString = [dict objectForKey:@"id"];
    }
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioDuration:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"duration"] isEqual:[NSNull null]] && [dict objectForKey:@"duration"] != nil) {
        returnString = [dict objectForKey:@"duration"];
    }
    
    return returnString;
};

+(BOOL)parseDictForValue_Audio_isLikeFlag:(NSDictionary*)dict {
    
    BOOL isLike=FALSE;
    if (![[dict objectForKey:@"is_liked"] isEqual:[NSNull null]] && [dict objectForKey:@"is_liked"] != nil) {
        isLike = [[dict objectForKey:@"is_liked"] boolValue];
    }
    
    return isLike;
};

+(NSString*)parseDictForValue_AudioDesc:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"description"] isEqual:[NSNull null]] && [dict objectForKey:@"description"] != nil) {
        
        if ([[dict objectForKey:@"description"] length]>0) {
            
            NSString *strDescription = [dict objectForKey:@"description"];
            strDescription= [strDescription stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            strDescription = [Utilities decodeUnicodeToEmojis:strDescription];
            returnString = strDescription;
        }
        else
            returnString = @"";
    }
    
    else
        returnString = @"";
    
    return returnString;
};

+(NSString*)parseDictForValue_Audio_AdvertisingInfo:(NSDictionary*)dict {
    NSString    *returnString=@"";
    
    if (![[[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] objectForKey:@"advertising_info"] isEqual:[NSNull null]] && [[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] objectForKey:@"advertising_info"] != nil)
    {
        returnString = [[[dict objectForKey:@"contest_detail"] objectForKey:@"running_contest"] objectForKey:@"advertising_info"];
        returnString= [returnString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    else if ([[[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] objectForKey:@"advertising_info"] != nil) {
        
        returnString = [[[dict objectForKey:@"contest_detail"] objectForKey:@"contest_result"] objectForKey:@"advertising_info"];
        returnString= [returnString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    
    return returnString;
}

+(NSString*)parseDictForValue_AudioCreatedAt:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"created_at"] isKindOfClass:[NSNull class]]  && [dict objectForKey:@"created_at"] != nil) {
        returnString = [Utilities shortTheDateFormat:[dict objectForKey:@"created_at"]];
    }
    else {
        returnString = @"";
    }
    
    return returnString;
};

+(NSString*)parseDictForValue_AudioProducer:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"parent"] isEqual:[NSNull null]] && [dict objectForKey:@"parent"] != nil) {
        
        // username
        if (![[[[dict objectForKey:@"parent"] objectForKey:@"user"] objectForKey:@"username"] isEqual:[NSNull null]] && [[[dict objectForKey:@"parent"] objectForKey:@"user"] objectForKey:@"username"] != nil) {
            
            // check if beat produced by logged in user
            NSString *loggedInUserID=(NSString *)[Utilities getUserIdFromUserDefaults];
            NSString *tmpUserID=[NSString stringWithFormat:@"%@",[[[dict objectForKey:@"parent"] objectForKey:@"user"] objectForKey:@"id"]];
            
            if ([loggedInUserID intValue]==[tmpUserID intValue]) {
                returnString=@"Me,";
            }
            else {
                returnString=[NSString stringWithFormat:@"%@,",[[[dict objectForKey:@"parent"] objectForKey:@"user"] objectForKey:@"username"]];
            }
        }
    }
    
    return returnString;
};

+(NSString*)parseDictForValue_Audio_Collaborators:(NSDictionary*)dict {
    
    NSString   *returnString;
    
    if (![[dict objectForKey:@"collaborators"] isEqual:[NSNull null]] &&
        [dict objectForKey:@"collaborators"] != nil) {
        
        // No Collaborators found
        if ([[[dict objectForKey:@"collaborators"] objectForKey:@"count"] intValue] == 0) {
            returnString=@"No Collaborators found";
        }
        else {
            
            NSArray *arr = [NSArray arrayWithArray:[[dict objectForKey:@"collaborators"] objectForKey:@"collaborators"]];
            
            NSMutableString *str = [[NSMutableString alloc] init];
            //[str appendString:@"Collaborators: "];
            for (int cnt=0 ; cnt<[arr count] ; cnt++) {
                [str appendString:[[arr objectAtIndex:cnt] objectForKey:@"name"]];
                if (cnt <[arr count]-1)
                    [str appendString:@", "];
            }
            returnString=str;
        }
    }
    return returnString;
}

+(NSDictionary*)parseDictForValue_Audio_ParentDict:(NSDictionary*)dict {
    
    NSDictionary    *returnDict;
    if (![[dict objectForKey:@"parent"] isEqual:[NSNull null]] && [dict objectForKey:@"parent"] != nil) {
        returnDict=[dict objectForKey:@"parent"];
    }
    return returnDict;
}

+(NSString*)parseDictForValue_Audio_ParentBeatID:(NSDictionary*)dict {
    
    NSString    *returnDict;
    if (![[dict objectForKey:@"parent"] isEqual:[NSNull null]] && [dict objectForKey:@"parent"] != nil) {
        if (![[[dict objectForKey:@"parent"] objectForKey:@"id"] isEqual:[NSNull null]] && [[dict objectForKey:@"parent"] objectForKey:@"id"] != nil)
        {
            returnDict=[[dict objectForKey:@"parent"] objectForKey:@"id"];
        }
    }
    return returnDict;
}

+(NSString*)parseDictForValue_Audio_BeatName:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"parent"] isEqual:[NSNull null]] && [dict objectForKey:@"parent"] != nil) {
        if (![[[dict objectForKey:@"parent"] objectForKey:@"name"] isEqual:[NSNull null]] && [[dict objectForKey:@"parent"] objectForKey:@"name"] != nil) {
            returnString = [[[dict objectForKey:@"parent"] objectForKey:@"name"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
    }
    return returnString;
}

+(NSDictionary*)parseDictForValue_ParentBeatUserDetail:(NSDictionary*)dict {
    
    NSDictionary   *ParentBeatUser;
    if (![[[dict objectForKey:@"parent"] objectForKey:@"user"] isEqual:[NSNull null]] && [[dict objectForKey:@"parent"] objectForKey:@"user"] != nil) {
        
        ParentBeatUser =[[dict objectForKey:@"parent"] objectForKey:@"user"];
    }
    return ParentBeatUser;
};

#pragma mark - Parsing for Audio User Detail -
+(NSDictionary*)parseDictForValue_Audio_User:(NSDictionary*)dict {
    
    NSDictionary   *audioUserDetail;
    if (![[dict objectForKey:@"user"] isEqual:[NSNull null]] && [dict objectForKey:@"user"] != nil) {
        audioUserDetail = [dict objectForKey:@"user"];
    }
    return audioUserDetail;
};

+(NSString*)parseDictForValue_AudioUserID:(NSDictionary*)dict {
    
    NSString    *userId;
    if (![[[dict objectForKey:@"user"] objectForKey:@"id"] isEqual:[NSNull null]] && [[dict objectForKey:@"user"] objectForKey:@"id"] != nil) {
        userId = [[dict objectForKey:@"user"] objectForKey:@"id"];
    }
    else {
        userId = @"";
    }
    return userId;
};

+(NSString*)parseDictForValue_AudioUserScreenName:(NSDictionary*)dict {
    
    NSString    *audioScreenName;
    if (![[[dict objectForKey:@"user"] objectForKey:@"screen_name"] isEqual:[NSNull null]] && [[dict objectForKey:@"user"] objectForKey:@"screen_name"] != nil) {
        audioScreenName = [[dict objectForKey:@"user"] objectForKey:@"screen_name"];
    }
    else {
        audioScreenName = @"";
    }
    return audioScreenName;
};

+(NSString*)parseDictForValue_AudioUserName:(NSDictionary*)dict {
    
    NSString    *audioUserName;
    if (![[dict objectForKey:@"user"] isEqual:[NSNull null]] && [dict objectForKey:@"user"] != nil) {
        
        NSString* audioUserid = [Parse parseDictForValue_AudioUserID:dict];
        if ([[Utilities getUserIdFromUserDefaults] integerValue] ==[audioUserid integerValue]) {
            audioUserName=[Utilities getUsernameFromUserDefaults];
            
        }else if (![[[dict objectForKey:@"user"] objectForKey:@"username"] isEqual:[NSNull null]] && [[dict objectForKey:@"user"] objectForKey:@"username"] != nil) {
            audioUserName = [[dict objectForKey:@"user"] objectForKey:@"username"];
        }
        else {
            audioUserName = @"";
        }
    }
    
    return audioUserName;
};

+(NSString*)parseDictForValue_AudioUserImage_Thumb:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[[dict objectForKey:@"user"] objectForKey:@"image"]  isEqual:[NSNull null]] && [[dict objectForKey:@"user"] objectForKey:@"image"]  != nil) {
        
        id isKey = [[dict objectForKey:@"user"] objectForKey:@"image"];
        if ([isKey isKindOfClass:[NSDictionary class]]) {
            returnString = [[[dict objectForKey:@"user"] objectForKey:@"image"] objectForKey:@"thumb"];
        }else if ([isKey isKindOfClass:[NSString class]] && [isKey isEqualToString:@"selfie"]) {
            returnString = isKey;
        }
        
        if ([returnString length]>0) {
            return returnString;
        }
        else
            return returnString=DEFAULT_USER_IMAGE;
    }
    else {
        return returnString=DEFAULT_USER_IMAGE;
    }
};

+(NSString*)parseDictForValue_AudioUserImage_Medium:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[[dict objectForKey:@"user"] objectForKey:@"image"]  isEqual:[NSNull null]] && [[dict objectForKey:@"user"] objectForKey:@"image"]  != nil) {
        
        id isKey = [[dict objectForKey:@"user"] objectForKey:@"image"];
        if ([isKey isKindOfClass:[NSDictionary class]]) {
            returnString = [[[dict objectForKey:@"user"] objectForKey:@"image"] objectForKey:@"medium"];
        }
        
        if ([returnString length]>0) {
            return returnString;
        }
        else
            return returnString=DEFAULT_USER_IMAGE;
    }
    else {
        return returnString=DEFAULT_USER_IMAGE;
    }
};

#pragma mark - Parse For User Location -
+(NSString*)parseDictForValue_User_Location:(NSDictionary*)dict {
    
    NSString    *returnString;
    if (![[dict objectForKey:@"location"] isEqual:[NSNull null]] && [dict objectForKey:@"location"] != nil) {
        
        NSString *strLocation=[dict objectForKey:@"location"];
        returnString = [strLocation stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
        NSData *data = [returnString dataUsingEncoding:NSUTF8StringEncoding];
        returnString = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        if ([returnString length]>0) {
            return returnString;
        }
        else {
            return returnString=@"";
        }
    }
    else {
        return returnString=@"";
    }
};

#pragma mark - Parsing for Contests Detail -
+(NSArray *)parseDictForValue_ContestTypes:(NSDictionary*)dict {
    
    NSArray   *arrContestTypes;
    if (![[dict objectForKey:@"contest_types"] isEqual:[NSNull null]] && [dict objectForKey:@"contest_types"] != nil) {
        arrContestTypes = [dict objectForKey:@"contest_types"];
    }
    return arrContestTypes;
};

+(NSString *)parseDictForValue_ContestType_VocalOrMusic:(NSDictionary*)dict {
    
    NSString   *strContestType;
    if (![[dict objectForKey:@"name"] isEqual:[NSNull null]] && [dict objectForKey:@"name"] != nil) {
        strContestType = [dict objectForKey:@"name"];
    }
    return strContestType;
};

+(NSString *)parseDictForValue_ContestType_Image:(NSDictionary*)dict {
    
    NSString   *strImage;
    if (![[dict objectForKey:@"image"] isEqual:[NSNull null]] && [dict objectForKey:@"image"] != nil) {
        strImage = [dict objectForKey:@"image"];
    }
    return strImage;
};

#pragma mark - Update Local Arrays

+(void) updateAllTabBarViewsLocalArrays :(NSString*) className {
    
    @try {
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        MyAppTabBarController *tabBarController = (MyAppTabBarController *)app.window.rootViewController.childViewControllers.lastObject;
        
        if([className isEqualToString:@"AllActivityViewController"])
        {
            //Explore View
            UINavigationController *navExploreView =  (UINavigationController*)[[tabBarController viewControllers] objectAtIndex:1];
            UIViewController *exploreView = [[navExploreView viewControllers] objectAtIndex:0];
        }
        else if([className isEqualToString:@"ExploreViewController"])
        {
            //AllActivity View
            UINavigationController *navAllActivity =  (UINavigationController*)[[tabBarController viewControllers] objectAtIndex:0];
            UIViewController *allActivity = [[navAllActivity viewControllers] objectAtIndex:0];
            
            if([allActivity isKindOfClass:[AllActivityViewController class]])
            {
                [APIClass sharedInstance].arrAllActivities = [self parseUpdateLocalArray:[APIClass sharedInstance].arrAllActivities];
            }
        }
        else if([className isEqualToString:@"FindBeatViewController"])
        {
            //AllActivity View
            UINavigationController *navAllActivity =  (UINavigationController*)[[tabBarController viewControllers] objectAtIndex:0];
            UIViewController *allActivity = [[navAllActivity viewControllers] objectAtIndex:0];
            
            if([allActivity isKindOfClass:[AllActivityViewController class]])
            {
                [APIClass sharedInstance].arrAllActivities = [self parseUpdateLocalArray:[APIClass sharedInstance].arrAllActivities];
            }
            
            //Explore View
            UINavigationController *navExploreView =  (UINavigationController*)[[tabBarController viewControllers] objectAtIndex:1];
            UIViewController *exploreView = [[navExploreView viewControllers] objectAtIndex:0];
        }
        else
        {
            //AllActivity View
            UINavigationController *navAllActivity =  (UINavigationController*)[[tabBarController viewControllers] objectAtIndex:0];
            UIViewController *allActivity = [[navAllActivity viewControllers] objectAtIndex:0];
            
            if([allActivity isKindOfClass:[AllActivityViewController class]])
            {
                [APIClass sharedInstance].arrAllActivities = [self parseUpdateLocalArray:[APIClass sharedInstance].arrAllActivities];
            }
            
            //Explore View
            UINavigationController *navExploreView =  (UINavigationController*)[[tabBarController viewControllers] objectAtIndex:1];
            UIViewController *exploreView = [[navExploreView viewControllers] objectAtIndex:0];
        }
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in updateAllTabBarViewsLocalArrays method...%@",[exception description]);
    }
}

+(void)parseUpdateSingletonDataModelArray:(NSMutableDictionary*)dictionary :(NSString*) className {
    
    @try {
        
        NSString *audioID = [dictionary objectForKey:@"AudioId"];
        
        if([[APIMyApp sharedInstance].arrUpdateLocalDataModels count] > 0)
        {
            bool audioExist = false;
            int index = 0;
            
            //Loop through singleton array which contain updated count & deleted beat/track details
            for(int i=0; i<[[APIMyApp sharedInstance].arrUpdateLocalDataModels count]; i++)
            {
                NSMutableDictionary *dic = [[APIMyApp sharedInstance].arrUpdateLocalDataModels objectAtIndex:i];
                
                NSString *audioID1 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AudioId"]];
                
                if([audioID intValue] == [audioID1 intValue])
                {
                    audioExist = true;
                    index = i;
                    
                    break;
                }
            }
            //parseDictForValue_Audio_isLikeFlag
            if(audioExist)
            {
                NSMutableDictionary *dic = [[[APIMyApp sharedInstance].arrUpdateLocalDataModels objectAtIndex:index] mutableCopy];
                
                bool bIsdeleted = false;
                if (![[dictionary objectForKey:@"IsDeleted"] isEqual:[NSNull null]] && [dictionary objectForKey:@"IsDeleted"] != nil) {
                    bIsdeleted = [[dictionary objectForKey:@"IsDeleted"] boolValue];
                    [dic setObject:[NSNumber numberWithBool: bIsdeleted] forKey:@"IsDeleted"];
                }
                
                bool bIsliked = false;
                if (![[dictionary objectForKey:@"IsLiked"] isEqual:[NSNull null]] && [dictionary objectForKey:@"IsLiked"] != nil) {
                    bIsliked = [[dictionary objectForKey:@"IsLiked"] boolValue];
                    [dic setObject:[NSNumber numberWithBool: bIsliked] forKey:@"IsLiked"];
                }
                
                
                int likeCount = 0;
                if (![[dictionary objectForKey:@"LikeCount"] isEqual:[NSNull null]] && [dictionary objectForKey:@"LikeCount"] != nil) {
                    likeCount = [[dictionary objectForKey:@"LikeCount"] intValue];
                    [dic setObject:[NSNumber numberWithInt: likeCount] forKey:@"LikeCount"];
                }
                
                int commentCount = 0;
                if (![[dictionary objectForKey:@"CommentCount"] isEqual:[NSNull null]] && [dictionary objectForKey:@"CommentCount"] != nil) {
                    commentCount = [[dictionary objectForKey:@"CommentCount"] intValue];
                    [dic setObject:[NSNumber numberWithInt: commentCount] forKey:@"CommentCount"];
                }
                
                int playCount = 0;
                if (![[dictionary objectForKey:@"PlayCount"] isEqual:[NSNull null]] && [dictionary objectForKey:@"PlayCount"] != nil) {
                    playCount = [[dictionary objectForKey:@"PlayCount"] intValue];
                    [dic setObject:[NSNumber numberWithInt: playCount] forKey:@"PlayCount"];
                }
                
                int shareCount = 0;
                if (![[dictionary objectForKey:@"ShareCount"] isEqual:[NSNull null]] && [dictionary objectForKey:@"ShareCount"] != nil) {
                    shareCount = [[dictionary objectForKey:@"ShareCount"] intValue];
                    [dic setObject:[NSNumber numberWithInt: shareCount] forKey:@"ShareCount"];
                }
                
                [[APIMyApp sharedInstance].arrUpdateLocalDataModels replaceObjectAtIndex:index withObject:dic];
            }
            else
            {
                [[APIMyApp sharedInstance].arrUpdateLocalDataModels addObject:dictionary];
            }
        }
        else
        {
            [[APIMyApp sharedInstance].arrUpdateLocalDataModels addObject:dictionary];
        }
        
        //Update counts and delete flag in all tab bar views local arrays
        [self updateAllTabBarViewsLocalArrays:className];
        
        //Clean singleton datamodel array
        [[APIMyApp sharedInstance].arrUpdateLocalDataModels removeAllObjects];
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in parseUpdateSingletonDataModelArray method...%@",[exception description]);
    }
}

+(NSMutableArray*)parseUpdateLocalArray:(NSMutableArray*)localArray {
    
    @try {
        
        if([[APIMyApp sharedInstance].arrUpdateLocalDataModels count] > 0)
        {
            //Loop through singleton array which contain updated count & deleted beat/track details
            for(int i=0; i<[[APIMyApp sharedInstance].arrUpdateLocalDataModels count]; i++)
            {
                NSMutableDictionary *dic = [[APIMyApp sharedInstance].arrUpdateLocalDataModels objectAtIndex:i];
                
                NSString *audioID =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"AudioId"]];
                
                for(int j=0; j<[localArray count]; j++)
                {
                    if([[localArray objectAtIndex:j] isKindOfClass:[NSMutableDictionary class]])
                    {
                        NSMutableDictionary *dd = [localArray objectAtIndex:j];
                        NSString *audioIDLocalArray = [Parse parseDictForValue_AudioID:dd];
                        
                        if([audioID intValue] == [audioIDLocalArray intValue])
                        {
                            bool bIsdeleted = [[dic objectForKey:@"IsDeleted"] boolValue];
                            
                            if(bIsdeleted)
                            {
                                [localArray removeObjectAtIndex:j];
                                j = (int)[localArray count];
                            }
                            else
                            {
                                NSMutableDictionary *localDict = [[localArray objectAtIndex:j] mutableCopy];
                                
                                bool bIsliked = false;
                                if (![[dic objectForKey:@"IsLiked"] isEqual:[NSNull null]] && [dic objectForKey:@"IsLiked"] != nil) {
                                    bIsliked = [[dic objectForKey:@"IsLiked"] boolValue];
                                    [localDict setObject:[NSNumber numberWithBool: bIsliked] forKey:@"is_liked"];
                                }
                                
                                int likeCount = 0;
                                if (![[dic objectForKey:@"LikeCount"] isEqual:[NSNull null]] && [dic objectForKey:@"LikeCount"] != nil) {
                                    likeCount = [[dic objectForKey:@"LikeCount"] intValue];
                                    [localDict setObject:[NSString stringWithFormat:@"%d",likeCount] forKey:@"likes"];
                                }
                                
                                int commentCount = 0;
                                if (![[dic objectForKey:@"CommentCount"] isEqual:[NSNull null]] && [dic objectForKey:@"CommentCount"] != nil) {
                                    commentCount = [[dic objectForKey:@"CommentCount"] intValue];
                                    [localDict setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"comments"];
                                }
                                
                                int playCount = 0;
                                if (![[dic objectForKey:@"PlayCount"] isEqual:[NSNull null]] && [dic objectForKey:@"PlayCount"] != nil) {
                                    playCount = [[dic objectForKey:@"PlayCount"] intValue];
                                    [localDict setObject:[NSString stringWithFormat:@"%d",playCount] forKey:@"plays"];
                                }
                                
                                int shareCount = 0;
                                if (![[dic objectForKey:@"ShareCount"] isEqual:[NSNull null]] && [dic objectForKey:@"ShareCount"] != nil) {
                                    shareCount = [[dic objectForKey:@"ShareCount"] intValue];
                                    [localDict setObject:[NSString stringWithFormat:@"%d",shareCount] forKey:@"shares"];
                                }
                                
                                [localArray replaceObjectAtIndex:j withObject:localDict];
                            }
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in parseUpdateLocalArray method...%@",[exception description]);
    }
    
    return localArray;
};

@end
