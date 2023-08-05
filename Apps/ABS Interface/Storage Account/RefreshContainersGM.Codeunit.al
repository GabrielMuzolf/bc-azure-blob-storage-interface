/// <summary>
/// Provides functionality to refresh the list of containers related to the storage account.
/// </summary>
codeunit 90001 "Refresh Containers GM"
{
    /// <summary>
    /// Refreshes the containers list for a given <paramref name="StorageAccountGM"/>. 
    /// Removes the currently defined containers for the storage account and replaces them with the defined Azure Blob Storage containers structure.
    /// </summary>
    /// <param name="StorageAccountGM">Storage account to refresh.</param>
    procedure RefreshContainers(StorageAccountGM: Record "Storage Account GM")
    var
        TempABSContainer: Record "ABS Container" temporary;
    begin
        StorageAccountGM.DeleteContainers();
        FillABSContainerBuffer(StorageAccountGM, TempABSContainer);
        InsertStorageContainers(StorageAccountGM, TempABSContainer);
    end;

    local procedure FillABSContainerBuffer(StorageAccountGM: Record "Storage Account GM"; var TempABSContainer: Record "ABS Container")
    var
        ABSContainerClient: Codeunit "ABS Container Client";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
    begin
        Authorization := StorageServiceAuthorization.CreateSharedKey(StorageAccountGM."Shared Key");
        ABSContainerClient.Initialize(StorageAccountGM.Name, Authorization);
        ABSOperationResponse := ABSContainerClient.ListContainers(TempABSContainer);
        if not ABSOperationResponse.IsSuccessful() then
            Error(ABSOperationResponse.GetError());
    end;

    local procedure InsertStorageContainers(StorageAccountGM: Record "Storage Account GM"; var TempABSContainer: Record "ABS Container")
    var
        ABSContainerGM: Record "ABS Container GM";
    begin
        if not TempABSContainer.FindSet() then
            exit;

        repeat
            ABSContainerGM.Init();
            ABSContainerGM.Validate("Storage Account Name", StorageAccountGM.Name);
            ABSContainerGM.Validate(Name, TempABSContainer.Name);
            ABSContainerGM.Validate("Last Modified", TempABSContainer."Last Modified");
            ABSContainerGM.Insert(true);
        until TempABSContainer.Next() = 0;
    end;
}
