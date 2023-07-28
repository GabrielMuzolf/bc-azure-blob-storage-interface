/// <summary>
/// Presents information about blob files sotred in azure blob storage container.
/// </summary>
page 90005 "ABS Blob Files GM"
{
    ApplicationArea = All;
    Caption = 'Blob Files';
    PageType = List;
    SourceTable = "ABS Blob File GM";
    UsageCategory = Lists;
    SourceTableView = sorting(Type, Name);
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(Container)
            {
                ShowCaption = false;
                field(ContainerName; ContainerName)
                {
                    Caption = 'Container Name';
                    ToolTip = 'Specifies the container name.';
                    Enabled = (CurrentFolder = '');

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetContainerAndStorageName();
                        SetViewOnBlobList();
                    end;

                    trigger OnValidate()
                    begin
                        ValidateContainerName();
                    end;
                }
                field(StorageAccountName; StorageAccountName)
                {
                    Caption = 'Storage Account Name';
                    ToolTip = 'Specifies the storage account name.';
                    Editable = false;
                }
            }
            repeater(BlobFiles)
            {
                Editable = false;
#pragma warning disable AW0009
                field(Image; Rec."Blob Type Image")
                {
                    Caption = '';
                    ToolTip = 'Specifies Blob File Type.';
                    trigger OnDrillDown()
                    begin
                        SwitchFolder();
                    end;
                }
#pragma warning restore
                field(Name; Rec."Name")
                {
                    ToolTip = 'Specifies the blob file name.';
                    StyleExpr = StyleExpr;
                    trigger OnDrillDown()
                    begin
                        SwitchFolder();
                    end;
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ToolTip = 'Specifies the blob last modified date time.';
                }
                field(Size; Rec.Size)
                {
                    ToolTip = 'Specifies the blob size.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh';
                ToolTip = 'Run this action to refresh blob files for the storage account and the container.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Refresh;
                Enabled = ((CurrentFolder = '') and (ContainerName <> ''));

                trigger OnAction();
                begin
                    RefreshBlobFilesForContainer();
                end;
            }
            action(Previous)
            {
                Caption = 'Previous Folder';
                ToolTip = 'Run this action to go to the root folder.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = PreviousRecord;
                Enabled = (CurrentFolder <> '');

                trigger OnAction();
                begin
                    PreviousFolder();
                end;
            }
            action(Next)
            {
                Caption = 'Next Folder';
                ToolTip = 'Run this action to go to the subfolder.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = NextRecord;
                Enabled = (Rec.Type = Rec.Type::Folder);

                trigger OnAction();
                begin
                    NextFolder();
                end;
            }
            action(Download)
            {
                Caption = 'Download Blob';
                ToolTip = 'Run this action to download blob file.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Download;
                Enabled = ((ContainerName <> '') and (Rec.Type = "ABS Blob Type GM"::File));

                trigger OnAction();
                begin
                    Rec.Download();
                end;
            }
            action(Upload)
            {
                Caption = 'Upload Blob';
                ToolTip = 'Run this action to upload blob file.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = NewDocument;

                trigger OnAction();
                begin
                    Message('Add implementation');
                end;
            }
            action(Delete)
            {
                Caption = 'Delete';
                ToolTip = 'Run this action to delete blob file.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Delete;

                trigger OnAction();
                begin
                    Message('Add implementation');
                end;
            }
            action(ShowStorageAccounts)
            {
                Caption = 'Storage Account';
                ToolTip = 'Run this action to view/edit storage account.';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Account;

                trigger OnAction()
                begin
                    Message('Add implementation');
                end;
            }
        }
    }
    var
        TextConstantGM: Codeunit "Text Constant GM";
        StyleExpr: Text;
        StorageAccountName: Text;
        ContainerName: Text;
        CurrentFolder: Text;

    trigger OnOpenPage()
    begin
        SetViewOnBlobList();
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Type = Rec.Type::File then
            StyleExpr := 'Strong'
        else
            StyleExpr := 'None';
    end;

    /// <summary>
    /// Sets a storage account and container name for the context in which we want to work on the page.
    /// </summary>
    /// <param name="ABSContainerGM">The ABS Container GM record containing the storage account and container information.</param>
    procedure SetContainerAndStorageName(ABSContainerGM: Record "ABS Container GM")
    begin
        StorageAccountName := ABSContainerGM."Storage Account Name";
        ContainerName := ABSContainerGM.Name;
    end;

    local procedure SetContainerAndStorageName()
    var
        ABSContainerGM: Record "ABS Container GM";
    begin
        if not (Page.RunModal(Page::"ABS Containers GM", ABSContainerGM) = Action::LookupOK) then
            exit;

        SetContainerAndStorageName(ABSContainerGM)
    end;

    local procedure SetViewOnBlobList()
    begin
        FilterBlobsList();
        CurrPage.SetTableView(Rec);
        CurrPage.Update(false);
    end;

    local procedure FilterBlobsList()
    begin
        Rec.Reset();
        Rec.SetRange("Storage Account Name", StorageAccountName);
        Rec.SetRange("Container Name", ContainerName);
        if CurrentFolder <> '' then
            Rec.SetFilter("Parent Directory", '%1|%2', CurrentFolder, TextConstantGM.PreviousFolderName())
        else
            Rec.SetFilter("Parent Directory", '%1', CurrentFolder);
    end;

    local procedure ValidateContainerName()
    var
        ABSContainerGM: Record "ABS Container GM";
    begin
        ABSContainerGM.Get(StorageAccountName, ContainerName);
    end;

    local procedure RefreshBlobFilesForContainer()
    var
        ABSContainerGM: Record "ABS Container GM";
    begin
        ABSContainerGM.Get(StorageAccountName, ContainerName);
        ABSContainerGM.RefreshBlobs();
    end;

    local procedure SwitchFolder()
    begin
        if Rec.Type <> "ABS Blob Type GM"::Folder then
            exit;

        if Rec.Name <> TextConstantGM.PreviousFolderName() then
            NextFolder()
        else
            PreviousFolder();
    end;

    local procedure NextFolder()
    begin
        CurrentFolder := CurrentFolder + Rec.Name + TextConstantGM.ABSFolderSeparator();
        SetViewOnBlobList();
    end;

    local procedure PreviousFolder()
    begin
        CurrentFolder := GetPreviousFolderName();
        SetViewOnBlobList();
    end;

    local procedure GetPreviousFolderName() PreviousFolderName: Text
    var
        PathElements: List of [Text];
        i: Integer;
    begin
        PathElements := CurrentFolder.Split(TextConstantGM.ABSFolderSeparator());
        if PathElements.Count > 2 then
            for i := 1 to PathElements.Count() - 2 do
                PreviousFolderName += PathElements.Get(i) + TextConstantGM.ABSFolderSeparator();
    end;
}
