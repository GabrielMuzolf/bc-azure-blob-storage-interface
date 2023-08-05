page 90006 "Folder Dialog GM"
{
    Caption = 'Select Folder';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(FolderName; FolderName)
            {
                Caption = 'Folder Name';
                ToolTip = 'Specifies the folder name where the blob file will be uploaded.';
                trigger OnValidate()
                begin
                    ValidateFolderName();
                end;
            }
        }
    }

    var
        FolderName: Text;

    /// <summary>
    /// Sets the folder name to the specified value.
    /// </summary>
    /// <param name="NewFolderName">The new folder name to be set.</param>
    procedure SetFolderName(NewFolderName: Text)
    begin
        FolderName := NewFolderName;
    end;

    /// <summary>
    /// Retrieves the folder with the specified name provided by the user.
    /// </summary>
    /// <returns>The folder name as Text.</returns>
    procedure GetFolderName(): Text
    begin
        exit(FolderName);
    end;

    local procedure ValidateFolderName()
    var
        TextConstantGM: Codeunit "Text Constant GM";
    begin
        while StrPos(FolderName, TextConstantGM.ABSFolderSeparator() + TextConstantGM.ABSFolderSeparator()) > 0 do
            FolderName := FolderName.Replace(TextConstantGM.ABSFolderSeparator() + TextConstantGM.ABSFolderSeparator(), TextConstantGM.ABSFolderSeparator());

        if CopyStr(FolderName, StrLen(FolderName), 1) = TextConstantGM.ABSFolderSeparator() then
            exit;

        FolderName += TextConstantGM.ABSFolderSeparator();
    end;
}