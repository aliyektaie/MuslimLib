package com.yekisoft.muslim_lib.quran.sourah_list;

import com.yekisoft.muslim_lib.IContentDownloader;
import com.yekisoft.muslim_lib.core.HtmlUtils;
import com.yekisoft.muslim_lib.core.Utils;
import com.yekisoft.muslim_lib.core.trie.content.ContentFile;
import com.yekisoft.muslim_lib.quran.SourahUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by yektaie on 8/9/16.
 */
public class SourahWordAndLetterCountDownloader implements IContentDownloader {
    private final Connection connection;
    private final String CACHED_FILE_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Original/Quran/Sourah Statistics.htm";

    public SourahWordAndLetterCountDownloader() {
        this.connection = Utils.getDatabaseConnection(SourahUtils.SOURAH_LIST_FILE_PATH);
    }
    @Override
    public boolean needDownload() {
        boolean result = true;

        try {
            String sql = "select count(*) from list where word_count is null";
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
        String html = downloadStatisticsPage();
        html = html.substring(html.indexOf("<table "));
        html = html.substring(0, html.indexOf("</table>"));

        String[] parts = html.split("<tr>");
        for (int i = 2; i < parts.length; i++) {
            String[] tds = parts[i].split("<td ");

            int chapterIndex = Integer.valueOf(HtmlUtils.RemoveTags("<" + tds[1]).trim());
            int wordIndex = Integer.valueOf(HtmlUtils.RemoveTags("<" + tds[4]).trim());
            int letterIndex = Integer.valueOf(HtmlUtils.RemoveTags("<" + tds[5]).trim());

            try {
                PreparedStatement statement = connection.prepareStatement("UPDATE list SET word_count = ?, letter_count = ? WHERE id = ?");

                statement.setInt(1, wordIndex);
                statement.setInt(2, letterIndex);
                statement.setInt(3, chapterIndex);
                statement.executeUpdate();
            } catch (SQLException ignored) {

            }

        }
    }

    private String downloadStatisticsPage() {
        String result = "";
        if (Utils.fileExists(CACHED_FILE_PATH)) {
            result = Utils.readTextFile(CACHED_FILE_PATH);
        } else {
            result = Utils.getUrlContent("http://tahaquran.ir/%D8%A7%D8%B7%D9%84%D8%A7%D8%B9%D8%A7%D8%AA/");
            Utils.writeTextFile(CACHED_FILE_PATH, result);
        }

        return result;
    }

    @Override
    public ArrayList<ContentFile> getContentFiles() {
        return null;
    }

    @Override
    public String getTitle() {
        return "Sourah Statistics Downloader";
    }

    @Override
    public void terminate() {
        try {
            connection.commit();
        } catch (SQLException ignored) {

        }

        try {
            connection.close();
        } catch (SQLException ignored) {

        }
    }
}
