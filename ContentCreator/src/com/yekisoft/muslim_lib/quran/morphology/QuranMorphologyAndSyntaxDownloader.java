package com.yekisoft.muslim_lib.quran.morphology;

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
 * Created by yektaie on 9/26/16.
 */
public class QuranMorphologyAndSyntaxDownloader implements IContentDownloader {
    private final String CACHE_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Original/Quran/Morphology/";
    private ArrayList<ArrayList<QuranVerseMorphologyInfo>> syntax = new ArrayList<>();

    @Override
    public boolean needDownload() {
        return true;
    }

    @Override
    public void downloadAndSaveContent() {
        for (int sourah = 1; sourah <= 114; sourah++) {
            SourahInfo info = SourahUtils.getSourahInfo(sourah);
            ArrayList<QuranVerseMorphologyInfo> sourahMorphology = new ArrayList<>();
            syntax.add(sourahMorphology);

            for (int verseIndex = 1; verseIndex <= info.verseCount; verseIndex++) {
                String html = downloadVerseMorphologicalContent(sourah, verseIndex);
                QuranVerseMorphologyInfo verse = parseVerseInfo(html, sourah, verseIndex);
                sourahMorphology.add(verse);
            }
        }
    }

    private QuranVerseMorphologyInfo parseVerseInfo(String html, int sourah, int verseIndex) {
        System.out.println("   Parsing sourah " + sourah + ", verse " + verseIndex);
        QuranVerseMorphologyInfo result = new QuranVerseMorphologyInfo();
        html = html.substring(html.indexOf("<table class=\"morphologyTable\" "));
        html = html.substring(0, html.indexOf("</table>"));

        String previousAyaText = String.format("src=\"/images/verses/%d.png\"", verseIndex - 1);
        if (html.contains(previousAyaText)) {
            html = "<table>" + html.substring(html.indexOf("<tr>", html.indexOf(previousAyaText)));
        }

        previousAyaText = String.format("src=\"/images/verses/%d.png\"", verseIndex);
        if (html.indexOf("<tr>", html.indexOf(previousAyaText)) > 0) {
            html = html.substring(0, html.indexOf("<tr>", html.indexOf(previousAyaText)));
        }

        String[] words = html.split("<tr>");
        for (int i = 1; i < words.length; i++) {
            String[] parts = words[i].split("<td");
            QuranWordMorphologyInfo wordSyntax = new QuranWordMorphologyInfo();
            result.words.add(wordSyntax);

            String temp = parts[1];
            try {
                temp = temp.substring(temp.indexOf("<a href=\""));
                wordSyntax.transliteration = HtmlUtils.RemoveTags(temp.substring(0, temp.indexOf("</a>")));
            } catch (Exception ex) {
                wordSyntax.transliteration = HtmlUtils.RemoveTags(HtmlUtils.ReadTag(temp, "<span class=\"phonetic\">"));
            }
            wordSyntax.translation = HtmlUtils.RemoveTags(temp.substring(temp.lastIndexOf("<br/>")));

            temp = parts[2];
            temp = temp.substring(temp.indexOf("<img src=\"/wordimage?id="));
            temp = temp.replace("<img src=\"/wordimage?id=", "");
            temp = temp.substring(0, temp.indexOf("\""));
            wordSyntax.arabicWord = temp;

            temp = parts[3];
            temp = temp.substring(temp.indexOf("<div class=\"arabicGrammar\">"));

            temp = temp.replace("&raquo;", "»");
            temp = temp.replace("&laquo;", "«");
//            temp = temp.replace("", "");
//            temp = temp.replace("", "");

            wordSyntax.arabicGrammar = HtmlUtils.RemoveTags(temp);

            if (wordSyntax.arabicGrammar.contains("&")) {
                System.out.println(wordSyntax.arabicGrammar.substring(wordSyntax.arabicGrammar.indexOf("&")));
                throw new RuntimeException();
            }


            temp = parts[3];
            temp = temp.replace("&ndash;", "-");
            temp = temp.substring(0, temp.indexOf("<div class=\"arabicGrammar\">"));
            String[] subParts = temp.split("<br/>");
            for (int j = 0; j < subParts.length; j++) {
                String line = subParts[j];

                String type = HtmlUtils.RemoveTags("<" + line.substring(0, line.indexOf("</b>")));
                String color = getColor(line.substring(line.indexOf("<b class="), line.indexOf(">", line.indexOf("<b class=")) + 1));
                String text = HtmlUtils.RemoveTags(line.substring(line.indexOf("</b>")));

                text = text.replace("&rarr;", "→");
                wordSyntax.syntaxAndMorphology.add(String.format("%s//%s//%s", color, type, text));
            }
        }


        return result;
    }

