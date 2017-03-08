package com.myapp.network;

import android.content.Context;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.FileAsyncHttpResponseHandler;
import com.myapp.interfaces.IDownloadCallback;
import com.myapp.utils.Constants;

import java.io.File;

/**
 * Class inherits the FileAsyncHttpResponseHandler to handle the download events.
 * This class will download the beat file from the url and save it to file passed in the constructor
 * Created by amit.thaper on 6/27/2016.
 *
 * @version 2.0
 */
public class LoopJDownloadManager extends FileAsyncHttpResponseHandler {

    private IDownloadCallback returnedCallback;
    private AsyncHttpClient client = new AsyncHttpClient();
    private Context appContext;

    /**
     * Constructor with the file where to download beat file
     *
     * @param file file path where beat file will be downloaded
     */
    public LoopJDownloadManager(File file) {
        super(file);
        setTag(Constants.DOWNLOAD_BEAT_TAG);
    }

    /**
     * Download the beatFile from the given url and save it to local storage
     *
     * @param url     Amazon s3 url to download beat file
     * @param context context to set with download manager request
     */
    public void downloadAudioFile(Context context, String url) {
        this.appContext = context;
        this.client.get(appContext, String.valueOf(url), this);
    }

    /**
     * Method to set the return callback for the download events
     *
     * @param downloadCallback interface to get callback
     */
    public void setCallback(IDownloadCallback downloadCallback) {
        this.returnedCallback = downloadCallback;
    }

    /**
     * Method to cancel the current request
     */
    public void cancelRequest() {
        client.cancelRequests(appContext, true);
    }

    @Override
    public void onProgress(long bytesWritten, long totalSize) {
        long progress = (bytesWritten * 100) / totalSize;
        returnedCallback.onProgressChanged(String.valueOf(progress) + Constants.PERCENT);
        super.onProgress(bytesWritten, totalSize);
    }

    @Override
    public void onFailure(int statusCode, cz.msebera.android.httpclient.Header[] headers, Throwable throwable, File file) {
        returnedCallback.onFailure("Error while loading the beat.", statusCode);
    }

    @Override
    public void onSuccess(int statusCode, cz.msebera.android.httpclient.Header[] headers, File file) {
        returnedCallback.onSuccess("Beat file loaded Successfully.");
    }

    @Override
    public void onCancel() {
        super.onCancel();
        returnedCallback.onCancel("Successfully cancelled beat downloading ");
    }
}
