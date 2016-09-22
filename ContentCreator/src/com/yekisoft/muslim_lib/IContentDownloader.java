package com.yekisoft.muslim_lib;

import com.yekisoft.muslim_lib.core.trie.content.ContentFile;

import java.util.ArrayList;

/**
 * Created by yektaie on 8/5/16.
 */
public interface IContentDownloader {
    boolean needDownload();

    void downloadAndSaveContent();

    ArrayList<ContentFile> getContentFiles();

    String getTitle();

    void terminate();
}
