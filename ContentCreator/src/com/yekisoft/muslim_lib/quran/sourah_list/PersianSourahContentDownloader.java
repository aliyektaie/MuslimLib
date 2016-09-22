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
public class PersianSourahContentDownloader implements IContentDownloader {
    private final Connection connection;
    private final String CACHED_FILE_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Original/Quran/Sourah Content (Persian).htm";

    public PersianSourahContentDownloader() {
        this.connection = Utils.getDatabaseConnection(SourahUtils.SOURAH_LIST_FILE_PATH);
    }

    @Override
    public boolean needDownload() {
        boolean result = true;

//        try {
//            String sql = "select count(*) from list where theme_fa = ''";
//            PreparedStatement statement = connection.prepareStatement(sql);
//            ResultSet rs = statement.executeQuery();
//            if (rs.next()) {
//                int count = rs.getInt(1);
//                result = count > 0;
//            }
//            rs.close();
//            statement.close();
//        } catch (Exception ignored) {
//        }

        return result;
    }

    @Override
    public void downloadAndSaveContent() {
        String html = downloadContentSummaryPage();
        html = html.substring(html.indexOf("<B>1- محتوای سوره حمد</B>"));

        String[] parts = html.split("<P ");
        for (int i = 0; i < 227; i += 2) {
            String number = parts[i];
            number = number.substring(number.indexOf("<B>"));
            number = number.substring(3);
            number = number.substring(0, number.indexOf("-"));
            int chapterIndex = Integer.valueOf(HtmlUtils.RemoveTags(number));
            String content = HtmlUtils.RemoveTags("<" + parts[i + 1]).trim();

            while (content.contains("  ")) {
                content = content.replace("  ", "");
            }

            try {
                PreparedStatement statement = connection.prepareStatement("UPDATE list SET theme_fa = ? WHERE id = ?");

                statement.setString(1, content);
                statement.setInt(2, chapterIndex);
                statement.executeUpdate();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

        }
    }

    private String downloadContentSummaryPage() {
        String result = "";
        if (Utils.fileExists(CACHED_FILE_PATH)) {
            result = Utils.readTextFile(CACHED_FILE_PATH);
        } else {
            result = Utils.getUrlContent("http://noor-almobin.blogfa.com/post-197.aspx");
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
        return "Sourah Persian Summary Downloader";
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
