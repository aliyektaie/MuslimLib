package com.yekisoft.muslim_lib.quran.sourah_list;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.yekisoft.muslim_lib.IContentDownloader;
import com.yekisoft.muslim_lib.core.Guid;
import com.yekisoft.muslim_lib.core.HtmlUtils;
import com.yekisoft.muslim_lib.core.Utils;
import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.core.trie.content.ContentFileType;
import com.yekisoft.muslim_lib.quran.SourahInfo;
import com.yekisoft.muslim_lib.quran.SourahUtils;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by yektaie on 8/7/16.
 */
public class SourahSummaryFromWikipediaDownloader implements IContentDownloader {
    private static final String SUMMARIES_PROCESSED_ROOT_DIRECTORY = "/Volumes/Files/Projects/MuslimLib/Content/Processed/Quran/Summaries/";
    private static final String SUMMARIES_ORIGINAL_ROOT_DIRECTORY = "/Volumes/Files/Projects/MuslimLib/Content/Original/Quran/Summaries/";

    @Override
    public boolean needDownload() {
        return true;
//        File directory = new File(SUMMARIES_ROOT_DIRECTORY);
//
//        return !directory.exists();
    }

    @Override
    public void downloadAndSaveContent() {
        if (needDownload()) {
            File directory = new File(SUMMARIES_PROCESSED_ROOT_DIRECTORY);
            directory.mkdir();

            directory = new File(SUMMARIES_ORIGINAL_ROOT_DIRECTORY + "English");
            directory.mkdir();

            directory = new File(SUMMARIES_PROCESSED_ROOT_DIRECTORY + "English");
            directory.mkdir();

            directory = new File(SUMMARIES_ORIGINAL_ROOT_DIRECTORY + "Persian");
            directory.mkdir();

            directory = new File(SUMMARIES_PROCESSED_ROOT_DIRECTORY + "Persian");
            directory.mkdir();
        }

        downloadEnglishSummaries();
        downloadPersianSummaries();

        updateMoghataatLetters();
    }

    private void updateMoghataatLetters() {
        Connection connection = Utils.getDatabaseConnection(SourahUtils.SOURAH_LIST_FILE_PATH);

        updateMoghataatLetter(connection, 2, "Alif Lam Mim", "الم");
        updateMoghataatLetter(connection, 3, "Alif Lam Mim", "الم");
        updateMoghataatLetter(connection, 29, "Alif Lam Mim", "الم");
        updateMoghataatLetter(connection, 30, "Alif Lam Mim", "الم");
        updateMoghataatLetter(connection, 31, "Alif Lam Mim", "الم");
        updateMoghataatLetter(connection, 32, "Alif Lam Mim", "الم");
        updateMoghataatLetter(connection, 7, "Alif Lam Mim Sad", "المص");
        updateMoghataatLetter(connection, 10, "Alif Lam Ra", "الر");
        updateMoghataatLetter(connection, 11, "Alif Lam Ra", "الر");
        updateMoghataatLetter(connection, 12, "Alif Lam Ra", "الر");
        updateMoghataatLetter(connection, 14, "Alif Lam Ra", "الر");
        updateMoghataatLetter(connection, 15, "Alif Lam Ra", "الر");
        updateMoghataatLetter(connection, 13, "Alif Lam Mim Ra", "المر");
        updateMoghataatLetter(connection, 19, "Kaf Ha Ya Ain Sad", "کهیعص");
        updateMoghataatLetter(connection, 20, "Ta Ha", "طه");
        updateMoghataatLetter(connection, 26, "Ta Sin Mim", "طسم");
        updateMoghataatLetter(connection, 28, "Ta Sin Mim", "طسم");
        updateMoghataatLetter(connection, 27, "Ta Sin", "طس");
        updateMoghataatLetter(connection, 36, "Ya Sin", "یس");
        updateMoghataatLetter(connection, 38, "Sad", "ص");
        updateMoghataatLetter(connection, 40, "Ha Mim", "حم");
        updateMoghataatLetter(connection, 41, "Ha Mim", "حم");
        updateMoghataatLetter(connection, 43, "Ha Mim", "حم");
        updateMoghataatLetter(connection, 44, "Ha Mim", "حم");
        updateMoghataatLetter(connection, 45, "Ha Mim", "حم");
        updateMoghataatLetter(connection, 46, "Ha Mim", "حم");
        updateMoghataatLetter(connection, 42, "Ha Mim, Ain Sin Ghaf", "حم عسق");
        updateMoghataatLetter(connection, 50, "Ghaf", "ق");
        updateMoghataatLetter(connection, 68, "Nun", "ن");

        try {
            connection.close();
        } catch (SQLException ignored) {

        }
    }