    private String getColor(String tag) {
        tag = tag.replace("<b class=\"", "");
        tag = tag.replace("\">", "");
        String result = "";

        switch (tag) {
            case "segRust":
                result = "ad2323";
                break;
            case "segSky":
                result = "548dd4";
                break;
            case "segBlue":
                result = "257e9c";
                break;
            case "segPurple":
                result = "8126c0";
                break;
            case "segSeagreen":
                result = "32bd2f";
                break;
            case "segNavy":
                result = "1301b8";
                break;
            case "segMetal":
                result = "5c7085";
                break;
            case "segSilver":
                result = "b4b4b4";
                break;
            case "segGold":
                result = "817418";
                break;
            case "segRed":
                result = "f4400b";
                break;
            case "segOrange":
                result = "e37010";
                break;
            case "segBrown":
                result = "bf9f3e";
                break;
            case "segPink":
                result = "a8017b";
                break;
            case "segRose":
                result = "fd5162";
                break;
            case "segGreen":
                result = "1d6914";
                break;
            default:
                throw new RuntimeException("Invalid color : " + tag);
        }

        return result;
    }

    private String downloadVerseMorphologicalContent(int sourah, int verseIndex) {
        String html = null;
        String path = String.format("%s%d-%d.htm", CACHE_PATH, sourah, verseIndex);

        if (Utils.fileExists(path)) {
            html = Utils.readTextFile(path);
        } else {
            html = Utils.getUrlContent(String.format("http://corpus.quran.com/wordbyword.jsp?chapter=%d&verse=%d", sourah, verseIndex));
            Utils.writeTextFile(path, html);
        }

        return html;
    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();

        for (int i = 0; i < syntax.size(); i++) {
            ArrayList<QuranVerseMorphologyInfo> sourahVerses = syntax.get(i);
            for (int j = 0; j < sourahVerses.size(); j++) {
                addWordByWordTranslations(sourahVerses.get(j), result, i + 1, j + 1);
            }
        }

        return result;
    }

    private void addWordByWordTranslations(QuranVerseMorphologyInfo wordByWordTranlations, ArrayList<ContentFile> result, int sourahNumber, int verseNumber) {
        ContentFile file = new ContentFile();
        file.Type = ContentFileType.Text;
        file.Title = "";
        file.ID = Guid.empty();
        file.FilePath = String.format("/Quran/Translation/WordByWord/%d/%d", sourahNumber, verseNumber);
        file.Content = getVerseWordByWordTranslationContent(wordByWordTranlations);

        result.add(file);
    }

    private String getVerseWordByWordTranslationContent(QuranVerseMorphologyInfo wordByWordTranlations) {
        StringBuilder result = new StringBuilder();
        boolean first = true;

        for (QuranWordMorphologyInfo pair : wordByWordTranlations.words) {
            if (!first) {
                result.append("--------------------------\r\n");
            }
            first = false;
            result.append(pair.arabicWord);
            result.append("\r\n");
            result.append(pair.arabicGrammar);
            result.append("\r\n");
            result.append(pair.translation);
            result.append("\r\n");
            result.append(pair.transliteration);
            result.append("\r\n");
            for (String line : pair.syntaxAndMorphology) {
                result.append(line);
                result.append("\r\n");
            }
        }

        return result.toString().trim();
    }

    @Override
    public String getTitle() {
        return "Quran Syntax & Morphology Downloader";
    }

    @Override
    public void terminate() {

    }
}

class QuranVerseMorphologyInfo {
    public ArrayList<QuranWordMorphologyInfo> words = new ArrayList<>();
}

class QuranWordMorphologyInfo {
    public String translation = "";
    public String transliteration = "";
    public String arabicWord = "";

    public ArrayList<String> syntaxAndMorphology = new ArrayList<>();
    public String arabicGrammar = "";
}
