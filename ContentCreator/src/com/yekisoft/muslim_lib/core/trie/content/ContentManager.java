package com.yekisoft.muslim_lib.core.trie.content;

import com.yekisoft.muslim_lib.core.trie.ITrieIndexValue;
import com.yekisoft.muslim_lib.core.trie.TrieFile;

/**
 * Created by yektaie on 8/5/16.
 */
public class ContentManager {
    private TrieFile trie = null;

    public ContentManager()
    {
        trie = new TrieFile(new ContentFileValueFactory());
    }

    public ContentManager(String pathToIndex, String pathToWordList)
    {
        trie = new TrieFile(pathToIndex, new ContentFileValueFactory());
    }

    public void Add(String key, ContentFile file)
    {
        trie.Add(key, file);
    }

    public ContentFile GetValue(String key)
    {
        ITrieIndexValue result = null;

        result = trie.GetValue(key);

        return (ContentFile)result;
    }

    public void Save(String path, String title)
    {
        trie.Save(path, title);
    }

    public boolean Contains(String key)
    {
        return trie.Contains(key);
    }


}
