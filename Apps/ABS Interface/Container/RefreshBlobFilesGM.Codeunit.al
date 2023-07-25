/// <summary>
/// Provides functionality to refresh the list of blobs related to a storage account and container.
/// </summary>
codeunit 90003 "Refresh Blob Files GM"
{
    Access = Internal;

    var
        TextConstantGM: Codeunit "Text Constant GM";
        AddEmptyFolderRecord: Boolean;

    /// <summary>
    /// Refreshes the list of blobs for a container <paramref name="ABSContainerGM"/>. 
    /// Removes the currently defined blobs for the container and replaces them with the ones defined in the Azure Blob Storage container blob structure.
    /// </summary>
    /// <param name="ABSContainerGM">The ABS Blob container to be refreshed.</param>
    procedure RefreshBlobs(ABSContainerGM: Record "ABS Container GM")
    var
        ABSContainerContent: Record "ABS Container Content";
    begin
        DeleteCurrentContainerBlobs(ABSContainerGM);
        FillABSContainerContentBuffer(ABSContainerGM, ABSContainerContent);
        InsertContainerBlobs(ABSContainerGM, ABSContainerContent);
    end;

    local procedure DeleteCurrentContainerBlobs(ABSContainerGM: Record "ABS Container GM")
    var
        ABSBlobFileGM: Record "ABS Blob File GM";
    begin
        ABSBlobFileGM.SetRange("Storage Account Name", ABSContainerGM."Storage Account Name");
        ABSBlobFileGM.SetRange("Container Name", ABSContainerGM.Name);
        if ABSBlobFileGM.FindSet() then
            ABSBlobFileGM.DeleteAll();
    end;

    local procedure FillABSContainerContentBuffer(ABSContainerGM: Record "ABS Container GM"; var ABSContainerContent: Record "ABS Container Content")
    var
        StorageAccountGM: Record "Storage Account GM";
        ABSBlobClient: Codeunit "ABS Blob Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
    begin
        StorageAccountGM.Get(ABSContainerGM."Storage Account Name");
        Authorization := StorageServiceAuthorization.CreateSharedKey(StorageAccountGM."Shared Key");
        ABSBlobClient.Initialize(ABSContainerGM."Storage Account Name", ABSContainerGM.Name, Authorization);
        ABSOperationResponse := ABSBlobClient.ListBlobs(ABSContainerContent);
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    local procedure InsertContainerBlobs(ABSContainerGM: Record "ABS Container GM"; var ABSContainerContent: Record "ABS Container Content")
    begin
        if not ABSContainerContent.FindSet() then
            exit;

        repeat
            InsertBlob(ABSContainerGM, ABSContainerContent);
        until ABSContainerContent.Next() = 0;

        InsertEmtyFolderRecord(ABSContainerGM);
    end;

    local procedure InsertBlob(ABSContainerGM: Record "ABS Container GM"; ABSContainerContent: Record "ABS Container Content")
    var
        ABSBlobFileGM: Record "ABS Blob File GM";
    begin
        ABSBlobFileGM.Init();
        ABSBlobFileGM.Validate("Storage Account Name", ABSContainerGM."Storage Account Name");
        ABSBlobFileGM.Validate("Container Name", ABSContainerGM.Name);
        ABSBlobFileGM.Validate("Full Name", ABSContainerContent."Full Name");
        ABSBlobFileGM.Validate(Name, ABSContainerContent.Name);
        ABSBlobFileGM.Validate("Parent Directory", ABSContainerContent."Parent Directory");
        ABSBlobFileGM.Validate(Level, ABSContainerContent.Level);
        ABSBlobFileGM.Validate(Type, GetBlobType(ABSContainerContent."Content Type"));
        ABSBlobFileGM.Validate("Last Modified", ABSContainerContent."Last Modified");
        ABSBlobFileGM.Validate("Content Length", ABSContainerContent."Content Length");
        ABSBlobFileGM.Validate(Size, GetBlobSize(ABSContainerContent."Content Length"));
        SetBlobTypeImage(ABSBlobFileGM);
        ABSBlobFileGM.Insert(true);

        if ABSContainerContent.Level > 0 then
            AddEmptyFolderRecord := true;
    end;

    local procedure InsertEmtyFolderRecord(ABSContainerGM: Record "ABS Container GM")
    var
        ABSBlobFileGM: Record "ABS Blob File GM";
    begin
        if not AddEmptyFolderRecord then
            exit;

        ABSBlobFileGM.Init();
        ABSBlobFileGM.Validate("Storage Account Name", ABSContainerGM."Storage Account Name");
        ABSBlobFileGM.Validate("Container Name", ABSContainerGM.Name);
        ABSBlobFileGM.Validate(Name, TextConstantGM.PreviousFolderName());
        ABSBlobFileGM.Validate("Parent Directory", TextConstantGM.PreviousFolderName());
        ABSBlobFileGM.Validate(Type, "ABS Blob Type GM"::Folder);
        SetBlobTypeImage(ABSBlobFileGM);
        ABSBlobFileGM.Insert(true);
    end;

    local procedure GetBlobType(ContentType: Text[2048]): Enum "ABS Blob Type GM"
    begin
        if ContentType in [TextConstantGM.Directory(), ''] then
            exit("ABS Blob Type GM"::Folder);

        exit("ABS Blob Type GM"::File);
    end;

    local procedure SetBlobTypeImage(var ABSBlobFileGM: Record "ABS Blob File GM")
    var
        Base64Convert: Codeunit "Base64 Convert";
        ImageGM: Codeunit "Image GM";
        OutStreamImage: OutStream;
        Image: Text;
    begin
        ABSBlobFileGM."Blob Type Image".CreateOutStream(OutStreamImage);
        if ABSBlobFileGM.Type = "ABS Blob Type GM"::Folder then
            Image := ImageGM.GetFolderImage()
        else
            Image := ImageGM.GetFileImage();
        Base64Convert.FromBase64(Image, OutStreamImage);
    end;

    local procedure GetBlobSize(Bytes: Integer): Text[100]
    var
        Math: Codeunit Math;
        SizeTypes: List of [Text];
        SizeType: Integer;
    begin
        if Bytes = 0 then
            exit;

        InitalizeSizeTypesList(SizeTypes);
        SizeType := Math.Floor(Math.Log(Bytes) / Math.Log(1024)) + 1;

        if SizeType = 1 then
            exit(Format(Bytes) + ' ' + SizeTypes.Get(1));

        exit(Format(Round(Bytes / Math.Pow(1024, SizeType - 1)), 0, 9) + ' ' + SizeTypes.Get(SizeType))
    end;

    local procedure InitalizeSizeTypesList(var SizeTypes: List of [Text])
    begin
        Clear(SizeTypes);
        SizeTypes.Add('B');
        SizeTypes.Add('KiB');
        SizeTypes.Add('MiB');
        SizeTypes.Add('GiB');
        SizeTypes.Add('TiB');
    end;
}
