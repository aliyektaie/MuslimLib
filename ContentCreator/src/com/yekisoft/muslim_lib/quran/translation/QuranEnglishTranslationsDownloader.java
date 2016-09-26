package com.yekisoft.muslim_lib.quran.translation;

import com.google.gson.*;
import com.google.gson.internal.ObjectConstructor;
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
 * Created by yektaie on 8/31/16.
 */
public class QuranEnglishTranslationsDownloader implements IContentDownloader{
    private static final String FOLDER_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Original/Quran/Translations/English/Sahih International";
    private ArrayList<SourahTranlationContainer> sourahsTranslations = new ArrayList<>();

    @Override
    public boolean needDownload() {
        return true;
    }

    @Override
    public void downloadAndSaveContent() {
        for (int i = 1; i <= 114; i++) {
            SourahInfo info = SourahUtils.getSourahInfo(i);
            System.out.println("   Downloading " + info.titleEnglish);

            String html = downloadTranlationPage(info, i);
            parseTranslations(html, info);
        }

        System.out.println();
    }

    private void parseTranslations(String html, SourahInfo info) {
        JsonArray entries = (JsonArray) new JsonParser().parse(html);
        SourahTranlationContainer sourahContainer = new SourahTranlationContainer();
        sourahContainer.Sourah = info;
        sourahsTranslations.add(sourahContainer);

        for (int i = 0; i < info.verseCount; i++) {
            System.out.println("Verse " + i);
            JsonObject translations = (JsonObject) entries.get(i);

            // word by word
            JsonArray wordList = (JsonArray) translations.get("words");
            AyaWordTranslationList listOfWordsTranslation = new AyaWordTranslationList();
            sourahContainer.ayaWordsTranslation.add(listOfWordsTranslation);

            for (JsonElement wordInfo : wordList) {
                Object o = ((JsonObject)wordInfo).get("arabic");
                if (o instanceof JsonNull) {
                    continue;
                }

                WordTransPair pair = new WordTransPair();
                listOfWordsTranslation.words.add(pair);
                pair.arabicText = ((JsonObject)wordInfo).get("arabic").getAsString();

                pair.englishTranslation = ((JsonObject)wordInfo).get("translation").getAsString();
                pair.transliteration = ((JsonObject)wordInfo).get("transliteration").getAsString();
            }

            // translation
            JsonArray list = (JsonArray) translations.get("content");

            for (JsonElement content : list) {
                JsonObject obj = (JsonObject) content;

                AyaWithTranslation container = new AyaWithTranslation();

                container.toLanguage = "English";
                container.translation = obj.get("text").getAsString();

                String title = ((JsonObject)obj.get("resource")).get("name").getAsString();
                switch (title) {
                    case "Pickthall":
                        sourahContainer.translationsPickthall.add(container);
                        break;
                    case "Sahih International":
                        sourahContainer.translationsSahihInternational.add(container);
                        break;
                    case "Yusuf Ali":
                        sourahContainer.translationsYusufAli.add(container);
                        break;
                    case "Dr. Ghali":
                        sourahContainer.translationsDrGhali.add(container);
                        break;
                    case "Shakir":
                        sourahContainer.translationsSakhir.add(container);
                        break;
                    case "Muhsin Khan":
                        sourahContainer.translationsMuhsenKhan.add(container);
                        break;
                }

            }

        }
    }

