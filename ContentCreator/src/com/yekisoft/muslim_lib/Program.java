package com.yekisoft.muslim_lib;

import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.core.trie.content.ContentManager;
import com.yekisoft.muslim_lib.quran.morphology.*;
import com.yekisoft.muslim_lib.quran.recitation.AlafasyRecitationDownloader;
import com.yekisoft.muslim_lib.quran.sourah_list.*;
import com.yekisoft.muslim_lib.quran.text.*;
import com.yekisoft.muslim_lib.quran.translation.*;

import java.util.ArrayList;
import java.util.Hashtable;

/**
 * Created by yektaie on 8/5/16.
 */
public class Program {
    private static ArrayList<IContentDownloader> getContentDownloaders() {
        ArrayList<IContentDownloader> result = new ArrayList<>();

        // ==========================================================
        //    Quran
        // ==========================================================
        result.add(new BasicSourahListDownloader());
        result.add(new SourahSummaryFromWikipediaDownloader());
        result.add(new PersianSourahContentDownloader());
        result.add(new SourahWordAndLetterCountDownloader());
        result.add(new EnglishPersianSourahInfoDownloader());

        result.add(new QuranTextDownloader());
        result.add(new QuranPageIndexCreator());
        result.add(new QuranEnglishTranslationsDownloader());
        result.add(new QuranPersianTranslationsDownloader());
        result.add(new QuranTranslationsIndexerDownloader());

        result.add(new QuranMorphologyAndSyntaxDownloader());

//        result.add(new AlafasyRecitationDownloader());

        return result;
    }


    public static void main(String[] args) {
        ArrayList<IContentDownloader> contentProviders = getContentDownloaders();
        Hashtable<String, ContentManager> contents = new Hashtable<>();
        ArrayList<String> titles = new ArrayList<>();

        for (int i = 0; i < contentProviders.size(); i++) {
            IContentDownloader downloader = contentProviders.get(i);
            if (!contents.containsKey(downloader.getBankName())) {
                contents.put(downloader.getBankName(), new ContentManager());
                titles.add(downloader.getBankName());
            }

            printDownloaderHeader(downloader);
            downloadContent(downloader);

            ArrayList<ContentFile> files = downloader.getContentFiles();
            if (files != null) {
                for (ContentFile file : files) {
                    contents.get(downloader.getBankName()).Add(file.FilePath, file);
                }
            }

            downloader.terminate();
        }

        printSpaceBetweenContentDownloadersAndGenerator();
        for (String fileTitle : titles) {
            contents.get(fileTitle).Save("/Volumes/Files/Projects/MuslimLib/Content/" + fileTitle, "Muslim Lib Content File");
        }
    }

    private static void printSpaceBetweenContentDownloadersAndGenerator() {
        for (int i = 0; i < 4; i++) {
            System.out.println();
        }
    }

    private static void downloadContent(IContentDownloader downloader) {
        if (downloader.needDownload()) {
            System.out.println("   Status: Downloading...");
            downloader.downloadAndSaveContent();
        }

        System.out.println("   Status: Ready");
    }

    private static void printDownloaderHeader(IContentDownloader downloader) {
        System.out.println("----------------------------------------------------------");
        System.out.println("Download Provider: " + downloader.getTitle());
    }
}
