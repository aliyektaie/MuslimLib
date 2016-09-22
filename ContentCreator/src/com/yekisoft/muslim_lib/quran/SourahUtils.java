package com.yekisoft.muslim_lib.quran;

import com.yekisoft.muslim_lib.core.Utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Created by yektaie on 8/8/16.
 */
public class SourahUtils {
    public static final String SOURAH_LIST_FILE_PATH = "/Volumes/Files/Projects/MuslimLib/Content/Processed/Quran/List of Sourah.db";

    public static SourahInfo getSourahInfo(int chapterNumber) {
        Connection connection = Utils.getDatabaseConnection(SOURAH_LIST_FILE_PATH);
        SourahInfo result = getSourahInfo(connection, chapterNumber);

        try {
            connection.close();
        } catch (SQLException ignored) {
        }

        return result;
    }

    public static SourahInfo getSourahInfo(Connection connection, int chapterNumber) {
        SourahInfo info = new SourahInfo();

        try {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM list WHERE book_order = " + chapterNumber + ";");

            if (rs.next()) {
                info.titleArabic = rs.getString("title_ar");
                info.titleEnglish = rs.getString("title_en");
                info.orderInBook = rs.getInt("book_order");
                info.orderInAlphabetic = rs.getInt("alphabetic_order");
                info.verseCount = rs.getInt("verse_count");
                info.orderInReception = rs.getInt("nozul_order");
                info.receptionPlace = rs.getInt("place_of_nozul");
                info.titleEnglishTranslation = rs.getString("title_en_translation");
                info.titleEnglishReference = rs.getString("title_en_reference");
                info.titlePersianReference = rs.getString("title_fa_reference");
                info.contentThemeEnglish = rs.getString("theme_en");
                info.contentThemePersian = rs.getString("theme_fa");
                info.wordCount = rs.getInt("word_count");
                info.letterCount = rs.getInt("letter_count");
                info.sijdahCount = rs.getInt("sijdah_count");
                info.moghataatEnglish = rs.getString("moghataat_en");
                info.moghataatArabic = rs.getString("moghataat_ar");
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            System.exit(0);
        }

        return info;
    }
}
