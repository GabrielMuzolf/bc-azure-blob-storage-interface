/// <summary>
/// Presents informations about azure blob storage containers.
/// </summary>
page 90002 "ABS Containers GM"
{
    UsageCategory = None;
    Caption = 'Containers';
    PageType = List;
    SourceTable = "ABS Container GM";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Containers)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the container name.';
                }
                field("Storage Account Name"; Rec."Storage Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the Storage Account associated with the container.';
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the container was last modified.';
                }
            }
        }
    }
}