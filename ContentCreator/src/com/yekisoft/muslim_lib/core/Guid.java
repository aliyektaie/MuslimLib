package com.yekisoft.muslim_lib.core;

import java.util.Random;

/**
 * Created by yektaie on 8/5/16.
 */
public class Guid {
    private String _value = null;

    public Guid(String guid) {
        _value = guid;
    }

    public Guid(byte[] guid) {
        byte[] raw = new byte[16];

        raw[3] = guid[0];
        raw[2] = guid[1];
        raw[1] = guid[2];
        raw[0] = guid[3];
        raw[5] = guid[4];
        raw[4] = guid[5];
        raw[7] = guid[6];
        raw[6] = guid[7];
        raw[8] = guid[8];
        raw[9] = guid[9];
        raw[10] = guid[10];
        raw[11] = guid[11];
        raw[12] = guid[12];
        raw[13] = guid[13];
        raw[14] = guid[14];
        raw[15] = guid[15];

        String p1= getStringValue(raw, 0, 8);
        String p2= getStringValue(raw, 8, 4);
        String p3= getStringValue(raw, 12, 4);
        String p4= getStringValue(raw, 16, 4);
        String p5= getStringValue(raw, 20, 12);

        _value = p1 + "-" + p2 + "-" + p3 + "-" + p4 + "-" + p5;
    }

    private String getStringValue(byte[] array, int begin, int length) {
        String result = bytesToHex(array);

        result = result.substring(begin, begin + length);

        return result;
    }

    final protected static char[] hexArray = "0123456789abcdef".toCharArray();
    public static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public static Guid NewGuid() {
        Random random = new Random();

        String p1 = getRandomString(8, random);
        String p2 = getRandomString(4, random);
        String p3 = getRandomString(4, random);
        String p4 = getRandomString(4, random);
        String p5 = getRandomString(12, random);

        String g = p1 + "-" + p2 + "-" + p3 + "-" + p4 + "-" + p5;

        return new Guid(g);
    }

    private static String getRandomString(int length, Random random) {
        String chars = "0123456789abcdef";
        String result = "";

        for (int i = 0; i < length; i++) {
            int index = Math.abs(random.nextInt()) % chars.length();
            result += String.valueOf(chars.charAt(index));
        }

        return  result;
    }

    @Override
    public String toString() {
        return _value;
    }

    @Override
    public boolean equals(Object o) {
        boolean same = o instanceof Guid;

        same = same && ((Guid)o)._value.equals(_value);

        return same;
    }

    public byte[] toByteArray() {
        byte[] raw = toRawArray();
        byte[] result = new byte[16];

        result[0] = raw[3];
        result[1] = raw[2];
        result[2] = raw[1];
        result[3] = raw[0];
        result[4] = raw[5];
        result[5] = raw[4];
        result[6] = raw[7];
        result[7] = raw[6];
        result[8] = raw[8];
        result[9] = raw[9];
        result[10] = raw[10];
        result[11] = raw[11];
        result[12] = raw[12];
        result[13] = raw[13];
        result[14] = raw[14];
        result[15] = raw[15];

        return result;
    }

    private byte[] toRawArray() {
        byte[] result = new byte[16];
        String s = _value.replace("-", "");

        for (int i = 0; i < 16; i++) {
            String digit = s.substring(i * 2, i * 2 + 2);
            byte b = (byte)Integer.parseInt(digit, 16);

            result[i] = b;
        }

        return result;
    }

    public static Guid empty() {
        return new Guid("00000000-0000-0000-0000-000000000000");
    }

    public boolean isEmpty() {
        return _value.equals("00000000-0000-0000-0000-000000000000");
    }
}
