/// <summary>
/// Presents Azure storage account card.
/// </summary>
page 90001 "Storage Account Card"
{
    Caption = 'Storage Account';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Storage Account";

    layout
    {
        area(content)
        {
            group(Account)
            {
                Caption = 'Account';
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
