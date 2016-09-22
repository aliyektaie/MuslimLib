package com.yekisoft.muslim_lib.core.trie.file;

import com.yekisoft.muslim_lib.core.binary.BinaryBuffer;

import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * Created by yektaie on 8/5/16.
 */
public class RandomAccessFile {
    private java.io.RandomAccessFile file = null;
    private String pathToFile = "";

    public RandomAccessFile(String fileName)
    {
        pathToFile = fileName;
        try {
            file = new java.io.RandomAccessFile(fileName, "r");
        } catch (FileNotFoundException e) {
            System.err.println("File not found at path: " + fileName);
        }
    }

    public byte[] Read(int offset, int length)
    {
        byte[] result = new byte[length];
        try {
            file.seek(offset);
            file.read(result);
        } catch (IOException e) {
            System.err.println("Unable to read from file: " + pathToFile);
        }


        return result;
    }

    public int ReadInt(int offset)
    {
        BinaryBuffer buffer = new BinaryBuffer(Read(offset, 4));

        return buffer.readInt();
    }

    public int GetLength()
    {
        try {
            return (int)file.length();
        } catch (IOException e) {
        }

        return -1;
    }
}
