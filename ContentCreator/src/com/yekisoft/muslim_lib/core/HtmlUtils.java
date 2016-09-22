package com.yekisoft.muslim_lib.core;

import java.util.ArrayList;
import java.util.Stack;

/**
 * Created by yektaie on 8/5/16.
 */
public class HtmlUtils {

    public static String ReadTag(String html, int begin) {
        html = html.substring(begin);
        int indexSpace = html.indexOf(" ");
        if (indexSpace == -1) {
            indexSpace = html.length();

        }
        int end = Math.min(indexSpace, html.indexOf(">"));
        String tag = html.substring(1, end);
        int depth = 1;
        int index = 1;

        while (depth > 0 && index < html.length()) {
            String temp = "";

            if (index + 2 + tag.length() < html.length()) {
                temp = html.substring(index, 2 + tag.length() + index);

                if (temp.equals("<" + tag + " ") || temp.equals("<" + tag + ">")) {
                    depth++;
                    index++;

                    continue;
                }
            }

            if (index + 3 + tag.length() < html.length()) {
                temp = html.substring(index, 3 + tag.length() + index);
                if (temp.equals("</" + tag + ">")) {
                    depth--;
                    index++;

                    continue;
                }
            }

            index++;
        }

        return html.substring(0, Math.min(index + 2 + tag.length(), html.length()));
    }

    public static String RemoveTags(String html) {
        StringBuilder result = new StringBuilder();
        boolean isInTag = false;

        for (int i = 0; i < html.length(); i++) {
            if (html.charAt(i) == '<') {
                isInTag = true;
                continue;
            }
            if (html.charAt(i) == '>') {
                isInTag = false;
                continue;
            }

            if (!isInTag) {
                result.append(html.charAt(i) + "");
            }
        }

        String ret = result.toString().trim();

        while (ret.contains("  ")) {
            ret = ret.replace("  ", " ");
        }

        return ret;
    }

    public static String RemoveTag(String html, String tag) {
        String temp = "</" + tag + ">";
        html = html.replace(temp, " ");

        temp = "<" + tag + ">";
        html = html.replace(temp, " ");

        temp = "<" + tag + " ";
        while (html.contains(temp)) {
            int index = html.indexOf(temp);
            int end = html.indexOf(">", index);

            html = html.substring(0, index) + " " + html.substring(end + 1);
        }

        while (html.contains("  ")) {
            html = html.replace("  ", " ");
        }

        return html;
    }

    public static ArrayList<String> GetSubTags(String html, String tag) {
        ArrayList<String> result = new ArrayList<>();
        int index = 0;

        while ((index = html.indexOf(tag, index)) > 0) {
            result.add(ReadTag(html, index));
            index++;
        }

        return result;
    }

    public static String ReadTag(String html, String string) {
        return ReadTag(html, html.indexOf(string));
    }

    public static ArrayList<String> GetSubTags(String html, String[] tags) {
        ArrayList<String> result = new ArrayList<>();
        int index = 0;

        while ((index = getMinIndexOf(html, tags, index)) > 0) {
            result.add(ReadTag(html, index));
            index++;
        }

        return result;
    }

    private static int getMinIndexOf(String html, String[] tags, int start) {
        int result = -1;

        for (int i = 0; i < tags.length; i++) {
            int index = html.indexOf(tags[i], start);
            if (index > 0) {
                if (result == -1) {
                    result = index;
                } else {
                    result = Math.min(index, result);
                }
            }
        }

        return result;
    }

    public static String mapChars(String html) {
        html = html.replace("&amp;", "&");
        html = html.replace("&#8242;", "'");
        html = html.replace("&#039;", "'");
        html = html.replace("&prime;", "'");
        html = html.replace("&nbsp;", " ");
        html = html.replace("&quot;", "\"");
        html = html.replace("&copy;", "©");
        html = html.replace("&ldquo;", "“");
        html = html.replace("&rdquo;", "”");
        html = html.replace("&oacute;", "ó");
        html = html.replace("&ntilde;", "ñ");
        html = html.replace("&uacute;", "ú");
        html = html.replace("&aacute;", "á");
        html = html.replace("&eacute;", "é");
        html = html.replace("&pound;", "£");
        html = html.replace("&iacute;", "í");
        html = html.replace("&hellip;", "…");
        html = html.replace("&iquest;", "¿");
        html = html.replace("&iexcl;", "¡");
        html = html.replace("&uuml;", "ü");
        html = html.replace("&#8217;", "’");
        html = html.replace("&mdash;", "—");
        html = html.replace("&Oacute;", "Ó");
        html = html.replace("&ograve;", "ò");
        html = html.replace("&Aacute;", "Á");
        html = html.replace("&ccedil;", "ç");
        html = html.replace("&ecirc;", "ê");
        html = html.replace("&agrave;", "à");
        html = html.replace("&Ntilde;", "Ñ");
        html = html.replace("&iuml;", "ï");
        html = html.replace("&laquo;", "«");
        html = html.replace("&raquo;", "»");
        html = html.replace("&Uacute;", "Ú");
        html = html.replace("&trade;", "™");
        html = html.replace("&Iacute;", "Í");
        html = html.replace("&egrave;", "è");
        html = html.replace("&#8218;", "‚");
        html = html.replace("&Eacute;", "É");
        html = html.replace("&deg;", "°");
        html = html.replace("&#8773;", "≅");
        html = html.replace("&Otilde;", "Õ");
        html = html.replace("&acirc;", "â");
        html = html.replace("&ocirc;", "ô");
        html = html.replace("&aelig;", "æ");
        html = html.replace("&Uuml;", "Ü");
        html = html.replace("&#650;", "ʊ");
        html = html.replace("&AElig;", "Æ");
        html = html.replace("&icirc;", "î");
        html = html.replace("&frac14;", "¼");
        html = html.replace("&reg;", "®");
        html = html.replace("&eth;", "ð");
        html = html.replace("&#601;", "ə");
        html = html.replace("&#712;", "ˈ");
        html = html.replace("&#618;", "ɪ");
        html = html.replace("&uml;", "¨");
        html = html.replace("&#720;", "ː");
        // html = html.replace("&;", "");
        // html = html.replace("&;", "");
        // html = html.replace("&;", "");
        // html = html.replace("&;", "");
        // html = html.replace("&;", "");
        // html = html.replace("&;", "");
        // html = html.replace("&;", "");
        // html = html.replace("&;", "");

        if (html.contains("&")) {
            // System.err.println("map chars: " + html);
            // throw new RuntimeException(html);
        }

        return html;
    }

