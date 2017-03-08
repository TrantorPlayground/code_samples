package com.myapp.socialapi;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookAuthorizationException;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookGraphResponseException;
import com.facebook.FacebookSdk;
import com.facebook.FacebookSdkNotInitializedException;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.LoggingBehavior;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.ShareApi;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.myapp.ApplicationStartPoint;
import com.myapp.datamodels.FaceBookUserObject;
import com.myapp.interfaces.ICallback;
import com.myapp.interfaces.ISocialAPI;
import com.myapp.presentation.BuildConfig;
import com.myapp.presentation.R;
import com.myapp.utils.Constants;
import com.myapp.utils.MyAppLogger;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;

/**
 * Facebook utility class to define all the Social API's tasks and returns callback to respective screen
 * Created by amit.thaper on 5/26/2016.
 *
 * @version 2.0
 */
public class FacebookUtils implements ISocialAPI, GraphRequest.GraphJSONObjectCallback, FacebookCallback {

    private Activity facebookContext;   //  Context to access the application UI components
    private CallbackManager facebookCallbackManager; // To handle the callbacks recieved from the override methods
    private AccessToken facebookAccessToken;    // access token used by the facebook API
    private ICallback facebookCallback;    // Interface to set the callback of success or failure of Social API calls
    private String feedTitleExemptedText = ".SE";    // String variable to set the feed title exempted text
    private String blank = "";    // String variable to set the feed title exempted text

    /**
     * Parameterized constructor to share the context within the class
     *
     * @param activity context file to access the view components
     */
    public FacebookUtils(Activity activity, ICallback fbCallback) {
        this.facebookContext = activity;
        this.facebookCallback = fbCallback;
    }

    public static void sdkInitialize(Activity activity) {
        if (!FacebookSdk.isInitialized()) { // facebook sdk is not initialized
            FacebookSdk.sdkInitialize(activity);
            if (BuildConfig.DEBUG) {
                FacebookSdk.setIsDebugEnabled(true);
                FacebookSdk.addLoggingBehavior(LoggingBehavior.INCLUDE_ACCESS_TOKENS);
            }
        } else { // facebook sdk is already initialized
            MyAppLogger.logInfo("Facebook SDK is already initialized");
        }
    }

    /**
     * Override Method to call the facebook login
     */
    @Override
    public void login() {
        try {
            FacebookUtils.sdkInitialize(facebookContext);
            facebookCallbackManager = CallbackManager.Factory.create(); // Create Facebook Callback Manager to use it in callback registration

            // Register login callback with facebookCallback manager and FacebookCallback<LoginResult>
            LoginManager.getInstance().logOut();
            LoginManager.getInstance().registerCallback(facebookCallbackManager, this);
            LoginManager.getInstance().logInWithPublishPermissions(facebookContext, Arrays.asList(Constants.FACEBOOK_REQUEST_ME_PERMISSIONS));   // Call for login feature
        } catch (Exception fbLoginException) {
            MyAppLogger.logError(ApplicationStartPoint.getAppContext(), fbLoginException,
                    FacebookUtils.class.getSimpleName());
        }
    }

    // Method to share the content over facebook
    @Override
    public void share(Uri imageUrl, String description, Uri postLink, String title) {
        try {
            String postTitle = title.replace(feedTitleExemptedText, blank);    // Replace .SE to prevent post to publish on facebook
            ShareLinkContent linkContent = new ShareLinkContent.Builder()
                    .setContentTitle(postTitle).setContentDescription(description)
                    .setContentUrl(postLink).setImageUrl(imageUrl).build();
            ShareApi.share(linkContent, this);
        } catch (Exception exception) {
            MyAppLogger.logError(ApplicationStartPoint.getAppContext(), exception, FacebookUtils.class.getSimpleName());
        }
    }

    /**
     * Method to check the user has the authorized the publish permission
     *
     * @return <b>true</b> if user has publish permission <br> </br>
     * <b>false</b> if user does not has publish permission
     */
    public boolean hasPublishPermission() {
        AccessToken accessToken = AccessToken.getCurrentAccessToken();
        return accessToken != null;
    }

    /**
     * Fetch the data from the social API's
     *
     * @return returns True if fetched successfully false in case of any error while fetch the result
     */
    @Override
    public boolean fetchLoggedInUserJSON() {
        try {
            facebookAccessToken = com.facebook.AccessToken.getCurrentAccessToken();
            if (facebookAccessToken != null && hasPublishPermission()) {
                // Create graph request for logged in user access and GraphRequest.GraphJSONObjectCallback
                GraphRequest newMeRequest = GraphRequest.newMeRequest(facebookAccessToken, FacebookUtils.this);
                Bundle parameters = new Bundle();
                parameters.putString(Constants.FACEBOOK_REQUEST_ME_KEY, Constants.FACEBOOK_REQUEST_ME_FIELDS);
                newMeRequest.setParameters(parameters);
                newMeRequest.executeAsync();
                return true;
            } else {
                // In case of no access token and no publish permission then return false
                return false;
            }
        } catch (Exception facebookFetchError) {
            MyAppLogger.logError(ApplicationStartPoint.getAppContext(),
                    facebookFetchError,
                    FacebookUtils.class.getSimpleName());
            return false;
        }
    }

