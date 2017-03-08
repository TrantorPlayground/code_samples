package com.myapp.receivers;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;

import com.myapp.datamodels.MessageForGeneralResponse;
import com.myapp.interfaces.IReceiverCallBack;
import com.myapp.network.ParsedResponse;
import com.myapp.network.ResponseStatus;
import com.myapp.network.MyAppUrls;
import com.myapp.presentation.R;
import com.myapp.utils.Constants;
import com.myapp.utils.MyAppLogger;

import java.util.Arrays;

/**
 * Class APIResponseReceiver extends BroadcastReceiver
 * To handle network response broadcasts or callbacks
 * Created by deepak.sachdeva on 6/9/2016.
 */
public class APIResponseReceiver extends BroadcastReceiver {

    private IReceiverCallBack receiverCallBack; // Interface uses to send ParsedResponse

    private String[] apiActionsArray = {MyAppUrls.FILTER_BR_NEWS_FEEDS, //Home news feeds response
            MyAppUrls.FILTER_BR_POPULAR_BEATS, //Popular beats response
            MyAppUrls.FILTER_BR_EXPAND_BEAT, //Expand View detail of Popular beats
            MyAppUrls.FILTER_BR_GET_LIKERS, //Liker List
            MyAppUrls.FILTER_BR_FORGOT_PASSWORD, //Reset Password
            MyAppUrls.FILTER_BR_GET_USER_PROFILE, //Get user Profile
            MyAppUrls.FILTER_BR_LOGOUT, //Logout user from myapp
            MyAppUrls.FILTER_BR_GET_BEATS, //get beats from myapp
            MyAppUrls.FILTER_BR_GET_TRACKS, //get tracks from myapp
            MyAppUrls.FILTER_BR_GET_REPOSTS, //get reposts from myapp
            MyAppUrls.FILTER_BR_EXPLORE_SEARCH_BEAT, //get explore beats from myapp
            MyAppUrls.FILTER_BR_EXPLORE_SEARCH_TRACK, //get explore tracks from myapp
            MyAppUrls.FILTER_BR_SEARCH_USER, //get explore users from myapp
            MyAppUrls.FILTER_BR_EXPLORE_SEARCH_HASHTAG, // get explore tags from myapp
            MyAppUrls.FILTER_BR_SEARCH_HASHTAGS, // get explore tags from myapp
            MyAppUrls.FILTER_BR_CHANGE_PASS, // To change password
            MyAppUrls.FILTER_BR_LOCATION_LIBRARY, // To get location from google library
            MyAppUrls.FILTER_BR_GET_NOTIFICATION, //get notifications for user account
            MyAppUrls.FILTER_BR_MARK_READ_NOTIFI, //Mark notifications as read
            MyAppUrls.FILTER_BR_EDIT_USER, // to edit user profile
            MyAppUrls.FILTER_BR_UPLOAD_BEAT, // To beat upload
            MyAppUrls.FILTER_BR_UPLOAD_TRACK, // To track upload
            MyAppUrls.FILTER_BR_GET_REPOSTERS, // To get list of reposters
            MyAppUrls.FILTER_BR_DELETE_BEAT, // To delete beat of feed
            MyAppUrls.FILTER_BR_RECOMMENDED_USER, // To get Follow list for Getting started Flow
            MyAppUrls.FILTER_BR_GET_GENRES, // To get Genres
            MyAppUrls.FILTER_BR_ADD_GENRES_USER, // To add Genres
            MyAppUrls.FILTER_BR_USER_DEACTIVATE, // To deactivate account
            MyAppUrls.FILTER_BR_FOLLOW_USER, // To follow user
            MyAppUrls.FILTER_BR_UNFOLLOW_USER, // To unfollow user
            MyAppUrls.FILTER_BR_FANS_USER, // To get fans
            MyAppUrls.FILTER_BR_FOLLOW_LIST_USER, // To get Followers
            MyAppUrls.FILTER_BR_GET_FLAG_CATEGORY, // To get flag categories
            MyAppUrls.FILTER_BR_FLAG_AUDIO, // To flag and audio or video
            MyAppUrls.FILTER_BR_GET_PUSH_NOTIFI, // To get push notification settings
            MyAppUrls.FILTER_BR_PUT_PUSH_NOTIFI, // To add push notification settings
            MyAppUrls.FILTER_BR_GET_COLLABORATORS, //To Get beat collaborators
            MyAppUrls.FILTER_BR_GET_PRESET, //To Get presets
            MyAppUrls.FILTER_BR_AUDIO_SHARE_COUNT, // Update Share count
            MyAppUrls.FILTER_BR_CHANGE_ALBUM_ART, //To change image of media
            MyAppUrls.FILTER_BR_RUNNING_CONTESTS
    };

