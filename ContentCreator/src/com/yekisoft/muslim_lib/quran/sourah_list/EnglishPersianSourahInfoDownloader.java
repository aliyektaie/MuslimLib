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

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by yektaie on 8/5/16.
 */
public class EnglishPersianSourahInfoDownloader implements IContentDownloader {
    private final Connection connection;

    public EnglishPersianSourahInfoDownloader() {
        this.connection = Utils.getDatabaseConnection(SourahUtils.SOURAH_LIST_FILE_PATH);
    }

    @Override
    public boolean needDownload() {
        boolean result = true;

        try {
            String sql = "select count(*) from list where title_en is null";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                result = count > 0;
            }
            rs.close();
            statement.close();
        } catch (Exception ignored) {
        }

        return result;
    }

    @Override
    public void downloadAndSaveContent() {
        String html = downloadListOfSourahTable();
        ArrayList<SourahInfo> list = parseSourahInfo(html);

        for (SourahInfo sourahInfo : list) {
            saveSourahInfo(sourahInfo);
        }

    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        ArrayList<ContentFile> result = new ArrayList<>();

        result.add(createSourahListFile());

        return result;
    }

    private ContentFile createSourahListFile() {
        ContentFile file = new ContentFile();

        file.Content = createSourahListContent();
        file.FilePath = "/Content/Quran/SourahList";
        file.ID = new Guid("9fdaf5f6-e8cd-4c6a-82f8-5a63d3635557");
        file.Title = "Sourah List";
        file.Type = ContentFileType.Text;

        return file;
    }

    private String createSourahListContent() {
        ArrayList<SourahInfo> infos = new ArrayList<>();

        for (int i = 1; i <= 114; i++) {
            infos.add(SourahUtils.getSourahInfo(connection, i));
        }

        Gson gson = new GsonBuilder().create();
        return gson.toJson(infos);
    }

    public static String downloadListOfSourahTable() {
        String html = Utils.getUrlContent("https://en.wikipedia.org/wiki/List_of_surahs_in_the_Quran");
        html = html.substring(html.indexOf("<table class=\"wikitable sortable\" style=\"margin: 1em auto 1em auto;\">"));
        html = html.substring(0, html.indexOf("</table>"));
        return html;
    }

    @Override
    public String getTitle() {
        return "Quran Sourah English & Persian Info Downloader";
    }

    @Override
    public void terminate() {
        try {
            connection.commit();
            connection.close();
        } catch (SQLException ignored) {

        }
    }

    @Override
    public String getBankName() {
        return "content-quran.db";
    }

    private ArrayList<SourahInfo> parseSourahInfo(String html) {
        ArrayList<SourahInfo> list = new ArrayList<>();

        String[] lines = html.split("<tr>");
        for (int i = 2; i < lines.length; i++) {
            String[] parts = lines[i].split("<td>");

            SourahInfo info = new SourahInfo();

            info.orderInBook = Integer.parseInt(HtmlUtils.RemoveTags(parts[1]));
            info.titleEnglish = getEnglishTitle(HtmlUtils.RemoveTags(parts[2])).trim();
            info.titleEnglishTranslation = HtmlUtils.RemoveTags(parts[4]).trim();
            info.titleEnglishReference = getEnglishReference(HtmlUtils.RemoveTags(parts[10])).trim();
            info.contentThemeEnglish = getContentTheme(HtmlUtils.RemoveTags(parts[11])).trim();
            info.titlePersianReference = translateReferenceToPersian(info.titleEnglishReference).trim();
            info.contentThemePersian = translateContentToPersian(info.contentThemeEnglish);

            list.add(info);
        }
        return list;
    }

    private String translateContentToPersian(String content) {
        return "";
//        String[] parts = content.split("\r\n");
//        String result = "";
//
//        for (String line : parts) {
//            String translated = Utils.translate(content, "en", "fa");
//
//            result += "\r\n" + translated;
//        }
//
//        return result.trim();
    }

    private String translateReferenceToPersian(String reference) {
        String result = "";

        if (reference.equals("Whole Surah")) {
            result = "محتوای کلی سوره";
        } else if (isReferenceVersesRange(reference)) {
            String[] parts = reference.substring(3).split("-");
            int begin = Integer.parseInt(parts[0]);
            int end = Integer.parseInt(parts[1]);

            result = String.format("آیات %s تا %s", toPersianDigits(begin), toPersianDigits(end));
        } else if (isReferenceVersesListOfNumber(reference)) {
            String[] parts = reference.substring(3).replace(" ", "").split(",");
            if (parts.length > 2) {
                throw new RuntimeException();
            }
            int begin = Integer.parseInt(parts[0]);
            int end = Integer.parseInt(parts[1]);

            result = String.format("آیات %s و %s", toPersianDigits(begin), toPersianDigits(end));
        } else if (isReferenceVersesSingleNumber(reference)) {
            reference = reference.substring(3).replace("ff.", "");
            int verse = Integer.parseInt(reference);

            result = String.format("آیه‌ی %s", toPersianDigits(verse));
        }

        return result;
    }

    private boolean isReferenceVersesListOfNumber(String reference) {
        boolean result = reference.startsWith("v. ");

        if (result) {
            reference = reference.substring(3).replace(" ", "");
            String[] parts = reference.split(",");
            if (parts.length > 1) {
                result = true;
            } else {
                result = false;
            }
        }

        return result;
    }

    private boolean isReferenceVersesSingleNumber(String reference) {
        boolean result = reference.startsWith("v. ");

        if (result) {
            reference = reference.substring(3).replace("ff.", "");
            try {
                Integer.parseInt(reference);
            } catch (Exception ignored) {
                result = false;
            }
        }

        return result;
    }

    private String toPersianDigits(int number) {
        String result = String.valueOf(number);

        result = result.replace("0", "۰");
        result = result.replace("1", "۱");
        result = result.replace("2", "۲");
        result = result.replace("3", "۳");
        result = result.replace("4", "۴");
        result = result.replace("5", "۵");
        result = result.replace("6", "۶");
        result = result.replace("7", "۷");
        result = result.replace("8", "۸");
        result = result.replace("9", "۹");

        return result;
    }

    private boolean isReferenceVersesRange(String reference) {
        boolean result = reference.startsWith("v. ");

        if (result) {
            reference = reference.substring(3);
            String[] parts = reference.split("-");
            if (parts.length == 2) {
                result = true;
            } else {
                result = false;
            }
        }

        return result;
    }

    private String getContentTheme(String html) {
        String[] parts = html.split("<li>");
        String result = "";

        if (html.contains("<li>")) {
            for (int i = 1; i < parts.length; i++) {
                String content = HtmlUtils.RemoveTags(parts[i]);

                result += ("\r\n" + content);
            }
        } else {
            result = HtmlUtils.RemoveTags(html);
        }

        result = result.replace("[6]", "");
        result = result.replace("[7]", "");
        result = result.replace("[8]", "");
        result = result.replace("[9]", "");
        result = result.replace("[10]", "");

        return result;
    }

    private String getEnglishReference(String html) {
        if (html.contains("[")) {
            html = html.substring(0, html.indexOf("["));
        }

        return html;
    }

    private String getEnglishTitle(String html) {
        if (html.contains("[notes")) {
            html = html.substring(0, html.indexOf("[notes"));
        }

        return html;
    }

    private void saveSourahInfo(SourahInfo info) {
        try {
            PreparedStatement statement = connection.prepareStatement("UPDATE list SET title_en = ?, title_en_translation = ?, title_en_reference = ?, theme_en = ?, title_fa_reference = ?, theme_fa = ? WHERE id = ?");

            statement.setString(1, info.titleEnglish);
            statement.setString(2, info.titleEnglishTranslation);
            statement.setString(3, info.titleEnglishReference);
            statement.setString(4, info.contentThemeEnglish);
            statement.setString(5, info.titlePersianReference);
            statement.setString(6, info.contentThemePersian);
            statement.setInt(7, info.orderInBook);
            statement.executeUpdate();

            connection.commit();
        } catch (SQLException ignored) {

        }
    }

}
