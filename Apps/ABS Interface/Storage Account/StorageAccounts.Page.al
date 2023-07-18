/// <summary>
/// Presents information about Azure storage accounts.
/// </summary>
page 90000 "Storage Accounts"
{
    ApplicationArea = All;
    Caption = 'Storage Accounts';
    PageType = List;
    SourceTable = "Storage Account";
    UsageCategory = Lists;
    CardPageId = "Storage Account Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(StorageAccounts)
            {
                field("Name"; Rec."Name")
                {
                    ToolTip = 'Specifies the storage account name.';
                }
                field("Shared Key"; Rec."Shared Key")
                {
                    ToolTip = 'Specifies the storage account authorization shared key.';
                }
            }
        }
    }
}