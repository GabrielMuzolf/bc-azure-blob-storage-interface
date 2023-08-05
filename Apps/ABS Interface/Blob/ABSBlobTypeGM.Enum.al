/// <summary>
/// Specified Blob types.
/// </summary>
enum 90000 "ABS Blob Type GM"
{
    value(0; " ")
    {
        Caption = ' ';
    }

    /// <summary>
    /// Folder Type.
    /// </summary>
    value(1; Folder)
    {
        Caption = 'Folder';
    }

    /// <summary>
    /// File Type.
    /// </summary>
    value(2; "File")
    {
        Caption = 'File';
    }
}