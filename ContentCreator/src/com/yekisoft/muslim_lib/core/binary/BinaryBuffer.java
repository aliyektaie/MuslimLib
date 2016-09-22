package com.yekisoft.muslim_lib.core.binary;

import com.yekisoft.muslim_lib.core.date.DateTime;

import java.io.UnsupportedEncodingException;
import java.util.Base64;

/**
 * Created by yektaie on 8/5/16.
 */
public class BinaryBuffer {
    private static final String DEFAULT_STRING_ENCODING = "UTF8";
    private static final int INTEGER_SIZE = 4;
    private static final int SHORT_SIZE = 2;
    private static final int BYTE_SIZE = 1;

    /**
     * Byte array storing the BinaryBuffer data.
     */
    protected byte[] buffer = null;

    /**
     * Point to the index where next write will occurs.
     */
    public int writeIndex = 0;

    /**
     * Point to the index where next read will happen.
     */
    public int readIndex = 0;

    /**
     * The buffer is read only or not.
     */
    protected boolean readOnly = false;

    /**
     * Index to the begin of the buffer.
     */
    protected int beginIndex = 0;

    /**
     * Index to the end of the buffer.
     */
    protected int endIndex = 0;

    /**
     * Initialize BinaryBuffer object.
     *
     * @param length
     *            The length of the buffer. Node that this length can't be
     *            changed dynamically.
     */
    public BinaryBuffer(int length) {
        readOnly = false;
        buffer = new byte[length];
        beginIndex = 0;
        endIndex = buffer.length - 1;
    }

    /**
     * Initialize a BinaryBuffer from a byte array. Such a buffer will be read
     * only!
     *
     * @param buffer
     *            Input buffer to make BinaryBuffer.
     */
    public BinaryBuffer(byte[] buffer) {
        readOnly = false;
        this.buffer = buffer;
        writeIndex = buffer.length;
        beginIndex = 0;
        endIndex = buffer.length - 1;

    }

    /**
     * Initialize a BinaryBuffer from a byte array. Such a buffer will be read
     * only!
     *
     * @param buffer
     *            Input buffer to make BinaryBuffer.
     * @param beginIndex
     *            The begin index witch the buffer can use.
     * @param lengthOfBuffer
     *            Length of the buffer.
     * @throws Exception
     *             on error.
     */
    public BinaryBuffer(byte[] buffer, int beginIndex, int lengthOfBuffer) {
        readOnly = false;
        this.buffer = buffer;
        this.beginIndex = beginIndex;
        endIndex = beginIndex + lengthOfBuffer - 1;
        writeIndex = endIndex + 1;
        readIndex = beginIndex;
        if (endIndex >= buffer.length || beginIndex < 0) {
            String errorMessage = "beginIndex must be greater than zero.";

            if (endIndex >= buffer.length) {
                errorMessage = "The constructor parameters are incorrect. The beginIndex + lengthOfBuffer must be less than buffer length.";
            }

            throw new RuntimeException(errorMessage);
        }
    }

    /**
     * Return the length of buffer.
     */
    public int getLength() {
        return (endIndex - beginIndex + 1);
    }

    /**
     * Returns a byte array witch is the used part of the buffer.
     */
    public byte[] getBuffer() {
        return getUsedBufferPart();
    }

    /**
     * Check if the buffer is read only or not.
     */
    public boolean isReadOnly() {
        return readOnly;
    }

    /**
     * Get the free size of the buffer.
     */
    public int getFreeSize() {
        return (endIndex - writeIndex + 1);
    }

    public boolean canRead() {
        return (readIndex < endIndex + 1);
    }

    /**
     * Returns a byte array witch is the used part of the buffer.
     *
     * @return A new array containing used space of the buffer.
     */
    protected byte[] getUsedBufferPart() {
        byte[] result = null;

        if (endIndex + 1 == buffer.length && beginIndex == 0 && writeIndex == endIndex + 1) {
            result = buffer;
        } else {
            result = new byte[writeIndex - beginIndex];
            for (int i = 0; i < result.length; i++) {
                result[i] = buffer[i + beginIndex];
            }
        }

        return result;
    }

    public void append(float value) {
        append(Float.floatToIntBits(value));
    }

