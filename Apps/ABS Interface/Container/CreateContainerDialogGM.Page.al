/// <summary>
/// A Page that allows the user to enter values needed to create a container.
/// </summary>
page 90004 "Create Container Dialog GM"
{
    PageType = StandardDialog;
    Caption = 'Create Container';
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(ContainerName; ContainerName)
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the container name.';
                }
            }
        }
    }

    var
        ContainerName: Text;

    /// <summary>
    /// Gets the container name typed on the page.
    /// </summary>
    /// <returns>The container name typed on the page.</returns>
    procedure GetContainerName(): Text
    begin
        exit(ContainerName);
    end;
}