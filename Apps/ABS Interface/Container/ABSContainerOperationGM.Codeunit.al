/// <summary>
/// This codeunit provides functionality to manage Azure Blob Storage containers. It allows you to create, delete, and perform other operations on the containers.
/// </summary>
codeunit 90000 "ABS Container Operation GM"
{

    /// <summary>
    /// Creates an Azure Blob Storage container with the specified name under the given storage account.
    /// </summary>
    /// <param name="StorageAccountName">The name of the Azure Storage Account where the container will be created.</param>
    /// <param name="ContainerName">The name of the container to be created in Azure Blob Storage.</param>
    procedure Create(StorageAccountName: Text[1024]; ContainerName: Text)
    var
        ABSContainerClient: Codeunit "ABS Container Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
    begin
        InitalizeContainerClient(ABSContainerClient, StorageAccountName);
        ABSOperationResponse := ABSContainerClient.CreateContainer(ContainerName);
        ShowErrorIfNotSuccessful(ABSOperationResponse);
        RefreshContainersList(StorageAccountName);
    end;

    /// <summary>
    /// Deletes an Azure Blob Storage container with the specified name under the given storage account.
    /// </summary>
    /// <param name="StorageAccountName">The name of the Azure Storage Account where the container exists.</param>
    /// <param name="ContainerName">The name of the container to be deleted from Azure Blob Storage.</param>
    procedure Delete(StorageAccountName: Text[1024]; ContainerName: Text)
    var
        ABSContainerClient: Codeunit "ABS Container Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
    begin
        InitalizeContainerClient(ABSContainerClient, StorageAccountName);
        ABSOperationResponse := ABSContainerClient.DeleteContainer(ContainerName);
        ShowErrorIfNotSuccessful(ABSOperationResponse);
        RefreshContainersList(StorageAccountName);
    end;

    local procedure InitalizeContainerClient(var ABSContainerClient: Codeunit "ABS Container Client"; StorageAccountName: Text[1024])
    var
        StorageAccountGM: Record "Storage Account GM";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Authorization: Interface "Storage Service Authorization";
    begin
        StorageAccountGM.Get(StorageAccountName);
        Authorization := StorageServiceAuthorization.CreateSharedKey(StorageAccountGM."Shared Key");
        ABSContainerClient.Initialize(StorageAccountName, Authorization);
    end;

    local procedure ShowErrorIfNotSuccessful(ABSOperationResponse: Codeunit "ABS Operation Response")
    begin
        if ABSOperationResponse.IsSuccessful() then
            exit;

        Error(ABSOperationResponse.GetError());
    end;

    local procedure RefreshContainersList(StorageAccountName: Text[1024])
    var
        StorageAccountGM: Record "Storage Account GM";
    begin
        StorageAccountGM.Get(StorageAccountName);
        StorageAccountGM.RefreshContainers();
    end;
}