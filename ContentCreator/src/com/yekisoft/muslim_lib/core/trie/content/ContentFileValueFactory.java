package com.yekisoft.muslim_lib.core.trie.content;

import com.yekisoft.muslim_lib.core.trie.ITrieIndexValue;
import com.yekisoft.muslim_lib.core.trie.IValueFactory;

/**
 * Created by yektaie on 8/5/16.
 */
public class ContentFileValueFactory implements IValueFactory {

    @Override
    public ITrieIndexValue CreateNew() {
        return new ContentFile();
    }

}