package com.yekisoft.muslim_lib.core.trie;

import com.yekisoft.muslim_lib.core.binary.BinaryBuffer;
import com.yekisoft.muslim_lib.core.trie.file.RandomAccessFile;

import java.io.FileOutputStream;
import java.util.ArrayList;

/**
 * Created by yektaie on 8/5/16.
 */
public class TrieFile {
    private final int FILE_HEADER_LENGTH = 3000;
    private Trie trie = null;

    public String Title = "";
    private IValueFactory _factory = null;
    public int Revision = 0;

    public TrieFile(IValueFactory factory)
    {
        trie = new Trie(new TrieNode((Trie)null, factory), factory);
        ArrayList<TrieNode> list = new ArrayList<TrieNode>();
        list.add(trie.RootNode);
        TrieNode.AllNodesList.put(trie, list);
    }

    public TrieFile(String path, IValueFactory factory)
    {
        this._factory = factory;
        RandomAccessFile file = new RandomAccessFile(path);

        int headerLength = file.ReadInt(5);
        int rootLength = file.ReadInt(9);
        byte[] rootNodeSerialized = file.Read(headerLength, rootLength);
        TrieNode node = TrieNode.Load(rootNodeSerialized, file, _factory);
        trie = new Trie(node, _factory);

        byte[] header = file.Read(0, headerLength);
        BinaryBuffer buffer = new BinaryBuffer(header);
        buffer.readByte();
        Revision = buffer.readInt();
        buffer.readInt();
        buffer.readInt();
        Title = buffer.readString();
    }

    public void Add(String key, ITrieIndexValue value)
    {
        trie.Add(key, value);
    }

    public void Save(String path, String title)
    {
        this.Title = title;

        int lenght = FILE_HEADER_LENGTH;
        byte[] trieSerialized = trie.Serialize(FILE_HEADER_LENGTH);
        lenght += trieSerialized.length;

        BinaryBuffer buffer = new BinaryBuffer(lenght);

        buffer.append((byte)2);
        buffer.append(Revision);
        buffer.append(FILE_HEADER_LENGTH);
        buffer.append(trie.RootNode.GetSerializedLength());
        buffer.append(Title);

        buffer.writeIndex = FILE_HEADER_LENGTH;
        buffer.append(trieSerialized, false);

        System.out.println("Saving to file");
        FileWriteAllBytes(path, buffer.getBuffer());
    }

    private void FileWriteAllBytes(String path, byte[] buffer) {
        try {
            FileOutputStream fs = new FileOutputStream(path);

            fs.write(buffer);

            fs.flush();
            fs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ITrieIndexValue GetValue(String key)
    {
        ITrieIndexValue result = null;

        result = trie.Get(key);

        return result;
    }

    public boolean Contains(String key)
    {
        return trie.Contains(key);
    }

}
