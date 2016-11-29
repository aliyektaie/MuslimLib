package com.yekisoft.muslim_lib.quran.text;

import com.google.gson.GsonBuilder;
import com.yekisoft.muslim_lib.IContentDownloader;
import com.yekisoft.muslim_lib.core.Guid;
import com.yekisoft.muslim_lib.core.HtmlUtils;
import com.yekisoft.muslim_lib.core.Utils;
import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.core.trie.content.ContentFileType;
import com.yekisoft.muslim_lib.quran.SourahInfo;
import com.yekisoft.muslim_lib.quran.SourahUtils;

import java.util.ArrayList;

/**
 * Created by yektaie on 8/10/16.
 */
public class QuranPageIndexCreator implements IContentDownloader {
    private final String CACHED_FILE_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Original/Quran/Page Index/%d.htm";
    private final String INDEX_FILE_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Processed/Quran/Page Index/index.txt";
    private int currentSourah = 0;

    private String[] pagesIndex = new String[604];

    @Override
    public boolean needDownload() {
        boolean result = !Utils.fileExists(INDEX_FILE_PATH);

        if (!result) {
            pagesIndex = Utils.readTextFile(INDEX_FILE_PATH).split("\r\n");

        }

        return result;
    }

    @Override
    public void downloadAndSaveContent() {
        StringBuilder content = new StringBuilder();

        for (int i = 1; i <= 604; i++) {
            System.out.println(String.format("   Downloading Quran Page [%d of %d]", i, 604));
            String html = downloadHtmlPage(i);
            String indexContent = loadIndexFromPage(html);

            pagesIndex[i - 1] = indexContent;
            content.append(indexContent);
            content.append("\r\n");
        }

        Utils.writeTextFile(INDEX_FILE_PATH, content.toString().trim());
    }

    private String loadIndexFromPage(String html) {
        html = HtmlUtils.ReadTag(html, "<div class=\"ayahs\">");
        ArrayList<String> ayas = extractAyaNumbers(html);

        String start = "";
        String end = "";

        if (ayas.get(0).equals("1")) {
            currentSourah++;
            start = String.format("%d:1", currentSourah);
        } else {
            start = String.format("%d:%s", currentSourah, ayas.get(0));
        }

        for (int i = 1; i < ayas.size(); i++) {
            if (ayas.get(i).equals("1")) {
                currentSourah++;
            }
        }

        end = String.format("%d:%s", currentSourah, ayas.get(ayas.size() - 1));

        return start + "-" + end;
    }

    private ArrayList<String> extractAyaNumbers(String html) {
        ArrayList<String> result = new ArrayList<>();

        String[] parts = html.split("<i>﴿<b>");
        for (int i = 1; i < parts.length; i++) {
            String number = parts[i];
            number = number.substring(0, number.indexOf("<"));

            result.add(number);
        }

        return result;
    }

    private String downloadHtmlPage(int page) {
        String path = String.format(CACHED_FILE_PATH, page);
        String html = "";

        if (Utils.fileExists(path)) {
            html = Utils.readTextFile(path);
        } else {
            html = Utils.getUrlContent(String.format("http://telavat.ir/fa/quran/page/%d", page));
            Utils.writeTextFile(path, html);
        }

        return html;
    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();

        ContentFile file = new ContentFile();

        file.Content = Utils.readTextFile(INDEX_FILE_PATH);
        file.FilePath = "/Content/Quran/PageIndex";
        file.ID = new Guid("6834e482-4bae-438d-8fb1-19d30969fd7a");
        file.Title = "Quran Pages Index";
        file.Type = ContentFileType.Text;

        result.add(file);

        for (int i = 1; i <= 604; i++) {
            ContentFile fileForPage = new ContentFile();

            fileForPage.Content = createPageFile(i);
            fileForPage.FilePath = "/QP" + i;
            fileForPage.ID = new Guid("6834e482-4bae-438d-8fb1-19d30969f" + pad(i));
            fileForPage.Title = "Quran Page " + i;
            fileForPage.Type = ContentFileType.Text;

            result.add(fileForPage);
        }

        return result;
    }

    private String pad(int value) {
        String result = String.valueOf(value);

        for (int i = result.length(); i < 3; i++) {
            result = "0" + result;
        }

        return result;
    }

    private String createPageFile(int page) {
        ArrayList<VerseInfo> result = new ArrayList<>();
        String[] temp = pagesIndex[page - 1].replace("-", ":").split(":");
        int beginPageChapter = Integer.valueOf(temp[0]);
        int beginPageVerse = Integer.valueOf(temp[1]);
        int endPageChapter = Integer.valueOf(temp[2]);
        int endPageVerse = Integer.valueOf(temp[3]);


        if (beginPageChapter == endPageChapter) {
            for (int i = beginPageVerse; i <= endPageVerse; i++) {
                String verse = QuranTextDownloader.instance().quran.get(beginPageChapter - 1).get(i - 1);

                VerseInfo verseObject = new VerseInfo();

                verseObject.chapterNumber = beginPageChapter + "";
                verseObject.verseNumber = i + "";
                verseObject.verseText = verse;

                result.add(verseObject);
            }
        } else {
            int beginVerse = beginPageVerse;

            for (int sourah = beginPageChapter; sourah <= endPageChapter; sourah++) {
                SourahInfo sourahInfo = SourahUtils.getSourahInfo(sourah);
                int endVerseNumber = sourahInfo.verseCount;

                if (sourahInfo.orderInBook == endPageChapter) {
                    endVerseNumber = endPageVerse;
                }

                for (int verseNumber = beginVerse; verseNumber <= endVerseNumber; verseNumber++) {
                    String verse = QuranTextDownloader.instance().quran.get(sourah - 1).get(verseNumber - 1);

                    VerseInfo verseObject = new VerseInfo();

                    verseObject.chapterNumber = sourah + "";
                    verseObject.verseNumber = verseNumber + "";
                    verseObject.verseText = verse;

                    result.add(verseObject);

                }

                beginVerse = 1;
            }
        }

        return new GsonBuilder().create().toJson(result);
    }

    @Override
    public String getTitle() {
        return "Quran Page Index Creator";
    }

    @Override
    public void terminate() {

    }

    @Override
    public String getBankName() {
        return "content-quran.db";
    }
}

class VerseInfo {
    public String verseNumber;
    public String chapterNumber;
    public String verseText;
}