    public static ArrayList<HtmlTag> SplitTags(String html) {
        html = removeComments(html);
        Stack<HtmlTag> stack = new Stack<>();
        ArrayList<String> tokens = splitTokens(html);
        HtmlTag result = new HtmlTag();
        HtmlTag current = result;

        for (int i = 0; i < tokens.size(); i++) {
            String token = tokens.get(i);
            if (isBeginEndTag(token)) {
                HtmlTag tag = new HtmlTag();
                tag.hasEnd = true;
                tag.type = getTagType(token);
                tag.attributes = getTagAttributes(token);

                current.tags.add(tag);
            } else if (isEndTag(token)) {
                if (stack.size() > 0) {
                    current = stack.pop();
                }
            } else if (isBeginTag(token)) {
                HtmlTag tag = new HtmlTag();
                tag.hasEnd = false;
                tag.type = getTagType(token);
                tag.attributes = getTagAttributes(token);

                current.tags.add(tag);
                stack.push(current);
                current = tag;
            } else {
                HtmlTag t = new HtmlTag();
                t.innerContent = token;
                t.type = "";
                current.tags.add(t);
            }
        }

        return result.tags;
    }

    private static String removeComments(String html) {
        StringBuilder result = new StringBuilder();
        String[] parts = html.split("<!--");

        for (int i = 0; i < parts.length; i++) {
            if (parts[i].contains("-->")) {
                parts[i] = parts[i].substring(parts[i].indexOf("-->") + 3);
            }
            result.append(parts[i]);
        }

        return result.toString();
    }

    private static ArrayList<TagAttribute> getTagAttributes(String token) {
        ArrayList<TagAttribute> result = new ArrayList<>();

        if (token.contains(" ")) {
            token = token.substring(token.indexOf(" ")).replace(">", "").trim();
            token = token.replace("'", "\"");
            String[] parts = token.split("\"");

            for (int i = 0; i < parts.length / 2; i++) {
                TagAttribute att = new TagAttribute();
                att.name = parts[i * 2].replace("=", "").trim();
                att.value = parts[i * 2 + 1];

                result.add(att);
            }
        }

        return result;
    }

    private static String getTagType(String token) {
        token = token.substring(1);
        int index = token.indexOf(">");
        if (index == -1) {
            index = token.length();
        }
        index = Math.min(index, token.indexOf(" ") > 0 ? token.indexOf(" ") : index);

        return token.substring(0, index);
    }

    private static boolean isEndTag(String token) {
        return token.startsWith("</");
    }

    private static boolean isBeginTag(String token) {
        return token.startsWith("<");
    }

    private static boolean isBeginEndTag(String token) {
        return token.startsWith("<") && token.endsWith("/>");
    }

    private static ArrayList<String> splitTokens(String html) {
        ArrayList<String> result = new ArrayList<>();
        StringBuilder temp = new StringBuilder();

        for (int i = 0; i < html.length(); i++) {
            char c = html.charAt(i);

            if (temp.length() == 0) {
                temp.append(c);
            } else {
                if (c == '<') {
                    result.add(temp.toString());
                    temp = new StringBuilder();
                    temp.append("<");
                } else if (c == '>') {
                    temp.append(">");
                    result.add(temp.toString());
                    temp = new StringBuilder();
                } else {
                    temp.append(c);
                }
            }
        }

        return result;
    }

    public static String GetTagContent(String html, String tag, boolean removeSubTags) {
        String content = ReadTag(html, tag);

        content = content.substring(content.indexOf(">") + 1);
        content = content.substring(0, content.lastIndexOf("<"));

        if (removeSubTags) {
            content = RemoveTags(content);
        }

        return content;
    }

}
