/// <summary>
/// Provides text constants.
/// </summary>
codeunit 90002 "Text Constant GM"
{
    /// <summary>
    /// Gets the 'Directory' text constant.
    /// </summary>
    /// <returns>'Directory'</returns>
    procedure Directory(): Text
    begin
        exit('Directory');
    end;

    /// <summary>
    /// Gets the previous folder name.
    /// </summary>
    /// <returns>'[...]'.</returns>
    procedure PreviousFolderName(): Text
    begin
        exit('[..]');
    end;

    /// <summary>
    /// Get Azure BLob Storage folder separator.
    /// </summary>
    /// <returns>'/'</returns>
    procedure ABSFolderSeparator(): Text
    begin
        exit('/');
    end;
}