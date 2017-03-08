package com.myapp.interfaces;

import com.myapp.datamodels.Song;
import com.myapp.utils.Constants;

/**
 * Interface will be used with Player Utility to manage Presentation layer
 * as per the player status for state, buffer and progress
 * Created by mohit.sharma on 03-08-2016.
 *
 * @version 2.0
 */
public interface IPlayerListener {

    /**
     * Callback to handle presentation layer for media buffer update
     *
     * @param song     Currently buffering song object
     * @param progress Buffered progress
     */
    void onMediaBuffer(Song song, int progress);

    /**
     * Callback to handle presentation layer for media buffer update
     *
     * @param song     Currently playing song object
     * @param progress current player progress
     */
    void onMediaProgress(Song song, int progress);

    /**
     * Callback to handle presentation layer for media buffer update
     *
     * @param song        Currently song object in player
     * @param playerState current player state
     */
    void onMediaStateChange(Song song, Constants.PlayerState playerState);
}
