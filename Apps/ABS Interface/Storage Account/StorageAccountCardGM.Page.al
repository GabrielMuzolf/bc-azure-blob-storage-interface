/// <summary>
/// Presents Azure storage account card.
/// </summary>
page 90001 "Storage Account Card GM"
{
    Caption = 'Storage Account';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Storage Account GM";

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
                    trigger OnAssistEdit()
                    begin
                        Rec.SetSharedKey();
                    end;
                }
            }
            part("ABS Containers Part GM"; "ABS Containers Part GM")
            {
                SubPageLink = "Storage Account Name" = field(Name);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetSharedKey)
            {
                Caption = 'Set Shared Key';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Sets the storage account shared key.';

                trigger OnAction()
                begin
                    Rec.SetSharedKey();
                end;
            }
        }
    }
}