    /**
     * Fetch the facebook callback manager instance registered
     *
     * @return
     */
    public CallbackManager getFacebookCallbackManager() {
        return facebookCallbackManager;
    }

    /**
     * Called when facebook newMe task is completed
     */
    @Override
    public void onCompleted(JSONObject object, GraphResponse userJSONResponse) {
        FaceBookUserObject faceBookShareObject = null;  //  FacebookUserObject to save the user object
        String userEmail = "";  // Variable to define the facebook email
        String userGender = ""; // Variable to save user gender
        String userId;  //  To save user id
        String userFullname;    // To save user first and last name parsed from the FB JSON
        try {
            if (userJSONResponse.getJSONObject() != null && userJSONResponse.getJSONObject().has(Constants.FACEBOOK_EMAIL)) {
                // When logged in user email is available
                userEmail = userJSONResponse.getJSONObject().getString(
                        Constants.FACEBOOK_EMAIL);
            }
            if (userJSONResponse.getJSONObject() != null && userJSONResponse.getJSONObject().has(Constants.FACEBOOK_GENDER)) {
                // When logged in user Gender is available
                userGender = userJSONResponse.getJSONObject().getString(
                        Constants.FACEBOOK_GENDER);
            }

            userId = userJSONResponse.getJSONObject().getString(Constants.FACEBOOK_ID);
            userFullname = userJSONResponse.getJSONObject().getString(
                    Constants.FACEBOOK_NAME);
            faceBookShareObject = new FaceBookUserObject(userFullname, userId, userEmail, userGender, facebookAccessToken.getToken().toString());
            MyAppLogger.logInfo("Facebook Utils " + userJSONResponse.toString());
        } catch (JSONException | NullPointerException jsonException) {
            // Logged the error in logcat and in rollbar
            MyAppLogger.logError(ApplicationStartPoint.getAppContext(),
                    jsonException,
                    FacebookUtils.class.getSimpleName());
            if (facebookCallback != null) {
                // when callback is initialized and not null then send the callback as share completed
                facebookCallback.onLoggedInCompleted(null, false);
            }
            return;
        }

        if (facebookCallback != null) {
            // when callback is initialized and not null then send the callback as share completed
            facebookCallback.onLoggedInCompleted(faceBookShareObject, true);
        }
    }

    /**
     * Called when facebook logInWithPublishPermissions task has been completed
     *
     * @param returnObject return data of login, share
     */
    @Override
    public void onSuccess(Object returnObject) {
        if (returnObject != null && returnObject instanceof Sharer.Result) {  // when user successfully shared the content over facebook
            Sharer.Result facebookShareObject = (Sharer.Result) returnObject;
            if (facebookShareObject.getPostId() != null) {
                try {
                    if (facebookCallback != null) { // If facebook callback interface is not null
                        facebookCallback.onSharedCompleted(facebookContext.getResources().getString(R.string.share_success_facebook), true); // Send message to interface
                    }
                } catch (Exception exception) {
                    MyAppLogger.logError(ApplicationStartPoint
                                    .getAppContext(), exception,
                            FacebookUtils.class.getSimpleName());
                    if (facebookCallback != null) { // If facebook callback interface is not null
                        facebookCallback.onSharedCompleted(facebookContext.getResources().getString(R.string.share_error_facebook), false); // Send message to interface
                    }
                }
            }
        } else if (returnObject != null && returnObject instanceof LoginResult) {  // when user successfully logged in
            fetchLoggedInUserJSON();
        }
        return;
    }

    /**
     * Called when user cancel the login popup window
     */
    @Override
    public void onCancel() {
        fetchLoggedInUserJSON();
        MyAppLogger.logInfo("Cancellation of the facebook login pop up window.");
    }

    /**
     * Called when there is any error while logging into the facebook application
     */
    @Override
    public void onError(FacebookException error) {
        MyAppLogger.logError(ApplicationStartPoint.getAppContext(), error,
                FacebookUtils.class.getSimpleName());
        if (error instanceof FacebookAuthorizationException) {
            if (AccessToken.getCurrentAccessToken() != null) {
                LoginManager.getInstance().logOut();
                LoginManager.getInstance().logInWithPublishPermissions(facebookContext, Arrays.asList(Constants.FACEBOOK_REQUEST_ME_PERMISSIONS));   // Call for login feature
            }
        } else if (error instanceof FacebookGraphResponseException) {
            // If error comes while sharing content on facebook
            LoginManager.getInstance().logInWithPublishPermissions(facebookContext, Arrays.asList(Constants.FACEBOOK_REQUEST_ME_PERMISSIONS));   // Call for login feature
        } else if (error instanceof FacebookSdkNotInitializedException) {
            // when callback is initialized and not null then send the callback as login completed with error
            facebookCallback.onLoggedInCompleted(null, false);
        } else if (facebookCallback != null) {
            // when callback is initialized and not null then send the callback as login completed with error
            facebookCallback.onLoggedInCompleted(null, false);
        }
    }
}
