package com.yekisoft.muslim_lib.core.trie;

import com.yekisoft.muslim_lib.core.binary.BinaryBuffer;
import com.yekisoft.muslim_lib.core.trie.file.RandomAccessFile;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Set;

/**
 * Created by yektaie on 8/5/16.
 */
public class TrieNode {
    public static Hashtable<Trie, ArrayList<TrieNode>> AllNodesList = new Hashtable<>();

    private RandomAccessFile file = null;
    private static byte[] key = { (byte)0xEB, 29, 71, 39 };

    public ITrieIndexValue Value;
    private Hashtable<String, Object> Nodes;
    public int OffsetInFile;
    public IValueFactory _factory = null;

    public TrieNode(Trie parent, IValueFactory factory)
    {
        if (parent != null)
        {
            if (!AllNodesList.containsKey(parent))
            {
                AllNodesList.put(parent, new ArrayList<TrieNode>());
            }

            AllNodesList.get(parent).add(this);
        }

        Nodes = new Hashtable<>();
        _factory = factory;
    }

    public TrieNode(RandomAccessFile file, IValueFactory factory)
    {
        Nodes = new Hashtable<>();
        this.file = file;
        _factory = factory;
    }

    public static TrieNode Load(byte[] array, RandomAccessFile file, IValueFactory factory)
    {
        TrieNode result = new TrieNode(file, factory);
        BinaryBuffer buffer = new BinaryBuffer(array);
        int header = buffer.readByte();

        int childCount = buffer.readShort();
        for (int i = 0; i < childCount; i++)
        {
            char c = (char)buffer.readShort();
            int offset = buffer.readInt();
            int length = buffer.read24BitInt();

            LazyLoadTrieNodeInfo info = new LazyLoadTrieNodeInfo();
            info.Key = c;
            info.Length = length;
            info.Offset = offset;

            result.Nodes.put(String.valueOf(c), info);
        }

        if ((header & (int)TrieNodeField.ITrieIndexValueDefinition) != 0)
        {
            byte[] temp = buffer.readByteArray();
            for (int i = 0; i < temp.length; i++)
            {
                temp[i] = (byte)(temp[i] ^ TrieNode.key[i % TrieNode.key.length]);
            }

            ITrieIndexValue value = factory.CreateNew();
            value.Load(temp);

            result.Value = value;
        }



        return result;
    }

    public byte[] Serialize()
    {
        int length = GetSerializedLength();
        BinaryBuffer buffer = new BinaryBuffer(length);

        int header = (int)(TrieNodeField.Nodes);
        if (Value != null)
        {
            header = header | (int)TrieNodeField.ITrieIndexValueDefinition;
        }

        buffer.append((byte)header);

        buffer.append((short)Nodes.size());
        Set<String> keys = Nodes.keySet();
        for(String key: keys){
            buffer.append((short)key.charAt(0));
            Object itemValue = Nodes.get(key);
            if (itemValue instanceof TrieNode)
            {
                TrieNode node = (TrieNode)itemValue;
                buffer.append(node.OffsetInFile);
                buffer.append24BitInt(node.GetSerializedLength());
            }
            else
            {
                throw new RuntimeException();
            }
        }

        if (Value != null)
        {
            byte[] array = Value.Serialize();
            for (int i = 0; i < array.length; i++)
            {
                array[i] = (byte)(array[i] ^ TrieNode.key[i % TrieNode.key.length]);
            }
            buffer.append(array);
        }

        return buffer.getBuffer();
    }

    public int GetSerializedLength()
    {
        int length = 0;
        length += 1; // header
        if (Value != null)
        {
            length += BinaryBuffer.getSerializedLength(Value.Serialize());
        }

        length += 2; // count of child
        length += (Nodes.size() * (2 + 4 + 3));

        return length;
    }

    public TrieNode GetNodeByCharacter(char ch)
    {
        String c = String.valueOf(ch);
        if (!Nodes.containsKey(c))
        {
            return null;
        }

        Object o = Nodes.get(c);

        if (o instanceof TrieNode)
        {
            return (TrieNode)o;
        }

        LazyLoadTrieNodeInfo info = (LazyLoadTrieNodeInfo)o;
        byte[] array = file.Read(info.Offset, info.Length);
        Nodes.put(c, Load(array, file, _factory));

        return GetNodeByCharacter(c.charAt(0));
    }

    public void AddNode(char ch, TrieNode node)
    {
        String c = String.valueOf(ch);
        Nodes.put(c, node);
    }

    public boolean Contains(char ch)
    {
        String c = String.valueOf(ch);
        return Nodes.containsKey(c);
    }
}