    /**
     * Receiver constructor for object inialization
     *
     * @param receiverCallback receiver callback for handling UI layer
     */
    public APIResponseReceiver(IReceiverCallBack receiverCallback) {
        this.receiverCallBack = receiverCallback;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            String intentAction = intent.getAction();
            MyAppLogger.logInfo("onReceive() -> Action: " + intent.getAction());
            // Get Intent extras
            Bundle intentExtrasBundle = intent.getExtras();
            if (intentExtrasBundle != null) {
                //Common parcelable object of response data
                ParsedResponse mParsedResponse = intentExtrasBundle.getParcelable(Constants.METADATA_RESULT_BUNDLE_TAG);
                // Check the type of broadcast intent received using Filters
                if (mParsedResponse != null && Arrays.asList(apiActionsArray).contains(intentAction)) { // Get user Profile

                    Constants.NetworkStatus errorCode = mParsedResponse.getErrorCode();

                    // Check the response, if successful or not
                    if (Constants.NetworkStatus.NO_ERROR == errorCode && ResponseStatus.SUCCESS == mParsedResponse.getResponseCode()) {
                        if (intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_LOCATION_LIBRARY)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_DELETE_BEAT)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_FOLLOW_USER)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_UNFOLLOW_USER)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_CHANGE_ALBUM_ART)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_EXPLORE_SEARCH_BEAT)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_EXPLORE_SEARCH_TRACK)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_SEARCH_USER)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_EXPLORE_SEARCH_HASHTAG)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_GET_BEATS)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_GET_TRACKS)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_AUDIO_SHARE_COUNT)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_UPLOAD_BEAT)
                                || intent.getAction().equalsIgnoreCase(MyAppUrls.FILTER_BR_UPLOAD_TRACK)) {
                            receiverCallBack.onSuccess(mParsedResponse);// send data to fragment using interface
                        } else {
                            //Request Successful
                            Parcelable parcelableData = mParsedResponse.getData();
                            if (null != parcelableData) {  //Check if data object is present
                                receiverCallBack.onSuccess(parcelableData);// send data to fragment using interface
                            }
                        }
                    } else if (Constants.NetworkStatus.LOW_INTERNET_CONNECTION == errorCode //Failed due to an exception in request execution
                            || Constants.NetworkStatus.NO_INTERNET_CONNECTION == errorCode) { //Failed due to no internet connection
                        receiverCallBack.onError(context.getResources().getString(R.string.check_internet), errorCode);
                    } else if (Constants.NetworkStatus.SERVER_RESPONSE_EQUAL_TO_404 == errorCode) { //Failed due to some entity in web request is not present in server database
                        Parcelable parcelableData = mParsedResponse.getData();
                        if (null != parcelableData) {//Check if Parcelable object is present
                            receiverCallBack.onError(parcelableData, errorCode);
                        }
                    } else if (Constants.NetworkStatus.INTERNAL_SERVER_ERROR == errorCode) {
                        receiverCallBack.onError(context.getResources().getString(R.string.Internal_server_error), errorCode);
                    } else {
                        Parcelable errorParcelableData = mParsedResponse.getData();
                        if (null != errorParcelableData) {  //Check if data object is present
                            // send error data to fragment using interface
                            if (errorParcelableData instanceof MessageForGeneralResponse) {
                                receiverCallBack.onError(((MessageForGeneralResponse) errorParcelableData).getMessage(), errorCode);
                            } else {
                                receiverCallBack.onError(errorParcelableData, errorCode);
                            }
                        }
                    }
                }
            }
        } catch (Exception pickABeatRecevierException) {
            MyAppLogger.logError(context,
                    pickABeatRecevierException,
                    APIResponseReceiver.class.getSimpleName());

        }
    }
}
