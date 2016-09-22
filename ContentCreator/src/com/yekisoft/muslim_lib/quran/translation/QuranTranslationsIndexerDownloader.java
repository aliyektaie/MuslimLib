package com.yekisoft.muslim_lib.quran.translation;

import com.yekisoft.muslim_lib.IContentDownloader;
import com.yekisoft.muslim_lib.core.Guid;
import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.core.trie.content.ContentFileType;

import java.util.ArrayList;

/**
 * Created by yektaie on 9/10/16.
 */
public class QuranTranslationsIndexerDownloader implements IContentDownloader {
    public ArrayList<TranslationInfo> translations = new ArrayList<>();
    public static QuranTranslationsIndexerDownloader instance = null;

    public static QuranTranslationsIndexerDownloader instance() {
        return instance;
    }

    public QuranTranslationsIndexerDownloader() {
        instance = this;
    }

    @Override
    public boolean needDownload() {
        return false;
    }

    @Override
    public void downloadAndSaveContent() {

    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();

        ContentFile file = new ContentFile();
        file.Type = ContentFileType.Text;
        file.Title = "";
        file.ID = new Guid("0e827245-eba9-4172-b631-385a262c280d");
        file.FilePath = "/Quran/Translations/Index";
        file.Content = toString(this.translations);

        result.add(file);

        return result;
    }

    private String toString(ArrayList<TranslationInfo> translations) {
        StringBuilder result = new StringBuilder();

        for (TranslationInfo info : translations) {
            result.append(info.title + "\r\n");
            result.append(info.pathTemplate + "\r\n");
            result.append(info.language + "\r\n");
        }

        return result.toString().trim();
    }

    @Override
    public String getTitle() {
        return "Quran Translation Index Creator";
    }

    @Override
    public void terminate() {

    }
}
