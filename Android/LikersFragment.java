package com.myapp.fragments;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.myapp.ApplicationStartPoint;
import com.myapp.adapters.LikerListAdapter;
import com.myapp.analytics.MixPanelAnalytics;
import com.myapp.datamodels.LikerListResponse;
import com.myapp.datamodels.MessageForGeneralResponse;
import com.myapp.datamodels.UserProfile;
import com.myapp.interfaces.IOnLoadMoreListener;
import com.myapp.interfaces.IReceiverCallBack;
import com.myapp.network.ParsedResponse;
import com.myapp.network.MyAppUrls;
import com.myapp.network.WebUtils;
import com.myapp.presentation.DividerItemDecoration;
import com.myapp.presentation.R;
import com.myapp.receivers.APIResponseReceiver;
import com.myapp.receivers.FollowUnfollowReceiver;
import com.myapp.utils.Constants;
import com.myapp.utils.MyAppLogger;
import com.myapp.utils.UIUtils;
import com.myapp.utils.Util;

import java.util.ArrayList;
import java.util.List;

/**
 * Fragment class to display the list of liker of feeds
 * Created by amit.thaper on 6/14/2016.
 *
 * @version 2.0
 */
public class LikersFragment extends BaseFragment implements IReceiverCallBack, SwipeRefreshLayout.OnRefreshListener, IOnLoadMoreListener {
    private View likersRootView; //parent layout for liker list fragment
    private RecyclerView recyclerLikerList; //RecyclerView to list the liker of feed
    private LikerListAdapter likerListAdapter; //Adapter to bind with RecyclerView
    private WebUtils myappAPI; //Web utils object to access Web services
    private List<UserProfile> userProfileList;  // List for the user profile of liker
    private APIResponseReceiver likerListReciever;    // Reciver to set the intent action for the default broadcast receiver
    private int mediaId;    // media id to fetch the liker list
    private LinearLayoutManager recyclerViewLayoutManager; //  use to set in recycler view's layout
    private int refreshOffset = 0;  // Offset to call the liker list API
    private int loadMoreOffset = 0; // Offset to get more older data from the liker list API
    private SwipeRefreshLayout swipeRefreshLayoutLiker; //RecyclerView for listing the liker in Feeds liker list on  HomeFragment
    private int visibleThreshold = 5;
    private int lastVisibleItem; // gives the last visible Item of recyclerview
    private int totalItemCount; // gives the total visible Item of recyclerview
    private boolean isRefresh = false;  // Flag for pull to refresh
    private boolean isLoadMore = false; // Flag for load more
    private ProgressBar loadingProgress;
    private int userListCount;  // Total count for the users
    private boolean isFirstTimeLoad = true;
    private static final String likesTitle = " Likers";
    private static final String repostsTitle = " Reposters";
    private static final String fansTitle = " Fans";
    private static final String followersTitle = " Following";
    private String listType = Constants.BLANK;    // type of list(likers or reposters) to fetch the liker or reposter list
    private int userId = -1;
    private int selectedTabIndex;
    private FollowUnfollowReceiver followUnfollowReceiver;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup pickABeatViewGroupContainer, Bundle savedInstanceState) {
        likersRootView = inflater.inflate(R.layout.fragment_liker_list, pickABeatViewGroupContainer, false);
        getArgumentsData();
        initializeLayout();
        initializeListeners();
        registerLikerListReceiver();
        initializeGlobalVariables();
        return likersRootView;
    }

    /**
     * Initialize the layout files used in the fragment
     */
    private void initializeLayout() {
        recyclerLikerList = (RecyclerView) likersRootView.findViewById(R.id.rv_getting_started_follow);
        swipeRefreshLayoutLiker = (SwipeRefreshLayout) likersRootView.findViewById(R.id.swipe_refresh_layout_likers);
        loadingProgress = (ProgressBar) likersRootView.findViewById(R.id.progress_bar_likerlist);
        recyclerViewLayoutManager = new LinearLayoutManager(mMyAppTabsActivity);
        recyclerLikerList.setLayoutManager(recyclerViewLayoutManager);
        recyclerLikerList.setItemAnimator(new DefaultItemAnimator());
        recyclerLikerList.addItemDecoration(new DividerItemDecoration(ContextCompat.getDrawable(getActivity(), R.drawable.recycler_view_drawable)));
    }

    /**
     * Initialize the global variables used in this fragment class
     */
    private void initializeGlobalVariables() {
        myappAPI = new WebUtils();
        if (userProfileList == null) {
            userProfileList = new ArrayList<>();
            likerListAdapter = new LikerListAdapter(mMyAppTabsActivity, userProfileList, selectedTabIndex);
            recyclerLikerList.setAdapter(likerListAdapter);
            callLikerListAPI(Constants.DEFAULT_API_LIMIT_PARAM, refreshOffset);
        } else {
            likerListAdapter = new LikerListAdapter(mMyAppTabsActivity, userProfileList, selectedTabIndex);
            recyclerLikerList.setAdapter(likerListAdapter);
        }
    }

    /**
     * Initialize listeners to required components
     */
    private void initializeListeners() {
        // to refresh the recycler view
        swipeRefreshLayoutLiker.setOnRefreshListener(this);
        recyclerLikerList.addOnScrollListener(new RecyclerView.OnScrollListener() {

            @Override
            public void onScrolled(RecyclerView recyclerView, int horizontalScroll, int verticalScroll) {
                super.onScrolled(recyclerView, horizontalScroll, verticalScroll);
                try {
                    totalItemCount = recyclerViewLayoutManager.getItemCount(); // gives the total visible item in recycler view
                    lastVisibleItem = recyclerViewLayoutManager.findLastVisibleItemPosition(); // gives the last visible item in recycler view
                    if (!isFirstTimeLoad && !likerListAdapter.getLoaded()
                            && userProfileList.size() < userListCount && totalItemCount <= (lastVisibleItem + visibleThreshold)) { // check loader is visible and execute the load more condition
                        onLoadMore();
                        likerListAdapter.setLoaded(true); // to show the loader is visible
                    }
                    isFirstTimeLoad = false;
                } catch (Exception onScrolledException) {
                    MyAppLogger.logError(ApplicationStartPoint.getAppContext(),
                            onScrolledException,
                            PickABeatFragment.class.getSimpleName());
                }
            }
        });
    }

    /**
     * Method to get the arguments passed with the fragment
     */
    private void getArgumentsData() {
        mediaId = getArguments().getInt(Constants.INTENT_MEDIA_ID_TAG, -1);
        listType = getArguments().getString(Constants.LIST_TYPE);
        userId = getArguments().getInt(Constants.USER_ID_KEY);
        selectedTabIndex = getArguments().getInt(Constants.INTENT_PARENT_TAB);
        updateActionBarTitle(getToolbarTitle(listType));
    }

    /**
     * Register broadcast receiver for handling liker list API Response
     */
    private void registerLikerListReceiver() {
        try {
            if (null == likerListReciever) {// check for null (receiver already register)
                likerListReciever = new APIResponseReceiver(this);
                Util.getIntentFilterWith(mMyAppTabsActivity, likerListReciever, true, new String[]{
                        MyAppUrls.FILTER_BR_GET_LIKERS, MyAppUrls.FILTER_BR_GET_REPOSTERS,
                        MyAppUrls.FILTER_BR_FOLLOW_USER, MyAppUrls.FILTER_BR_UNFOLLOW_USER,
                        MyAppUrls.FILTER_BR_FANS_USER, MyAppUrls.FILTER_BR_FOLLOW_LIST_USER});
            }

            // check if countsUpdateReceiver already registered
            if (null == followUnfollowReceiver) {
                followUnfollowReceiver = new FollowUnfollowReceiver(getActivity());
                Util.getIntentFilterWith(getActivity(), followUnfollowReceiver, true, new String[]{
                        Constants.FollowUnfollowActionType.FOLLOW,
                        Constants.FollowUnfollowActionType.UNFOLLOW});
            }
        } catch (Exception registerReceiverException) {
            MyAppLogger.logError(ApplicationStartPoint.getAppContext(),
                    registerReceiverException,
                    LikersFragment.class.getSimpleName());
        }
    }

    /**
     * Unregister broadcast receiver when fragment destroy
     */
    private void unRegisterLikerListReceiver() {
        try {
            unRegisterReceiver(likerListReciever);
            unRegisterReceiver(followUnfollowReceiver);

            likerListReciever = null;
            followUnfollowReceiver = null;
        } catch (Exception unRegisterReceiverException) {
            MyAppLogger.logError(ApplicationStartPoint.getAppContext(),
                    unRegisterReceiverException,
                    PickABeatFragment.class.getSimpleName());
        }
    }

    /**
     * Unregisters a local broadcast from utility method call
     *
     * @param broadcastReceiver the receiver to be unregitered
     */
    private void unRegisterReceiver(BroadcastReceiver broadcastReceiver) {
        // check if avDetailWebRequestRecevier already registered
        if (broadcastReceiver != null) {
            Util.unRegisterLocalBroadCastReceiver(getActivity(), broadcastReceiver);
        }
    }


    /**
     * Call the web api to fetch the liker list
     */
    private void callLikerListAPI(int limit, int offset) {
        if (Util.isInternetConnectionAvaliable(mMyAppTabsActivity)) { // Check if internet connection available
            if (!isLoadMore && !isRefresh)
                loadingProgress.setVisibility(View.VISIBLE);
            if (listType.equalsIgnoreCase(Constants.FOLLOWING) || listType.equalsIgnoreCase(Constants.FANS)) {
                myappAPI.getFanOrFollowerOfUser(getActivity(), userId,
                        limit, offset, listType);
            } else {
                myappAPI.getLikerList(getActivity(), mediaId, offset, limit, listType);
            }
        } else {//No internet connection available
            UIUtils.showSnackBar(activityRootLayout, getString(R.string.no_internet_connection));
            if (isRefresh) { // If pull to refresh is active
                swipeRefreshLayoutLiker.setRefreshing(false);
            } else if (isLoadMore) { // If load more is active
                loadingProgress.setVisibility(View.GONE);
                userProfileList.remove(userProfileList.size() - 1);
                likerListAdapter.notifyItemRemoved(userProfileList.size());
                likerListAdapter.setLoaded(false);
            }
        }

    }

    /**
     * Method to set the title with title string
     *
     * @param likerTitle title with the number of likers for the feed
     */
    private void updateActionBarTitle(String likerTitle) {
        //Get the default action bar and update view data
        ActionBar actionBar = mMyAppTabsActivity.getSupportActionBar();
        if (actionBar != null) {// Check if action bar is visible
            actionBar.setDisplayHomeAsUpEnabled(true);//To display back button
            actionBar.setIcon(null);
            if (mToolbar != null) {
                TextView toolbarTextView = (TextView) mToolbar.findViewById(R.id.toolbar_title);
                toolbarTextView.setSelected(true);
                toolbarTextView.setText(likerTitle);
            } else {
                actionBar.setTitle(Constants.BLANK);
            }
        }
    }

    @Override
    public void onDestroy() {
        unRegisterLikerListReceiver();
        super.onDestroy();
    }

    @Override
    public void onSuccess(Object parseableObject) {
        if (parseableObject instanceof ParsedResponse) {
            likerListAdapter.updateData();
            ParsedResponse parsedResponse = (ParsedResponse) parseableObject; // get user response to set data in profile view
            MessageForGeneralResponse messageObject = (MessageForGeneralResponse) parsedResponse.getData();
            String message = messageObject.getMessage();
            String followerId = parsedResponse.getReqId().getParentId().getId();
            if (message != null && message.equalsIgnoreCase(Constants.SUCCESS_KEY)) {
                if (parsedResponse.getReqId().toString().equals(MyAppUrls.ID_CALL_FOLLOW_USER)) {
                    String followerUserId = parsedResponse.getReqId().getParentId().getId();
                    String followerScreenName = parsedResponse.getReqId().getParentId().getParentId().getId();
                    String followerUserName = parsedResponse.getReqId().getParentId().getParentId().getParentId().getId();
                    MixPanelAnalytics.trackEventFollowUserToMixPanel(followerScreenName, followerUserName, Integer.valueOf(followerUserId));
                }
            }

            Intent followUnfollowIntent = new Intent(Constants.FollowUnfollowActionType.FOLLOW);
            Bundle followUnfollowUpdateBundle = new Bundle();
            followUnfollowUpdateBundle.putInt("followed_id", Integer.parseInt(followerId));
            followUnfollowUpdateBundle.putString("action_type", parsedResponse.getReqId().toString());
            followUnfollowIntent.putExtras(followUnfollowUpdateBundle);
            LocalBroadcastManager.getInstance(getActivity()).sendBroadcast(followUnfollowIntent);

        } else if (parseableObject instanceof LikerListResponse) {
            if (!isRefresh && !isLoadMore) {   // If pull to refresh and load more is not active
                LikerListResponse apiResponse = (LikerListResponse) parseableObject;
                List<UserProfile> parsedUserProfileList = getListData(apiResponse);

                for (UserProfile user : parsedUserProfileList) {
                    if (!userProfileList.contains(user)) { // If user already in list
                        userProfileList.add(user);
                    }
                }
                likerListAdapter.notifyDataSetChanged();
                loadingProgress.setVisibility(View.GONE);
                userListCount = apiResponse.getTotalCount();
                updateActionBarTitle(getToolbarTitle(listType));
            } else if (!isRefresh && isLoadMore) { // If load more is active
                LikerListResponse apiResponse = (LikerListResponse) parseableObject;
                List<UserProfile> parsedUserProfileList = getListData(apiResponse);
                userProfileList.remove(userProfileList.size() - 1);
                for (UserProfile user : parsedUserProfileList) {
                    if (!userProfileList.contains(user)) { // If user already in list
                        userProfileList.add(user);
                    }
                }
                likerListAdapter.notifyDataSetChanged();
                likerListAdapter.setLoaded(false);
                userListCount = apiResponse.getTotalCount();
                updateActionBarTitle(getToolbarTitle(listType));

            } else if (isRefresh && !isLoadMore) { // If pull to refresh is active
                swipeRefreshLayoutLiker.setRefreshing(false);
                LikerListResponse apiResponse = (LikerListResponse) parseableObject;
                List<UserProfile> parsedUserProfileList = getListData(apiResponse);
                for (UserProfile user : parsedUserProfileList) {
                    if (!userProfileList.contains(user)) { // If user already in list
                        userProfileList.add(0, user);
                    } else if (user.getIs_following() == 1) {
                        userProfileList.get(userProfileList.indexOf(user)).setIs_following(1);
                    } else if (user.getIs_following() == 0) {
                        userProfileList.get(userProfileList.indexOf(user)).setIs_following(0);
                    }
                }
                likerListAdapter.notifyDataSetChanged();
                userListCount = apiResponse.getTotalCount();

                updateActionBarTitle(getToolbarTitle(listType));
            }
        }
    }


    private List<UserProfile> getListData(LikerListResponse apiResponse) {
        List<UserProfile> parsedUserProfileList;
        if (listType.equalsIgnoreCase(Constants.LIKERS)) {
            parsedUserProfileList = apiResponse.getLikerProfileList();
        } else if (listType.equalsIgnoreCase(Constants.FANS)) {
            parsedUserProfileList = apiResponse.getUsers();
        } else if (listType.equalsIgnoreCase(Constants.FOLLOWING)) {
            parsedUserProfileList = apiResponse.getUsers();
        } else {
            parsedUserProfileList = apiResponse.getReposters();
        }
        return parsedUserProfileList;
    }

    @Override
    public void onError(Object stringObject, Constants.NetworkStatus errorCode) {
        if (stringObject instanceof String) {
            UIUtils.showSnackBar(activityRootLayout, (String) stringObject);
        }
        if (isRefresh) { // If pull to refresh is active
            swipeRefreshLayoutLiker.setRefreshing(false);
        } else if (isLoadMore) { // If load more is active
            userProfileList.remove(userProfileList.size() - 1);
            likerListAdapter.notifyItemRemoved(userProfileList.size());
            likerListAdapter.setLoaded(false);
        }
        //Check if data not found
        if (errorCode == Constants.NetworkStatus.SERVER_RESPONSE_EQUAL_TO_404
                && stringObject instanceof MessageForGeneralResponse) {
            MessageForGeneralResponse errorFeedResponse = (MessageForGeneralResponse) stringObject;
            String message = errorFeedResponse.getMessage();
            //Show message if recieved from server
            if (message != null && !message.isEmpty()) {
                UIUtils.showSnackBar(activityRootLayout, message);
                if (isVisible()) {
                    callLikerListAPI(Constants.DEFAULT_API_LIMIT_PARAM, refreshOffset);
                }
            }
        }
    }

    @Override
    public void onLoadMore() {
        isLoadMore = true;
        isRefresh = false;
        //add null , so the adapter will check view_type and show progress bar at bottom
        userProfileList.add(null);
        likerListAdapter.notifyItemInserted(userProfileList.size() - 1); // to notify adapter with inserted value

        // set offset to get next data from API
        loadMoreOffset = loadMoreOffset + Constants.DEFAULT_API_LIMIT_PARAM;
        callLikerListAPI(Constants.DEFAULT_API_LIMIT_PARAM, loadMoreOffset);
    }

    @Override
    public void onRefresh() {
        isLoadMore = false;
        isRefresh = true;
        swipeRefreshLayoutLiker.setRefreshing(true);
        callLikerListAPI(Constants.DEFAULT_API_LIMIT_PARAM, refreshOffset);
    }

    @Override
    public void onPause() {
        super.onPause();
        UIUtils.dismissSwipeToRefreshLayout(swipeRefreshLayoutLiker);
    }

    private String getToolbarTitle(String listType) {
        String toolBarTitle = Constants.BLANK;
        if (listType.equalsIgnoreCase(Constants.LIKERS)) {
            toolBarTitle = /*userListCount > 1 ? userListCount + likesTitle : userListCount +*/ likesTitle;
        } else if (listType.equalsIgnoreCase(Constants.REPOSTERS)) {
            toolBarTitle = /*userListCount > 1 ? userListCount + repostsTitle : userListCount + */repostsTitle;
        } else if (listType.equalsIgnoreCase(Constants.FANS)) {
            toolBarTitle = /*userListCount > 1 ? userListCount + fansTitle : userListCount +*/ fansTitle;
        } else if (listType.equalsIgnoreCase(Constants.FOLLOWING)) {
            toolBarTitle = /*userListCount > 1 ? userListCount + followersTitle : userListCount +*/ followersTitle;
        }
        return toolBarTitle;
    }

    @Override
    public void onStop() {
        super.onStop();
        isLoadMore = false;
    }
}