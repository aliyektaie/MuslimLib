package com.yekisoft.muslim_lib.core;

import java.util.ArrayList;

/**
 * Created by yektaie on 8/5/16.
 */
public class HtmlTag {

    public boolean hasEnd;
    public String type;
    public ArrayList<TagAttribute> attributes = new ArrayList<>();
    public ArrayList<HtmlTag> tags = new ArrayList<>();
    public String innerContent;

    @Override
    public String toString() {
        String result = "";

        if (hasContent()) {
            result = String.format("[%s => %s]", type, innerHtml());
        } else {
            result = type;
        }
        return result;
    }

    public boolean hasContent() {
        return !innerHtml().trim().equals("");
    }

    public boolean hasAttribute(String name, String value) {
        boolean result = false;

        for (int i = 0; i < attributes.size(); i++) {
            TagAttribute a = attributes.get(i);

            if (a.name.equals(name)) {
                String[] classes = a.value.split(" ");
                for (int j = 0; j < classes.length; j++) {
                    if (classes[j].equals(value)) {
                        return true;
                    }
                }
            }
        }

        return result;
    }

    public HtmlTag getChildWithClass(String type, String cls) {
        return getChildWithClass(type, cls, false);
    }

    public HtmlTag getChildWithClass(String type, String cls, boolean recursive) {
        HtmlTag result = null;

        for (int i = 0; i < tags.size(); i++) {
            HtmlTag tag = tags.get(i);

            if (tag.type.equals(type) && tag.hasAttribute("class", cls)) {
                result = tag;
                break;
            }

            if (recursive) {
                HtmlTag temp = tag.getChildWithClass(type, cls, true);
                if (temp != null) {
                    result = temp;
                    break;
                }
            }
        }

        return result;
    }

    public String innerHtml() {
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < tags.size(); i++) {
            if (tags.get(i).innerContent != null) {
                result.append(tags.get(i).innerContent);
            } else {
                result.append(String.format("<%s>%s</%s>", tags.get(i).type.toLowerCase(), tags.get(i).innerHtml(), tags.get(i).type.toLowerCase()));
            }
        }

        return result.toString();
    }

    public ArrayList<HtmlTag> getChildrenWithClass(String type, String cls, boolean recursive) {
        ArrayList<HtmlTag> result = new ArrayList<>();

        for (int i = 0; i < tags.size(); i++) {
            HtmlTag tag = tags.get(i);

            if (tag.type.equals(type) && (cls == null || tag.hasAttribute("class", cls))) {
                result.add(tag);
            }

            if (recursive) {
                ArrayList<HtmlTag> temp = tag.getChildrenWithClass(type, cls, true);
                if (temp != null) {
                    result.addAll(temp);
                }
            }
        }

        return result;
    }
}
