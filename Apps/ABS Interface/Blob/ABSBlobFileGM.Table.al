/// <summary>
/// Stores information about azure blob storage files.
/// </summary>
table 90002 "ABS Blob File GM"
{
    Caption = 'Blob File';
    DataClassification = SystemMetadata;
    DataPerCompany = false;

    fields
    {
        /// <summary>
        /// The name of the storage account where the blob is located.
        /// </summary>
        field(1; "Storage Account Name"; Text[1024])
        {
            Caption = 'Storage Account Name';
            TableRelation = "Storage Account GM"."Name";
            Editable = false;
        }

        /// <summary>
        /// The name of the container where the blob is stored.
        /// </summary>
        field(2; "Container Name"; Text[2048])
        {
            Caption = 'Container Name';
            TableRelation = "ABS Container GM".Name;
            Editable = false;
        }

        /// <summary>
        /// The full name (path) of the blob file.
        /// </summary>
        field(3; "Full Name"; Text[2048])
        {
            Caption = 'Full Name';
            Editable = false;
        }

        /// <summary>
        /// The name of the blob file.
        /// </summary>
        field(4; "Name"; Text[2048])
        {
            Caption = 'Name';
            Editable = false;
        }

        /// <summary>
        /// The parent directory of the blob file.
        /// </summary>
        field(6; "Parent Directory"; Text[2048])
        {
            Caption = 'Parent Directory';
            Editable = false;
        }

        /// <summary>
        /// The level of the blob file in the hierarchy.
        /// </summary>
        field(7; Level; Integer)
        {
            Caption = 'Level';
            Editable = false;
        }

        /// <summary>
        /// The type of the blob file.
        /// </summary>
        field(10; Type; Enum "ABS Blob Type GM")
        {
            Caption = 'Type';
            Editable = false;
        }

        /// <summary>
        /// The last modified date and time of the blob file.
        /// </summary>
        field(20; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
            Editable = false;
        }

        /// <summary>
        /// The content length of the blob file in bytes.
        /// </summary>
        field(21; "Content Length"; BigInteger)
        {
            Caption = 'Content Length';
            Editable = false;
        }

        /// <summary>
        /// The size of the blob file in a human-readable format.
        /// </summary>
        field(25; "Size"; Text[100])
        {
            Caption = 'Size';
            Editable = false;
        }

        /// <summary>
        /// The image data representing the blob file type (file/folder).
        /// </summary>
        field(50; "Blob Type Image"; Blob)
        {
            Subtype = Bitmap;
            Caption = 'Blob Type Image';
        }
    }
    keys
    {
        key(PK; "Storage Account Name", "Container Name", "Full Name")
        {
            Clustered = true;
        }
        key(Sort; Type, Name)
        {

        }
    }
}