/// <summary>
/// Presents information about Azure storage accounts.
/// </summary>
page 90000 "Storage Accounts GM"
{
    ApplicationArea = All;
    Caption = 'Storage Accounts';
    PageType = List;
    SourceTable = "Storage Account GM";
    UsageCategory = Lists;
    CardPageId = "Storage Account Card GM";
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