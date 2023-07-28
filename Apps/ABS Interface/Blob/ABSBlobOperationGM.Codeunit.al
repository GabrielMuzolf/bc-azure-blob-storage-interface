/// <summary>
/// This codeunit provides functionality to manage Azure Blob Storage blob files in the container. It allows you to upload, download, delete, and other operations.
/// </summary>
codeunit 90005 "ABS Blob Operation GM"
{

    /// <summary>
    /// Downloads the specified <paramref name="ABSBlobFileGM"/> and saves it to the local file system.
    /// </summary>
    /// <param name="ABSBlobFileGM">The ABS Blob File GM record representing the file to be downloaded.</param>
    procedure Download(ABSBlobFileGM: Record "ABS Blob File GM")
    var
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        FileContent: Text;
    begin
        InitalizeBlobClient(ABSBlobClient, ABSBlobFileGM."Storage Account Name", ABSBlobFileGM."Container Name");
        ABSOperationResponse := ABSBlobClient.GetBlobAsText(ABSBlobFileGM."Full Name", FileContent);
        ShowErrorIfNotSuccessful(ABSOperationResponse);
        DownloadBlob(FileContent, ABSBlobFileGM.Name);
    end;


    local procedure InitalizeBlobClient(var ABSBlobClient: Codeunit "ABS Blob Client"; StorageAccountName: Text[1024]; ContainerName: Text[2048])
    var
        StorageAccountGM: Record "Storage Account GM";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Authorization: Interface "Storage Service Authorization";
    begin
        StorageAccountGM.Get(StorageAccountName);
        Authorization := StorageServiceAuthorization.CreateSharedKey(StorageAccountGM."Shared Key");
        ABSBlobClient.Initialize(StorageAccountName, ContainerName, Authorization);
    end;

    local procedure ShowErrorIfNotSuccessful(ABSOperationResponse: Codeunit "ABS Operation Response")
    begin
        if ABSOperationResponse.IsSuccessful() then
            exit;

        Error(ABSOperationResponse.GetError());
    end;

    local procedure DownloadBlob(BlobContent: Text; BlobName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        ToFile: Text;
        FileInStream: InStream;
        FileOutStream: OutStream;
    begin
        ToFile := BlobName;
        TempBlob.CreateOutStream(FileOutStream, TextEncoding::UTF8);
        FileOutStream.Write(BlobContent);
        TempBlob.CreateInStream(FileInStream, TextEncoding::UTF8);
        DownloadFromStream(FileInStream, '', '', '', ToFile);
    end;
}