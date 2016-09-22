package com.yekisoft.muslim_lib.core.trie.content;

import com.yekisoft.muslim_lib.core.Guid;
import com.yekisoft.muslim_lib.core.binary.BinaryBuffer;
import com.yekisoft.muslim_lib.core.trie.ITrieIndexValue;

/**
 * Created by yektaie on 8/5/16.
 */
public class ContentFile implements ITrieIndexValue {
    public String Content = null;
    public byte[] BinaryContent = null;
    public int Type = 0;
    public Guid ID = null;
    public String Title = null;

    public String FilePath = "";

    public void Load(byte[] array)
    {
        BinaryBuffer buffer = new BinaryBuffer(array);

        int header = buffer.readInt();

        Type = buffer.readByte();

        if ((header & (int)ContentFileField.ID) != 0)
            ID = new Guid(buffer.readString());
        else
            ID = Guid.empty();

        if ((header & (int)ContentFileField.Title) != 0)
            Title = buffer.readString();
        else
            Title = "";

        if ((header & (int)ContentFileField.Content) != 0)
            Content = buffer.readString();

        if ((header & (int)ContentFileField.BinaryContent) != 0)
            BinaryContent = buffer.readByteArray();

    }

    public byte[] Serialize()
    {
        int length = 4;

        if (IncludeTitleInSerialized())
        {
            length += BinaryBuffer.getSerializedLength(Title);
        }

        if (IncludeIDInSerialization())
            length += BinaryBuffer.getSerializedLength(ID.toString());
        length++;


        if (Content != null)
            length += BinaryBuffer.getSerializedLength(Content);

        if (BinaryContent != null)
            length += BinaryBuffer.getSerializedLength(BinaryContent);

        BinaryBuffer buffer = new BinaryBuffer(length);
        int header = (int)(ContentFileField.Type);

        if (IncludeIDInSerialization())
            header = header | (int)ContentFileField.ID;

        if (IncludeTitleInSerialized())
            header = header | (int)ContentFileField.Title;

        if (BinaryContent != null)
            header = header | (int)ContentFileField.BinaryContent;

        if (Content != null)
            header = header | (int)ContentFileField.Content;


        buffer.append(header);
        buffer.append((byte)Type);

        if (IncludeIDInSerialization())
            buffer.append(ID.toString());

        if (IncludeTitleInSerialized())
            buffer.append(Title);

        if (Content != null)
            buffer.append(Content);

        if (BinaryContent != null)
            buffer.append(BinaryContent);

        return buffer.getBuffer();
    }

    private boolean IncludeIDInSerialization()
    {
        if (ID == null) {
            return false;
        }

        return !ID.isEmpty();
    }

    private boolean IncludeTitleInSerialized()
    {
        return Title != null && !Title.equals("");
    }

}