    private String downloadTranlationPage(SourahInfo info, int sourah) {
        String filePath = String.format("%s/%d.txt", FOLDER_PATH, sourah);
        String html = "";

        if (Utils.fileExists(filePath)) {
            html = Utils.readTextFile(filePath);
        } else {
            html = Utils.getUrlContent("https://quran.com/api/v2/surahs/" + sourah + "/ayahs?from=1&to=" + info.verseCount + "&audio=8&content%5B%5D=19&content%5B%5D=16&content%5B%5D=17&content%5B%5D=18&content%5B%5D=20&content%5B%5D=56&content%5B%5D=21");
            Utils.writeTextFile(filePath, html);
        }

        return html;
    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();

        for (int i = 0; i < sourahsTranslations.size(); i++) {
            SourahTranlationContainer container = sourahsTranslations.get(i);

            for (int j = 0; j < container.Sourah.verseCount; j++) {
                addTranslation(container.translationsSakhir.get(j), result, String.format("/Quran/Translation/Sakhir/%d/%d", i + 1, j + 1));
                addTranslation(container.translationsSahihInternational.get(j), result, String.format("/Quran/Translation/Sahih/%d/%d", i + 1, j + 1));
                addTranslation(container.translationsPickthall.get(j), result, String.format("/Quran/Translation/Pickthall/%d/%d", i + 1, j + 1));
                addTranslation(container.translationsYusufAli.get(j), result, String.format("/Quran/Translation/YusufAli/%d/%d", i + 1, j + 1));
                addTranslation(container.translationsDrGhali.get(j), result, String.format("/Quran/Translation/FrGhali/%d/%d", i + 1, j + 1));
                addTranslation(container.translationsMuhsenKhan.get(j), result, String.format("/Quran/Translation/MusenKhan/%d/%d", i + 1, j + 1));

                addWordByWordTranslations(container.ayaWordsTranslation.get(j), result, i + 1, j + 1);
            }
        }

        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("Shakir", "/Quran/Translation/Sakhir/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("Sahih International", "/Quran/Translation/Sahih/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("Pickthall", "/Quran/Translation/Pickthall/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("Yusuf Ali", "/Quran/Translation/YusufAli/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("Dr. Ghali", "/Quran/Translation/FrGhali/%d/%d"));
        QuranTranslationsIndexerDownloader.instance().translations.add(createTranslationInfo("Muhsin Khan", "/Quran/Translation/MusenKhan/%d/%d"));

        return result;
    }

    private void addWordByWordTranslations(AyaWordTranslationList wordByWordTranlations, ArrayList<ContentFile> result, int sourahNumber, int verseNumber) {
        ContentFile file = new ContentFile();
        file.Type = ContentFileType.Text;
        file.Title = "";
        file.ID = Guid.empty();
        file.FilePath = String.format("/Quran/Translation/WordByWord/English/%d/%d", sourahNumber, verseNumber);
        file.Content = getVerseWordByWordTranslationContent(wordByWordTranlations);

        result.add(file);
    }

    private String getVerseWordByWordTranslationContent(AyaWordTranslationList wordByWordTranlations) {
        StringBuilder result = new StringBuilder();

        for (WordTransPair pair : wordByWordTranlations.words) {
            result.append(pair.arabicText);
            result.append("\r\n");
            result.append(pair.englishTranslation);
            result.append("\r\n");
            result.append(pair.transliteration);
            result.append("\r\n");
        }

        return result.toString().trim();
    }

    private TranslationInfo createTranslationInfo(String title, String path) {
        TranslationInfo result = new TranslationInfo();

        result.title = title;
        result.language = "English";
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
        return "Sahih International (English) Translation Downloader";
    }

    @Override
    public void terminate() {

    }
}

class SourahTranlationContainer {
    public SourahInfo Sourah = null;

    public ArrayList<AyaWithTranslation> translationsSahihInternational = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsPickthall = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsYusufAli = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsDrGhali = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsSakhir = new ArrayList<>();
    public ArrayList<AyaWithTranslation> translationsMuhsenKhan = new ArrayList<>();

    public ArrayList<AyaWordTranslationList> ayaWordsTranslation = new ArrayList<>();
}

class AyaWordTranslationList {
    public ArrayList<WordTransPair> words = new ArrayList<>();

}

class WordTransPair {
    public String arabicText = "";
    public String englishTranslation = "";
    public String transliteration = "";
}