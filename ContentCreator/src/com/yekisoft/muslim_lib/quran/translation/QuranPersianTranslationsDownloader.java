package com.yekisoft.muslim_lib.quran.translation;

import com.yekisoft.muslim_lib.IContentDownloader;
import com.yekisoft.muslim_lib.core.Guid;
import com.yekisoft.muslim_lib.core.Utils;
import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.core.trie.content.ContentFileType;
import com.yekisoft.muslim_lib.quran.AyaWithTranslation;
import com.yekisoft.muslim_lib.quran.SourahInfo;
import com.yekisoft.muslim_lib.quran.SourahUtils;

import java.util.ArrayList;

/**
 * Created by yektaie on 9/10/16.
 */
public class QuranPersianTranslationsDownloader implements IContentDownloader {
    private ArrayList<PersianSourahTranslationContainer> sourahsTranslations = new ArrayList<>();

    @Override
    public boolean needDownload() {
        return true;
    }

    @Override
    public void downloadAndSaveContent() {
        for (int i = 1; i <= 114; i++) {
            SourahInfo info = SourahUtils.getSourahInfo(i);
            System.out.println("   Downloading " + info.titleEnglish);
            PersianSourahTranslationContainer sourahContainer = new PersianSourahTranslationContainer();
            sourahContainer.Sourah = info;
            sourahsTranslations.add(sourahContainer);

            int[] trans = {1, 2, 3, 10, 11};
            for (int j = 0; j < trans.length; j++) {
                int k = trans[j];
                String html = downloadTranslationPage(info, i, k);
                parseTranslations(html, info, k, sourahContainer);
            }
        }

        System.out.println();
    }

    private void parseTranslations(String html, SourahInfo info, int translation, PersianSourahTranslationContainer sourahContainer) {
        String[] lines = html.split("<div class=\"DF\">");

        for (int i = 0; i < info.verseCount; i++) {
            String line = lines[i + 1];
            line = line.substring(0, line.indexOf("</div>")).trim();
            if (line.contains("(")) {
                line = line.substring(0, line.lastIndexOf("(")).trim();
            } else {
                continue;
            }

            AyaWithTranslation container = new AyaWithTranslation();

            container.toLanguage = "Persian";
            container.translation = line;

            switch (translation) {
                case 1:
                    sourahContainer.translationsFouladvand.add(container);
                    break;
                case 2:
                    sourahContainer.translationsMakaremShirazi.add(container);
                    break;
                case 3:
                    sourahContainer.translationsKhoramShahi.add(container);
                    break;
                case 10:
                    sourahContainer.translationsGhomeshoi.add(container);
                    break;
                case 11:
                    sourahContainer.translationsAnsarian.add(container);
                    break;
            }
        }
    }

    private String downloadTranslationPage(SourahInfo info, int sourah, int translation) {
        String html = Utils.getUrlContent(String.format("http://www.parsquran.com/data/show.php?lang=far&sura=%d&ayat=0&user=far&tran=%d", sourah, translation));

        return html;
    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();

        for (int i = 0; i < sourahsTranslations.size(); i++) {
            PersianSourahTranslationContainer container = sourahsTranslations.get(i);

            for (int j = 0; j < container.Sourah.verseCount; j++) {
                try {
                    addTranslation(container.translationsFouladvand.get(j), result, String.format("/Quran/Translation/Fouladvand/%d/%d", i + 1, j + 1));
                } catch (Exception ignored) {
                }
                try {
                    addTranslation(container.translationsMakaremShirazi.get(j), result, String.format("/Quran/Translation/Makarem/%d/%d", i + 1, j + 1));
                } catch (Exception ignored) {
                }
                try {
                    addTranslation(container.translationsKhoramShahi.get(j), result, String.format("/Quran/Translation/KhoramShahi/%d/%d", i + 1, j + 1));
                } catch (Exception ignored) {
                }
                try {
                    addTranslation(container.translationsGhomeshoi.get(j), result, String.format("/Quran/Translation/Ghomshoie/%d/%d", i + 1, j + 1));
                } catch (Exception ignored) {
                }
                try {
                    addTranslation(container.translationsAnsarian.get(j), result, String.format("/Quran/Translation/Ansarian/%d/%d", i + 1, j + 1));
                } catch (Exception ignored) {
                }
            }
        }

        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("فولادوند", "/Quran/Translation/Fouladvand/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("مکارم شیرازی", "/Quran/Translation/Makarem/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("خرم شاهی", "/Quran/Translation/KhoramShahi/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("الهی قمشه‌ای", "/Quran/Translation/Ghomshoie/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("انصاریان", "/Quran/Translation/Ansarian/%d/%d"));

        return result;
    }

    private TranslationInfo createTranslationInfo(String title, String path) {
        TranslationInfo result = new TranslationInfo();

        result.title = title;
        result.language = "Persian";
        result.pathTemplate = path;

        return result;
    }

    private void addTranslation(AyaWithTranslation ayaWithTranslation, ArrayList<ContentFile> result, String path) {
        ContentFile file = new ContentFile();
        file.Type = ContentFileType.Text;
        file.Title = "";
        file.ID = Guid.empty();
        file.FilePath = path;
        file.Content = ayaWithTranslation.translation;

        result.add(file);
    }

    private String pad(int value) {
        String result = String.valueOf(value);

        for (int i = result.length(); i < 3; i++) {
            result = "0" + result;
        }

        return result;
    }


    @Override
    public String getTitle() {
        return "Persian Translation Downloader";
    }

    @Override
    public void terminate() {

    }

    @Override
    public String getBankName() {
        return "content-quran-translation.db";
    }
}

class PersianSourahTranslationContainer {
    public SourahInfo Sourah = null;

    public ArrayList<AyaWithTranslation> translationsFouladvand = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsMakaremShirazi = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsKhoramShahi = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsGhomeshoi = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsAnsarian = new ArrayList<>();
}
