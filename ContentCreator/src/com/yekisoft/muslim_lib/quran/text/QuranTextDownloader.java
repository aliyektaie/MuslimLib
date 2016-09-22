package com.yekisoft.muslim_lib.quran.text;

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
public class QuranTextDownloader implements IContentDownloader {
    private static QuranTextDownloader _instance;
    private final String CACHED_FILE_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Original/Quran/Text/%s/%d.htm";
    private final String MODE_CORAN_FRANCAIS = "coran-francais";
    private final String MODE_PARSE_QURAN = "pars-quran";

    private String mode = MODE_CORAN_FRANCAIS;

    public ArrayList<ArrayList<String>> quran = new ArrayList<>();

    public static QuranTextDownloader instance() {
        return _instance;
    }

    public QuranTextDownloader() {
        _instance = this;
    }

    @Override
    public boolean needDownload() {
        return true;
    }

    @Override
    public void downloadAndSaveContent() {
        for (int i = 1; i <= 114; i++) {
            SourahInfo info = SourahUtils.getSourahInfo(i);
            System.out.println("   Downloading " + info.titleEnglish);
            downloadSourah(i);
        }

//        StringBuilder result = new StringBuilder();
//        for (String c : this.quranChars) {
//            result.append(c + "\r\n");
//        }
//
//        String tex = result.toString();
//        System.out.println(tex);
    }

    private void downloadSourah(int sourah) {
        String html = loadHtmlContent(sourah);

        String delimiter = "<span class=\"position\">";
        String endDelimiter = "<span class=\"interagir_div1\">";
        String start = "<p";

        if (mode.equals(MODE_PARSE_QURAN)) {
            delimiter = "<div class=\"DA\"";
            endDelimiter = "<span class=";
            start = "\n";
        }

        String[] ayat = html.split(delimiter);
        ArrayList<String> result = new ArrayList<>();

        for (int i = 1; i < ayat.length; i++) {
//            System.out.println(i);
            String aya = ayat[i].substring(ayat[i].indexOf(start));
            int end = aya.length();
            if (aya.contains(endDelimiter))
                end = aya.indexOf(endDelimiter);

            aya = HtmlUtils.RemoveTags(aya.substring(0, end)).trim();
            aya = aya.replace("&nbsp;", "");

            result.add(formatSpecialChars(aya, i));
        }

        quran.add(result);
    }

    private ArrayList<String> quranChars = new ArrayList<>();

    private String formatSpecialChars(String ayaText, int ayaNumber) {
        char[] chars = ayaText.toCharArray();
        for (char aChar : chars) {
            if (aChar >= 'ا' && aChar <= 'ه') {
                continue;
            }

            String t = String.valueOf(aChar);
            if (!this.quranChars.contains(t)) {
                this.quranChars.add(t);
            }
        }

        ayaText = ayaText.replace("ۛ", " <moaneghe>");
        ayaText = ayaText.replace("ۖ", " <sali>");
        ayaText = ayaText.replace("ۚ", " <jayez>");
        ayaText = ayaText.replace("ۘ", " <motlagh>");
        ayaText = ayaText.replace("ۙ", " <mamnu>");
        ayaText = ayaText.replace("ۗ", " <gholi>");

        return ayaText;
    }

    private String loadHtmlContent(int sourah) {
        String html = "";

        if (mode.equals(MODE_CORAN_FRANCAIS)) {
            String path = String.format(CACHED_FILE_PATH, mode, sourah);

            if (Utils.fileExists(path)) {
                html = Utils.readTextFile(path);
            } else {
                html = Utils.getUrlContent(String.format("https://www.coran-francais.com/arabe/s-%d-0.html", sourah));
                Utils.writeTextFile(path, html);
            }
        } else if (mode.equals(MODE_PARSE_QURAN)) {
            html = Utils.getUrlContent("http://www.parsquran.com/data/show.php?sura=" + sourah);
        }

        return html;
    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();
        int ayaCount = 0;

        for (int i = 0; i < quran.size(); i++) {
            int index = i + 1;
            ArrayList<String> ayat = quran.get(i);

            ayaCount += ayat.size();
            for (int j = 0; j < ayat.size(); j++) {
                ContentFile file = new ContentFile();
                file.Type = ContentFileType.Text;
                file.Title = "";
                file.ID = new Guid(String.format("5657cdec-238e-4fce-a6fe-%s2dc3b7%s", pad(index), pad(j + 1)));
                file.FilePath = String.format("/Q%d:%d", index, j + 1);
                file.Content = ayat.get(j);

                result.add(file);
            }
        }

//        System.out.println("Total Verses: " + ayaCount);

        return result;
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
        return "Quran Arabic Text Downloader";
    }

    @Override
    public void terminate() {

    }
}
