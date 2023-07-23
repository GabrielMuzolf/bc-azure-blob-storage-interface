/// <summary>
/// Presents informations about azure blob storage containers.
/// </summary>
page 90003 "ABS Containers Part GM"
{
    UsageCategory = None;
    Caption = 'Containers';
    PageType = ListPart;
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
                field("Last Modified"; Rec."Last Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the container was last modified.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Create)
            {
                Caption = 'Create';
                ToolTip = 'Run this action to create new container.';
                ApplicationArea = All;
                Image = Add;

                trigger OnAction();
                begin
                    CreateNewContainer();
                end;
            }
            action(Delete)
            {
                Caption = 'Delete';
                ToolTip = 'Run this action to delete cotainer and his blobs from the storage account.';
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction();
                begin
                    Rec.Delete();
                end;
            }
        }
    }

    local procedure CreateNewContainer()
    var
        CreateContainerDialogGM: Page "Create Container Dialog GM";
    begin
        if not (CreateContainerDialogGM.RunModal() = Action::OK) then
            exit;

        Rec.Create(CreateContainerDialogGM.GetContainerName());
    end;
}