    /**
     * Append an int to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(int value) {
        int size = INTEGER_SIZE;
        if (writeIndex + size <= endIndex + 1) {
            for (int i = 0; i < size; i++) {
                byte toAdd = (byte) (value % 256);
                buffer[writeIndex] = toAdd;
                writeIndex++;
                value = (value >> 8);
            }
        } else {
            throw new RuntimeException();
        }
    }

    public void append24BitInt(int value) {
        int size = 3;
        if (writeIndex + size <= endIndex + 1) {
            for (int i = 0; i < size; i++) {
                byte toAdd = (byte) (value % 256);
                buffer[writeIndex] = toAdd;
                writeIndex++;
                value = (value >> 8);
            }
        } else {
            throw new RuntimeException();
        }
    }

    /**
     * Append a char to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(char value) {
        byte valueToAdd = (byte) value;
        int size = BYTE_SIZE;
        if (writeIndex + size <= endIndex + 1) {
            buffer[writeIndex] = valueToAdd;
            writeIndex++;
        } else {
            throw new RuntimeException();
        }
    }

    /**
     * Append a byte to the buffer.
     *
     * @param valueToAdd
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(byte valueToAdd) {
        int size = BYTE_SIZE;
        if (writeIndex + size <= endIndex + 1) {
            buffer[writeIndex] = valueToAdd;
            writeIndex++;
        } else {
            throw new RuntimeException();
        }
    }

    /**
     * Append a byte to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(boolean value) {
        if (value) {
            append((byte) 1);
        } else {
            append((byte) 0);
        }
    }

    /**
     * Append a string to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws UnsupportedEncodingException
     *             if the encoding is not supported.
     * @throws Exception
     *             on error.
     */
    public void append(String value) {
        byte[] bytes = new byte[0];

        try {
            if (value == null) {
                value = "";
            }

            value = Base64.getEncoder().encodeToString(value.getBytes(DEFAULT_STRING_ENCODING));
            bytes = value.getBytes();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        append(bytes);
    }

    /**
     * Append a byte[] to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(byte[] value) {
        int size = value.length + INTEGER_SIZE;
        if (writeIndex + size <= endIndex + 1) {
            append(value.length);
            for (int i = 0; i < size - INTEGER_SIZE; i++) {
                buffer[writeIndex] = value[i];
                writeIndex++;
            }
        } else {
            throw new RuntimeException();
        }
    }

    public void append(byte[] value, boolean appendLength) {
        int lengthSize = appendLength ? INTEGER_SIZE : 0;

        int size = value.length + lengthSize;
        if (writeIndex + size <= endIndex + 1) {
            if (appendLength) {
                append(value.length);
            }
            for (int i = 0; i < size - lengthSize; i++) {
                buffer[writeIndex] = value[i];
                writeIndex++;
            }
        } else {
            throw new RuntimeException();
        }
    }

    /**
     * Append a short[] to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(short[] value) {
        int size = (value.length * SHORT_SIZE) + INTEGER_SIZE;
        if (writeIndex + size <= endIndex + 1) {
            append(value.length);
            for (int i = 0; i < value.length; i++) {
                append(value[i]);
            }
        } else {
            throw new RuntimeException();
        }
    }

    /**
     * Append an int[] to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(int[] value) {
        int size = (value.length * INTEGER_SIZE) + INTEGER_SIZE;
        if (writeIndex + size <= endIndex + 1) {
            append(value.length);
            for (int i = 0; i < value.length; i++) {
                append(value[i]);
            }
        } else {
            throw new RuntimeException();
        }
    }

    /**
     * Append an String[] to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     * @throws UnsupportedEncodingException
     *             if the encoding is not supported.
     */
    public void append(String[] value) {
        append(value.length);
        for (int i = 0; i < value.length; i++) {
            try {
                append(value[i]);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Append a signed short to the buffer.
     *
     * @param value
     *            Value to be added
     * @throws Exception
     *             on error.
     */
    public void append(short value) {
        int size = SHORT_SIZE;
        if (writeIndex + size <= endIndex + 1) {
            for (int i = 0; i < size; i++) {
                byte toAdd = (byte) (value % 256);
                buffer[writeIndex] = toAdd;
                writeIndex++;
                value = (short) (value >> 8);
            }
        } else {
            throw new RuntimeException();
        }
    }

    /**
     * Read a signed int from the buffer.
     *
     * @return Signed int read from the buffer.
     * @throws Exception
     *             on error.
     */
    public int readInt() {
        int result = 0;
        int size = INTEGER_SIZE;

        if (readIndex + size <= writeIndex) {
            for (int i = 0; i < size; i++) {
                result = result * 256;
                result = ((int) (buffer[readIndex + size - 1 - i] & 0x000000FF)) + result;
            }
            readIndex += size;
        } else {
            throw new RuntimeException();
        }

        return result;
    }

    /**
     * Read a signed 3 byte int from the buffer.
     *
     * @return Signed int read from the buffer.
     * @throws Exception
     *             on error.
     */
    public int read24BitInt() {
        int result = 0;
        int size = 3;

        if (readIndex + size <= writeIndex) {
            for (int i = 0; i < size; i++) {
                result = result * 256;
                result = ((int) (buffer[readIndex + size - 1 - i] & 0x000000FF)) + result;
            }
            readIndex += size;
        } else {
            throw new RuntimeException();
        }

        return result;
    }

    /**
     * Read an unsigned int from the buffer.
     *
     * @return Unsigned byte read from the buffer.
     * @throws Exception
     *             on error.
     */
    public byte readByte() {
        byte result = 0;

        if (readIndex + 1 <= writeIndex) {
            result = buffer[readIndex];
            readIndex += 1;
        } else {
            throw new RuntimeException();
        }

        return result;
    }

    /**
     * Read a short int from the buffer.
     *
     * @return Short int read from the buffer.
     * @throws Exception
     *             on error.
     */
    public short readShort() {
        int result = 0;
        short size = SHORT_SIZE;

        if (readIndex + size <= writeIndex) {
            for (int i = 0; i < size; i++) {
                result = (result << 8);
                result = ((buffer[readIndex + size - 1 - i] & 0x000000ff) | result);
            }
            readIndex += size;
        } else {
            throw new RuntimeException();
        }

        return (short) result;
    }

    /**
     * Read a char from the buffer.
     *
     * @return Char read from the buffer.
     * @throws Exception
     *             on error.
     */
    public char readChar() {
        byte result = 0;
        byte size = BYTE_SIZE;

        if (readIndex + size <= writeIndex) {
            result = buffer[readIndex];
            readIndex += size;
        } else {
            throw new RuntimeException();
        }

        return ((char) result);
    }

    /**
     * Read a boolean from the buffer.
     *
     * @return boolean read from the buffer.
     * @throws Exception
     *             on error.
     */
    public boolean readBoolean() {
        boolean result = (readByte() != 0);

        return result;
    }

    /**
     * Read an null terminated Unicode string from the buffer.
     *
     * @return String read from the buffer.
     * @throws UnsupportedEncodingException
     *             if the encoding is not supported.
     * @throws Exception
     *             on error.
     */
    public String readString() {
        String result = "";

        byte[] bytes = readByteArray();
        try {
            result = new String(bytes);
            result = new String(Base64.getDecoder().decode(result), DEFAULT_STRING_ENCODING);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return result;
    }

    /**
     * Read a byte[] from the buffer.
     *
     * @return byte[] read from the buffer.
     * @throws Exception
     *             on error.
     */
    public byte[] readByteArray() {
        byte[] result = new byte[readInt()];

        for (int i = 0; i < result.length; i++) {
            result[i] = buffer[readIndex];
            readIndex++;
        }

        return result;
    }

    public byte[] readByteArray(int length) {
        byte[] result = new byte[length];

        for (int i = 0; i < result.length; i++) {
            result[i] = buffer[readIndex];
            readIndex++;
        }

        return result;
    }

    /**
     * Read a String[] from the buffer.
     *
     * @return String[] read from the buffer.
     * @throws Exception
     *             on error.
     * @throws UnsupportedEncodingException
     *             if the encoding is not supported.
     */
    public String[] readStringArray() {
        String[] result = new String[readInt()];

        for (int i = 0; i < result.length; i++) {
            try {
                result[i] = readString();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    /**
     * Read a short[] from the buffer.
     *
     * @return short[] read from the buffer.
     * @throws Exception
     *             on error.
     */
    public short[] readShortArray() {
        short[] result = new short[readInt()];

        for (int i = 0; i < result.length; i++) {
            result[i] = readShort();
        }

        return result;
    }

    /**
     * Read an int[] from the buffer.
     *
     * @return int[] read from the buffer.
     * @throws Exception
     *             on error.
     */
    public int[] readIntArray() {
        int[] result = new int[readInt()];

        for (int i = 0; i < result.length; i++) {
            result[i] = readInt();
        }

        return result;
    }

    /**
     * Read a float from the buffer.
     *
     * @return float read from the buffer.
     * @throws Exception
     *             on error.
     */
    public float readFloat() {
        float result = 0;
        int temp = readInt();
        result = Float.intBitsToFloat(temp);

        return result;
    }

    /**
     * Reset the read index to the begin of buffer.
     */
    public void reset() {
        readIndex = beginIndex;
    }

    /**
     * Seek by a distance int the buffer.
     *
     * @param distance
     *            The distance to be added to read index.
     * @throws Exception
     *             if the seek distance is invalid.
     */
    public void seek(int distance) {
        if ((readIndex + distance >= beginIndex) && (readIndex + distance <= endIndex)) {
            readIndex += distance;
        } else {
            throw new RuntimeException("Invalid seek distance.");
        }
    }

    // @Override
    // public String toString()
    // {
    // String result =
    // String.format("BinaryBuffer:\r\n\twriteIndex = {0}\r\n\treadIndex = {1}\r\n\tbeginIndex = {2}\r\n\tendIndex = {3}\r\n\treadOnly = {4}\r\n\tbufferLength = {5}\r\n\tbuffer =\r\n\t\t{6}",
    // writeIndex, readIndex, beginIndex, endIndex, readOnly, buffer.length,
    // getBufferString());
    //
    // return result;
    // }
    //
    // private String getBufferString()
    // {
    // String result = "";
    // int temp = 0;
    // String mapper = "0123456789ABCDEF";
    //
    // for (int i = 0; i < buffer.length; i++)
    // {
    // temp = buffer[i];
    // temp = temp >> 4;
    // result += mapper.charAt(temp);
    // temp = buffer[i];
    // temp = temp & 0x0000000F;
    // result += mapper.charAt(temp);
    // result += " ";
    //
    // if ((i + 1) % 10 == 0 && i != 0)
    // {
    // result += "\r\n\t\t";
    // }
    // }
    //
    // return result.substring(0, result.length() - 2);
    // }

    public static int getSerializedLength(int value) {
        return INTEGER_SIZE;
    }

    public static int getSerializedLength(float value) {
        return INTEGER_SIZE;
    }

    public static int getSerializedLength(short value) {
        return SHORT_SIZE;
    }

    public static int getSerializedLength(String value) {
        int result = 0;

        if (value == null) {
            value = "";
        }

        if (value != null) {
            try {
                value = Base64.getEncoder().encodeToString(value.getBytes(DEFAULT_STRING_ENCODING));
                result = (INTEGER_SIZE + value.getBytes().length);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        return result;
    }

    public static int getSerializedLength(String[] value) throws UnsupportedEncodingException {
        int size = 0;
        if (value != null) {
            for (int i = 0; i < value.length; i++) {
                size += getSerializedLength(value[i]);
            }
        }
        size += INTEGER_SIZE;
        return (size);
    }

    public static int getSerializedLength(char value) {
        return BYTE_SIZE;
    }

    public static int getSerializedLength(byte value) {
        return BYTE_SIZE;
    }

    public static int getSerializedLength(boolean value) {
        return BYTE_SIZE;
    }

    public static int getSerializedLength(byte[] value) {
        int result = 0;
        if (value != null) {
            result = (INTEGER_SIZE + value.length);
        }
        return result;
    }

    public static int getSerializedLength(short[] value) {
        int result = 0;
        if (value != null) {
            result = (INTEGER_SIZE + (value.length * SHORT_SIZE));
        }
        return result;
    }

    public static int getSerializedLength(int[] value) {
        int result = 0;
        if (value != null) {
            result = (INTEGER_SIZE + (value.length * INTEGER_SIZE));
        }
        return result;
    }

    public void append(DateTime date) {
        append((short)date.getYear());
        append((byte)date.getMonth());
        append((byte)date.getDay());

        append((byte)date.getHour());
        append((byte)date.getMinute());
        append((byte)0);
    }

    public DateTime readDate() {
        DateTime result = null;

        int year = readShort();
        int month = readByte();
        int day = readByte();

        int hour = readByte();
        int minute = readByte();
        int second = readByte();

        result = new DateTime(year, month, day, hour, minute, second);

        return result;
    }

    public String readUnicodeString() {
        String result = "";

        byte[] bytes = readByteArray();
        try {
            result = new String(bytes);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;

    }
}
