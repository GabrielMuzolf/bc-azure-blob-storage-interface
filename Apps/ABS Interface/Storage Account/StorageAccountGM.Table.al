/// <summary>
/// Represents a table for storing information about Azure storage accounts.
/// https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview
/// </summary>
table 90000 "Storage Account GM"
{
    Caption = 'Storage Account';
    DataClassification = CustomerContent;

    fields
    {
        /// <summary>
        /// Represents the name of the Azure storage account.
        /// </summary>
        field(1; "Name"; Text[1024])
        {
            Caption = 'Name';
        }

        /// <summary>
        /// Represents the shared key used for authorization to the Azure storage account.
        /// </summary>
        field(2; "Shared Key"; Text[1024])
        {
            Caption = 'Shared Key';
            ExtendedDatatype = Masked;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Name")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        DeleteContainers();
    end;

    trigger OnRename()
    begin
        Error(RenameNotAllowedErr);
    end;

    var
        RenameNotAllowedErr: Label 'Storage Account rename is not allowed.';

    /// <summary>
    /// Opens a dialog to set the shared key that will be used to authorize the storage account.
    /// </summary>
    [NonDebuggable]
    procedure SetSharedKey()
    var
        PasswordDialogManagement: Codeunit "Password Dialog Management";
        NewSharedKey: Text;
    begin
        NewSharedKey := PasswordDialogManagement.OpenPasswordDialog(true);
        if NewSharedKey = '' then
            exit;

        Rec.Validate("Shared Key", NewSharedKey);
    end;

    /// <summary>
    /// Refreshes the list of containers for a storage account. This operation removes the existing containers and replaces them with the containers defined in the Azure Blob Storage structure.
    /// </summary>
    procedure RefreshContainers()
    var
        RefreshContainersGM: Codeunit "Refresh Containers GM";
    begin
        RefreshContainersGM.RefreshContainers(Rec);
    end;

    /// <summary>
    /// Deletes containers for the storage account.
    /// </summary>
    procedure DeleteContainers()
    var
        ABSContainerGM: Record "ABS Container GM";
    begin
        ABSContainerGM.SetRange("Storage Account Name", Rec.Name);
        ABSContainerGM.DeleteAll(true);
    end;
}