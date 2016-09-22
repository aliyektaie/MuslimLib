package com.yekisoft.muslim_lib.core.trie;

import com.yekisoft.muslim_lib.core.binary.BinaryBuffer;

import java.util.ArrayList;

/**
 * Created by yektaie on 8/5/16.
 */
public class Trie {
    private IValueFactory _factory = null;
    public TrieNode RootNode;
    public int NumberOfDefinitionInTrie = 0;

    public Trie(TrieNode root, IValueFactory factory) {
        RootNode = root;
        _factory = factory;
    }

    public ITrieIndexValue Get(String key) {
        TrieNode x = Get(RootNode, key, 0);

        if (x == null) {
            return null;
        }

        return x.Value;
    }

    private TrieNode Get(TrieNode currentNode, String key, int indexOnKey) {
        if (currentNode == null) {
            return null;
        }

        if (indexOnKey == key.length()) {
            return currentNode;
        }

        char c = key.charAt(indexOnKey);
        return Get(currentNode.GetNodeByCharacter(c), key, indexOnKey + 1);
    }

    public boolean Contains(String key) {
        return Get(key) != null;
    }

    public void Add(String key, ITrieIndexValue definition) {
        Add(RootNode, key, definition, 0);
    }

    private void Add(TrieNode currentNode, String key, ITrieIndexValue definition, int indexOnKey) {
        if (indexOnKey == key.length()) {
            if (currentNode.Value == null) {
                NumberOfDefinitionInTrie++;
            }

            currentNode.Value = definition;
            return;
        }

        char c = key.charAt(indexOnKey);

        if (!currentNode.Contains(c)) {
            currentNode.AddNode(c, new TrieNode(this, _factory));
        }
        Add(currentNode.GetNodeByCharacter(c), key, definition, indexOnKey + 1);
    }

    public byte[] Serialize(int beginOffset) {
        TrieNode[] nodes = ToArray(TrieNode.AllNodesList.get(this));
        int nodeOffset = beginOffset;
        int length = 0;

        System.out.println("Begin Computation of length");

        for (int i = 0; i < nodes.length; i++) {
//            if (progress != null && i % 100 == 0)
//                progress.setProgress("", i, nodes.length);

            nodes[i].OffsetInFile = nodeOffset;
            int l = nodes[i].GetSerializedLength();
            nodeOffset += l;
            length += l;
        }

        BinaryBuffer buffer = null;
        buffer = new BinaryBuffer(length);


        System.out.println("Starting Serialization");

        for (int i = 0; i < nodes.length; i++) {
//            if (progress != null && i % 100 == 0)
//                progress.setProgress("", i, nodes.length);

            buffer.append(nodes[i].Serialize(), false);
        }

        return buffer.getBuffer();
    }

    private TrieNode[] ToArray(ArrayList<TrieNode> arrayList) {
        TrieNode[] result = new TrieNode[arrayList.size()];

        for (int i = 0; i < result.length; i++) {
            result[i] = arrayList.get(i);
        }

        return result;
    }
}