    private void updateMoghataatLetter(Connection connection, int chapterNumber, String englishLetters, String arabicLetters) {
        PreparedStatement statement = null;
        try {
            statement = connection.prepareStatement(String.format("UPDATE list SET moghataat_en = '%s', moghataat_ar = '%s' WHERE book_order = %d", englishLetters, arabicLetters, chapterNumber));
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();

        for (int i = 1; i <= 114; i++) {
            createSourahSummary(result, "English", i);
            createSourahSummary(result, "Persian", i);
        }

        return result;
    }

    private void createSourahSummary(ArrayList<ContentFile> result, String language, int chapterIndex) {
        ContentFile file = new ContentFile();

        file.Content = createSourahSummaryContent(language, chapterIndex);
        file.FilePath = String.format("/Content/Quran/Sourah/Summary/%s/%d", language, chapterIndex);
        file.ID = new Guid(String.format("f21c1831-2fac-4c66-98db-%dae867e79%s", getLanguageIndex(language), padTo3Digit(chapterIndex)));
        file.Title = "Sourah";
        file.Type = ContentFileType.Text;

        result.add(file);
    }

    private String padTo3Digit(int chapterIndex) {
        String result = String.valueOf(chapterIndex);

        for (int i = result.length(); i < 3; i++) {
            result = "0" + result;
        }

        return result;
    }

    private int getLanguageIndex(String language) {
        if (language.equals("English")) {
            return 1;
        } else if (language.equals("Persian")) {
            return 2;
        }

        throw new RuntimeException();
    }

    private String createSourahSummaryContent(String language, int chapterIndex) {
        String path = SUMMARIES_PROCESSED_ROOT_DIRECTORY + language + "/" + chapterIndex + ".txt";
        return Utils.readTextFile(path);
    }

    @Override
    public String getTitle() {
        return "Quran Sourah Summary (from Wikipedia) Downloader";
    }

    @Override
    public void terminate() {
        properties.size();
    }

    private void downloadPersianSummaries() {
        String html = BasicSourahListDownloader.downloadListOfSourahTable();
        String[] lines = html.split("<tr>");
        for (int i = 3; i < lines.length; i++) {
            String[] parts = lines[i].split("<td>");
            String link = parts[3];
            link = link.substring(link.indexOf("href=") + 6);
            link = "https://fa.wikipedia.org" + link.substring(0, link.indexOf("\""));

            int chapterNumber = Integer.parseInt(HtmlUtils.RemoveTags(parts[1]));
            String chapterTitle = HtmlUtils.RemoveTags(parts[3]);
            System.out.println("   Currently Downloading: [fa] " + chapterTitle);

            downloadPersianSummary(link, chapterNumber);
        }
    }

    private void downloadPersianSummary(String link, int chapterNumber) {
        String htmlFilePath = SUMMARIES_ORIGINAL_ROOT_DIRECTORY + "Persian/" + chapterNumber + ".htm";
        String html = "";
        if (Utils.fileExists(htmlFilePath)) {
            html = Utils.readTextFile(htmlFilePath);
        } else {
            html = Utils.getUrlContent(link);
        }

        SourahInformationArticle article = parseArticle(html, chapterNumber);

        Utils.writeTextFile(SUMMARIES_PROCESSED_ROOT_DIRECTORY + "Persian/" + chapterNumber + ".txt", article.serialize());
        Utils.writeTextFile(htmlFilePath, html);

    }

    private void downloadEnglishSummaries() {
        String html = EnglishPersianSourahInfoDownloader.downloadListOfSourahTable();
        String[] lines = html.split("<tr>");
        for (int i = 2; i < lines.length; i++) {
            String[] parts = lines[i].split("<td>");
            String link = parts[2];
            link = link.substring(link.indexOf("href=") + 6);
            link = "https://en.wikipedia.org" + link.substring(0, link.indexOf("\""));
            int chapterNumber = Integer.parseInt(HtmlUtils.RemoveTags(parts[1]));
            String chapterTitle = getEnglishTitle(HtmlUtils.RemoveTags(parts[2])).trim();
            System.out.println("   Currently Downloading: [en] " + chapterTitle);

            downloadEnglishSummary(link, chapterNumber);
        }
    }

    private String getEnglishTitle(String html) {
        if (html.contains("[notes")) {
            html = html.substring(0, html.indexOf("[notes"));
        }

        return html;
    }


    private void downloadEnglishSummary(String link, int chapterNumber) {
        String htmlFilePath = SUMMARIES_ORIGINAL_ROOT_DIRECTORY + "English/" + chapterNumber + ".htm";
        String html = "";
        if (Utils.fileExists(htmlFilePath)) {
            html = Utils.readTextFile(htmlFilePath);
        } else {
            html = Utils.getUrlContent(link);
        }

        SourahInformationArticle article = parseArticle(html, chapterNumber);

        Utils.writeTextFile(SUMMARIES_PROCESSED_ROOT_DIRECTORY + "English/" + chapterNumber + ".txt", article.serialize());
        Utils.writeTextFile(htmlFilePath, html);

        updateSourahInfosFromWikipedia(chapterNumber, article);
    }

    private void updateSourahInfosFromWikipedia(int chapterNumber, SourahInformationArticle article) {
        Connection connection = Utils.getDatabaseConnection(SourahUtils.SOURAH_LIST_FILE_PATH);

        updateSourahInfoDatabaseInt(connection, chapterNumber, article, "sijdah_count", "Number of Sajdahs");



        try {
            connection.close();
        } catch (SQLException ignored) {

        }
    }

    private void updateSourahInfoDatabaseString(Connection connection, int chapterNumber, SourahInformationArticle article, String nameInSql, String property) {
        String value = getPropertyString(article, property);
        if (value != null) {
            PreparedStatement statement = null;
            try {
                statement = connection.prepareStatement(String.format("UPDATE list SET %s = '%s' WHERE book_order = %d", nameInSql, value, chapterNumber));
                statement.executeUpdate();

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void updateSourahInfoDatabaseInt(Connection connection, int chapterNumber, SourahInformationArticle article, String nameInSql, String property) {
        int value = getPropertyInt(article, property);
        PreparedStatement statement = null;
        try {
            statement = connection.prepareStatement(String.format("UPDATE list SET %s = %d WHERE book_order = %d", nameInSql, value, chapterNumber));
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private int getPropertyInt(SourahInformationArticle article, String property) {
        int result = 0;

        for (SourahProperty p : article.properties) {
            if (p.name.equals(property)) {
                if (p.value.equals("none")) {
                    result = 0;
                } else {
                    String value = p.value;
                    if (value.contains(" (")) {
                        value = value.substring(0, value.indexOf(" "));
                    }
                    result = Integer.valueOf(value);
                }
            }
        }

        return result;
    }

    private String getPropertyString(SourahInformationArticle article, String property) {
        String result = null;

        for (SourahProperty p : article.properties) {
            if (p.name.equals(property)) {
                result = p.value;
            }
        }

        return result;
    }

    private SourahInformationArticle parseArticle(String html, int chapterNumber) {
        html = html.substring(html.indexOf("<div id=\"mw-content-text\" "));
        html = html.substring(0, html.indexOf("<div id=\"mw-navigation\">"));

        SourahInformationArticle article = new SourahInformationArticle();

        article.info = SourahUtils.getSourahInfo(chapterNumber);
        article.properties = extractInfoBox(html);
        article.sections = extractSections(html);

        return article;
    }

    private ArrayList<SourahInformationSection> extractSections(String html) {
        ArrayList<SourahInformationSection> result = new ArrayList<>();
        html = html.replace("<a href=\"/wiki", "<a href=\"https://en.wikipedia.org/wiki");

        html = removeTags(html, "table");
        ArrayList<String> tags = HtmlUtils.GetSubTags(html, new String[] {"<p>", "<h2>", "<div class=\"reflist "});

        SourahInformationSection section = new SourahInformationSection();

        for (String tag : tags) {
            if (tag.startsWith("<h2")) {
                if (section.isValid()) {
                    result.add(section);
                }
                section = new SourahInformationSection();

                String title = tag;
                if (title.contains("<span class=\"mw-editsection\">")) {
                    title = title.substring(0, title.indexOf("<span class=\"mw-editsection\">"));
                }

                section.header = HtmlUtils.RemoveTags(title);
            } else if (tag.startsWith("<p")) {
                String t = HtmlUtils.RemoveTags(tag).trim();
                if (t.equals(""))
                    continue;

                section.paragraphs.add(tag);
            } else if (tag.startsWith("<div class=\"reflist ")) {
                section.content = tag;
            }
        }

        if (section.isValid()) {
            result.add(section);
        }

//        String temp = "";
//
//        for (SourahInformationSection s : result) {
//            temp += "<h2>" + s.header + "</h2>";
//            for (int i = 0; i < s.paragraphs.size(); i++) {
//                temp += s.paragraphs.get(i);
//            }
//
//            if (s.content != null)
//                temp += s.content;
//        }
//
//        System.out.println(temp);

        return result;
    }

    private String removeTags(String html, String tag) {
        int index = 0;

        while ((index = html.indexOf("<" + tag, index)) > 0) {
            html = html.substring(0, index) + html.substring(html.indexOf("</" + tag + ">", index) + 3 + tag.length());
            index = 0;
        }

        return html;
    }

    private ArrayList<String> properties = new ArrayList<>();

    private ArrayList<SourahProperty> extractInfoBox(String html) {
        ArrayList<SourahProperty> result = new ArrayList<>();

        if (html.contains("<table class=\"infobox\" style=\"width:22em\">")) {
            String infoBox = HtmlUtils.ReadTag(html, "<table class=\"infobox\" style=\"width:22em\">");
            String[] parts = infoBox.split("<tr>");

            for (int i = 0; i < parts.length; i++) {
                parts[i] = parts[i].trim();
                if (parts[i].startsWith("<th scope=\"row\" style=\"width:50%\">")) {
                    String property = HtmlUtils.RemoveTags(parts[i].substring(0, parts[i].indexOf("<td>")));
                    String value = HtmlUtils.RemoveTags(parts[i].substring(parts[i].indexOf("<td>")));

                    if (!property.equals("Classification") && !property.equals("Number of Rukus")) {
                        SourahProperty p = new SourahProperty();

                        p.name = property;
                        p.value = value;

                        result.add(p);

                        if (!properties.contains(property)) {
                            properties.add(property);
                        }
                    }
                }
            }
        }

        return result;
    }
}

class SourahProperty {
    public String name = "";
    public String value = "";
}

class SourahInformationArticle {
    public ArrayList<SourahProperty> properties;
    public SourahInfo info;
    public ArrayList<SourahInformationSection> sections;

    public String serialize() {
        Gson gson = new GsonBuilder().create();
        return gson.toJson(this);
    }
}

class SourahInformationSection {
    public String header = "";
    public ArrayList<String> paragraphs = new ArrayList<>();
    public String content = null;

    public boolean isValid() {
        return paragraphs.size() > 0 || content != null;
    }
}
