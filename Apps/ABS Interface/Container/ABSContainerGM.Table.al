/// <summary>
/// Stores information about azure blob storage account container.
/// </summary>
table 90001 "ABS Container GM"
{
    Caption = 'Azure Blob Storage Container';
    DataClassification = SystemMetadata;

    fields
    {
        /// <summary>
        /// The name of the Storage Account associated with the container.
        /// </summary>
        field(1; "Storage Account Name"; Text[1024])
        {
            Caption = 'Storage Account Name';
            TableRelation = "Storage Account GM"."Name";
            Editable = false;
        }

        /// <summary>
        /// The name of the container.
        /// </summary>
        field(2; Name; Text[2048])
        {
            Caption = 'Name';
            Editable = false;
        }

        /// <summary>
        /// The date and time when the container was last modified.
        /// </summary>
        field(5; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Storage Account Name", Name)
        {
            Clustered = true;
        }
    }

}