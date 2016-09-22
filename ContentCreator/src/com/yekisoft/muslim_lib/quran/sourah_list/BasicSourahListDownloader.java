package com.yekisoft.muslim_lib.quran.sourah_list;

import com.yekisoft.muslim_lib.IContentDownloader;
import com.yekisoft.muslim_lib.core.HtmlUtils;
import com.yekisoft.muslim_lib.core.Utils;
import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.quran.SourahInfo;
import com.yekisoft.muslim_lib.quran.SourahUtils;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Objects;

import static java.awt.SystemColor.info;

/**
 * Created by yektaie on 8/5/16.
 */
public class BasicSourahListDownloader implements IContentDownloader {
    private final Connection connection;

    public BasicSourahListDownloader() {
        this.connection = Utils.getDatabaseConnection(SourahUtils.SOURAH_LIST_FILE_PATH);
    }

    @Override
    public boolean needDownload() {
        boolean result = true;

        try {
            String sql = "select count(*) from list";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                result = count < 114;
            }
            rs.close();
            statement.close();
        } catch (Exception ignored) {
        }

        if (result) {
            createDatabaseFile();
            createSourahTable();
        }

        return result;
    }

    private void createDatabaseFile() {
        File file = new File(SourahUtils.SOURAH_LIST_FILE_PATH);
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException ignored) {

            }
        }
    }

    private void createSourahTable() {
        PreparedStatement statement = null;
        try {
            statement = connection.prepareStatement("CREATE TABLE `list` (\n" +
                    "\t`id`\tINTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\n" +
                    "\t`title_ar`\tTEXT NOT NULL,\n" +
                    "\t`title_en`\tTEXT,\n" +
                    "\t`book_order`\tINTEGER NOT NULL,\n" +
                    "\t`alphabetic_order`\tINTEGER NOT NULL,\n" +
                    "\t`verse_count`\tINTEGER NOT NULL,\n" +
                    "\t`nozul_order`\tINTEGER NOT NULL,\n" +
                    "\t`place_of_nozul`\tINTEGER NOT NULL,\n" +
                    "\t`title_en_translation`\tTEXT,\n" +
                    "\t`title_en_reference`\tTEXT,\n" +
                    "\t`title_fa_reference`\tTEXT,\n" +
                    "\t`word_count`\tINTEGER,\n" +
                    "\t`letter_count`\tINTEGER,\n" +
                    "\t`moghataat_en`\tTEXT,\n" +
                    "\t`moghataat_ar`\tTEXT,\n" +
                    "\t`sijdah_count`\tTEXT,\n" +
                    "\t`theme_en`\tTEXT,\n" +
                    "\t`theme_fa`\tTEXT\n" +
                    ");");
            statement.executeUpdate();

            connection.commit();
        } catch (SQLException ignored) {

        }
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
        return null;
    }

    private int getPlaceOfReception(String place) {
        if (Objects.equals(place, "مکه")) {
            return SourahInfo.RECEPTION_PLACE_MAKI;
        } else if (Objects.equals(place, "مدینه")) {
            return SourahInfo.RECEPTION_PLACE_MADANI;
        }

        throw new RuntimeException();
    }

    @Override
    public String getTitle() {
        return "Quran Sourah List Downloader";
    }

    @Override
    public void terminate() {
        try {
            connection.commit();
            connection.close();
        } catch (SQLException ignored) {

        }
    }

    public static String downloadListOfSourahTable() {
        String html = Utils.getUrlContent("https://fa.wikipedia.org/wiki/%D9%81%D9%87%D8%B1%D8%B3%D8%AA_%D8%B3%D9%88%D8%B1%D9%87%E2%80%8C%D9%87%D8%A7%DB%8C_%D9%82%D8%B1%D8%A2%D9%86");

        html = html.substring(html.indexOf("<table>"));
        html = html.substring(0, html.indexOf("</table>"));

        return html;
    }

    private ArrayList<SourahInfo> parseSourahInfo(String html) {
        ArrayList<SourahInfo> list = new ArrayList<>();

        String[] lines = html.split("<tr>");
        for (int i = 3; i < lines.length; i++) {
            String[] parts = lines[i].split("<td>");

            SourahInfo info = new SourahInfo();

            info.orderInBook = Integer.parseInt(HtmlUtils.RemoveTags(parts[1]));
            info.orderInAlphabetic = Integer.parseInt(HtmlUtils.RemoveTags(parts[2]));
            info.titleArabic = HtmlUtils.RemoveTags(parts[3]);
            info.verseCount = Integer.parseInt(HtmlUtils.RemoveTags(parts[4]));
            info.orderInReception = Integer.parseInt(HtmlUtils.RemoveTags(parts[5]));
            info.receptionPlace = getPlaceOfReception(HtmlUtils.RemoveTags(parts[6]).trim());

            list.add(info);
        }
        return list;
    }

    private void saveSourahInfo(SourahInfo info) {
        try {
            PreparedStatement statement = connection.prepareStatement("INSERT INTO list (title_ar, book_order, alphabetic_order, verse_count, nozul_order, place_of_nozul) VALUES(?,?,?,?,?,?)");

            statement.setString(1, info.titleArabic);
            statement.setInt(2, info.orderInBook);
            statement.setInt(3, info.orderInAlphabetic);
            statement.setInt(4, info.verseCount);
            statement.setInt(5, info.orderInReception);
            statement.setInt(6, info.receptionPlace);
            statement.executeUpdate();

            connection.commit();
        } catch (SQLException ignored) {

        }
    }
}
