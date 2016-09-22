package com.yekisoft.muslim_lib.core;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;

/**
 * Created by yektaie on 8/5/16.
 */
public class Utils {

    public static String readTextFile(String path) {
        byte[] content = readBinaryFile(path);
        try {
            return new String(content, "UTF-8");
        } catch (UnsupportedEncodingException e) {
        }

        return null;
    }

    public static void writeTextFile(String path, String content) {
        try {
            FileOutputStream fs = new FileOutputStream(new File(path));
            byte[] array = content.getBytes();
            fs.write(array);

            fs.flush();
            fs.close();
        } catch (Exception e) {
        }
    }

    public static byte[] readBinaryFile(String path) {
        byte[] result = null;
        try {
            FileInputStream fs = new FileInputStream(new File(path));
            int length = fs.available();
            byte[] content = new byte[length];
            fs.read(content);

            result = content;

            fs.close();
        } catch (Exception e) {
            // e.printStackTrace();
        }

        return result;
    }

    public static void CopyFile(String from, String to) {
        if (from.endsWith(".DS_Store")) {
            return;
        }

        String toFolder = to.substring(0, to.lastIndexOf("/") + 1);
        createFolder(toFolder);

        try {
            FileInputStream in = new FileInputStream(from);
            FileOutputStream out = new FileOutputStream(to);

            int length = in.available();
            byte[] buffer = new byte[length];

            in.read(buffer);
            in.close();

            out.write(buffer);
            out.flush();
            out.close();
        } catch (Exception ex) {
        }
    }

    public static void createFolder(String path) {
        File folder = new File(path);

        if (!folder.exists()) {
            folder.mkdir();
        }
    }

    public static ArrayList<String> getAllFiles(String folderPath) {
        ArrayList<String> result = new ArrayList<>();
        File folder = new File(folderPath);

        for (final File fileEntry : folder.listFiles()) {
            if (fileEntry.isDirectory()) {
                result.addAll(getAllFiles(fileEntry.getAbsolutePath()));
            } else {
                result.add(fileEntry.getAbsolutePath());
            }
        }

        return result;
    }

    public static String GetFileNameWithoutExtension(String path) {
        String result = path.substring(path.lastIndexOf("/") + 1);
        if (result.contains(".")) {
            result = result.substring(0, result.lastIndexOf("."));
        }

        return result;
    }

    public static boolean fileExists(String path) {
        File file = new File(path);

        return file.exists();
    }

    public static String GetDirectoryName(String path) {
        return path.substring(0, path.lastIndexOf("/"));
    }

    public static void CreateDirectory(String folder) {
        File file = new File(folder);

        if (!file.exists()) {
            file.mkdirs();
        }
    }

    public static void writeBinaryFile(String path, byte[] array) {
        try {
            FileOutputStream fs = new FileOutputStream(new File(path));
            fs.write(array);

            fs.flush();
            fs.close();
        } catch (Exception e) {
        }
    }

    public static boolean folderExists(String path) {
        File file = new File(path);

        return file.exists();
    }

    public static byte[] downloadFile(String urlString) {
        InputStream input = null;
        HttpURLConnection connection = null;
        byte[] result = null;
        int indexOnResult = 0;

        try {
            URL url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();

            connection.connect();

            if (connection.getResponseCode() != HttpURLConnection.HTTP_OK) {
                return null;
            }

            int fileLength = connection.getContentLength();
            result = new byte[fileLength];

            // download the file
            input = connection.getInputStream();

            byte data[] = new byte[4096];
            int count;
            while ((count = input.read(data)) != -1) {
                for (int i = 0; i < count; i++) {
                    result[indexOnResult] = data[i];
                    indexOnResult++;
                }
            }
        } catch (Exception e) {
            return null;
        } finally {
            try {
                if (input != null)
                    input.close();
            } catch (IOException ignored) {
            }

            if (connection != null)
                connection.disconnect();
        }

        return result;
    }

    public static String getUrlContent(String urlString) {
        byte[] content = downloadUrlRawContent(urlString);
        return new String(content, StandardCharsets.UTF_8);
    }

    private static byte[] downloadUrlRawContent(String urlString) {
        InputStream input = null;
        HttpURLConnection connection = null;
        byte[] result = null;

        try {
            URL url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestProperty("Accept-Charset", "UTF-8");
            connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36");

            connection.connect();

            if (connection.getResponseCode() != HttpURLConnection.HTTP_OK) {
                return null;
            }

            // download the file
            input = connection.getInputStream();
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            byte data[] = new byte[4096];
            int count;
            while ((count = input.read(data)) != -1) {
                for (int i = 0; i < count; i++) {
                    outputStream.write(data[i]);
                }
            }

            result = outputStream.toByteArray();
        } catch (Exception e) {
            return null;
        } finally {
            try {
                if (input != null)
                    input.close();
            } catch (IOException ignored) {
            }

            if (connection != null)
                connection.disconnect();
        }

        return result;
    }

    public static ArrayList<String> GetDirectories(String sourceFolder) {
        ArrayList<String> result = new ArrayList<>();

        File f = new File(sourceFolder);
        File[] files = f.listFiles();

        for (int i = 0; i < files.length; i++) {
            if (files[i].isDirectory()) {
                result.add(files[i].getAbsolutePath());
            }
        }

        return result;
    }

    public static ArrayList<String> GetFiles(String sourceFolder) {
        ArrayList<String> result = new ArrayList<>();

        File f = new File(sourceFolder);
        File[] files = f.listFiles();

        for (int i = 0; i < files.length; i++) {
            if (!files[i].isDirectory()) {
                result.add(files[i].getAbsolutePath());
            }
        }

        return result;
    }

    public static void CopyFolder(String source, String target) {
        String[] cmd = { "/bin/bash", "-c", "cp -f -R " + source.replace(" ", "\\ ") + " " + target.replace(" ", "\\ ") };
        Process pb;
        try {
            pb = Runtime.getRuntime().exec(cmd);

            String line;
            BufferedReader input = new BufferedReader(new InputStreamReader(pb.getInputStream()));
            while ((line = input.readLine()) != null) {
                System.out.println(line);
            }
            input.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String hash(byte[] data) {
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");
            md.update(data);
            byte[] mdbytes = md.digest();

            // convert the byte to hex format method 1
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < mdbytes.length; i++) {
                sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16).substring(1));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static String[] toStringArray(ArrayList<String> result) {
        String[] r = new String[result.size()];

        for (int i = 0; i < r.length; i++) {
            r[i] = result.get(i);
        }

        return r;
    }

    public static Connection getDatabaseConnection(String dbPath) {
        Connection c = null;
        try {
            Class.forName("org.sqlite.JDBC");
            c = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }

        return c;
    }
}