package com.yekisoft.muslim_lib.quran.recitation;

import com.yekisoft.muslim_lib.IContentDownloader;
import com.yekisoft.muslim_lib.core.Utils;
import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.quran.SourahInfo;
import com.yekisoft.muslim_lib.quran.SourahUtils;

import java.util.ArrayList;

/**
 * Created by yektaie on 9/22/16.
 */
public class AlafasyRecitationDownloader implements IContentDownloader {
    @Override
    public boolean needDownload() {
        return true;
    }

    @Override
    public void downloadAndSaveContent() {
        String pathContent = "/Users/yektaie/Desktop/Quran/";
        for (int i = 1; i <= 114; i++) {
            SourahInfo info = SourahUtils.getSourahInfo(i);

            Utils.CreateDirectory(pathContent + pad(i));
            for (int j = 1; j <= info.verseCount; j++) {
                System.out.println("   Downloading Sourah " + info.titleEnglish + " [" + i + ":" + j + "]");
//                String url = String.format("https://medias.coran-francais.com/son-arabe/Alafasy/%s%s.mp3", pad(i), pad(j));
                String url = String.format("http://www.everyayah.com/data/Alafasy_128kbps/%s%s.mp3", pad(i), pad(j));
                byte[] mp3 = Utils.downloadFile(url);

                Utils.writeBinaryFile(pathContent + pad(i) + "/" + pad(j) + ".mp3", mp3);
            }
        }
    }

    private String pad(int number) {
        String result = String.valueOf(number);

        for (int i = result.length(); i < 3; i++) {
            result = "0" + result;
        }

        return result;
    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        return null;
    }

    @Override
    public String getTitle() {
        return "Alafasy Recitation Downloader";
    }

    @Override
    public void terminate() {

    }
}
