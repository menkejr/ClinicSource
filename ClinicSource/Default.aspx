<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
    <style type="text/css">
        label.EntryLabelStyle.riLabel {
            width: 37%;
            margin-left: 10px;
        }

        .wrapper {
            margin-left: 10px;
        }

        .text-header {
            color: black;
            text-align: center;
            transform:translate(50px,10px);
            width: 100px;
            position:relative;
            background-color: white;
            font-family: Arial, Helvetica, sans-serif;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
            </Scripts>
        </telerik:RadScriptManager>
        <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
            <script type="text/javascript">

                var tbId;
                var tbFName;
                var tbLName;
                var dpDOB;
                var tbAllergies;

                function PatientRowDeselected(sender, args) {
                    if (!tbId) {
                        FindDataFields();
                    }
                    ClearDataFields();
                    AssignValuesToDataFields();
                }

                function ToolBarButtonClicking(sender, args) {
                    if (!tbId) {
                        FindDataFields();
                    }

                    var btn = args.get_item()._properties._data.value;
                    var grid = $find('PatientsGrid');
                    var selectedIndexes = grid._selectedIndexes.length;


                    if ((btn === 'Edit' || btn === 'Save') && selectedIndexes === 0) {
                        args.set_cancel(true);
                    }

                    if (btn === 'Save') {
                        var id = tbId.get_value();
                        var date = dpDOB._dateInput._lastSetTextBoxValue;
                        if (date != "" && !isDate(date) && date != undefined) {
                            args.set_cancel(true);
                        } else if (id === undefined || id === "") {
                            args.set_cancel(true);
                        }
                    }
                    if (btn === 'Delete') {
                        if (!confirm('Are you sure you want to delete these record(s)?')) {
                            args.set_cancel(true);
                        }
                    }

                }
                function ToolBarButtonClicked(sender, args) {
                    var btn = args.get_item()._properties._data.value;

                    if (btn === 'New') {
                        if (!tbId) {
                            FindDataFields();
                        }
                        ClearDataFields();
                    } else if (btn === 'Edit') {
                        AssignValuesToDataFields();
                    } else if (btn === 'Print') {
                        window.print();
                    }
                }
                function GridCreated(sender, args) {
                    if (!tbId) {
                        FindDataFields();
                    }
                    ClearDataFields();
                }
                function FindDataFields() {
                    var now = new Date();
                    tbId = $find('tbId');
                    tbFName = $find('tbFName');
                    tbLName = $find('tbLName');
                    dpDOB = $find('dpDOB');
                    SetMaxDate();
                    tbAllergies = $find('tbAllergies');
                }
                function AssignValuesToDataFields() {
                    var grid = $find('PatientsGrid');
                    var masterTable = grid.get_masterTableView();
                    var row = masterTable.get_dataItems()[grid._selectedIndexes[0]];

                    var id = masterTable.getCellByColumnUniqueName(row, "ID").innerText;
                    var fName = masterTable.getCellByColumnUniqueName(row, "FirstName").innerText;
                    var lName = masterTable.getCellByColumnUniqueName(row, "LastName").innerText;
                    var DOB = masterTable.getCellByColumnUniqueName(row, "DOB").innerText;
                    var allergies = masterTable.getCellByColumnUniqueName(row, "Allergies").innerText;
                    
                    tbId.set_value(id);
                    tbFName.set_value(fName);
                    tbLName.set_value(lName);
                    if (DOB.trim() != "") {
                        dpDOB.set_selectedDate(new Date(DOB));
                    }                    
                    tbAllergies.set_value(allergies);
                }
                function ClearDataFields() {
                    tbId.clear();
                    tbFName.clear();
                    tbLName.clear();
                    dpDOB.clear();
                    tbAllergies.clear();
                }
                function SetMaxDate() {
                    var now = new Date();
                    dpDOB.set_maxDate(new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours()));
                }

                var isDate = function (date) {
                    return (new Date(date) !== "Invalid Date") && !isNaN(new Date(date));
                }
            </script>
        </telerik:RadCodeBlock>
        <telerik:RadWindowManager ID="RadWindowManager1" runat="server">
        </telerik:RadWindowManager>
        <telerik:RadAjaxLoadingPanel runat="server" ID="RadAjaxLoadingPanel1" Transparency="50"></telerik:RadAjaxLoadingPanel>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="RadToolBar1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="PatientsGrid" LoadingPanelID="RadAjaxLoadingPanel1" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="PatientEntry">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="tbId" />
                        <telerik:AjaxUpdatedControl ControlID="tbFName" />
                        <telerik:AjaxUpdatedControl ControlID="tbLName" />
                        <telerik:AjaxUpdatedControl ControlID="dpDOB" />
                        <telerik:AjaxUpdatedControl ControlID="tbAllergies" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>

        </telerik:RadAjaxManager>
        <div style="margin-bottom: 20px">
            <telerik:RadToolBar RenderMode="Lightweight" ID="RadToolBar1" runat="server" BorderColor="Black"
                BorderWidth="1px" BorderStyle="Solid" OnClientButtonClicked="ToolBarButtonClicked" OnClientButtonClicking="ToolBarButtonClicking"
                OnButtonClick="RadToolBar1_ButtonClick" AutoPostBack="true">
                <Items>
                    <telerik:RadToolBarButton ImageUrl="~/Images/SaveIcon.png" runat="server" Value="Save"></telerik:RadToolBarButton>
                    <telerik:RadToolBarButton ImageUrl="~/Images/AddNewPatientIcon.png" runat="server" Value="New"></telerik:RadToolBarButton>
                    <telerik:RadToolBarButton ImageUrl="~/Images/EditIcon.png" runat="server" Value="Edit" PostBack="false"></telerik:RadToolBarButton>
                    <telerik:RadToolBarButton ImageUrl="~/Images/DeleteIcon.png" runat="server" Value="Delete"></telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" IsSeparator="true"></telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" ImageUrl="~/Images/PrintIcon.png" Value="Print"></telerik:RadToolBarButton>
                </Items>
            </telerik:RadToolBar>
        </div>

        <div style="margin: 10px">
            <div class="text-header">PATIENTS</div>
            <telerik:RadAjaxPanel runat="server" ID="PatientEntry" BorderWidth="1px" BorderStyle="Solid"
                BorderColor="#99ccff" Style="border-radius: 25px;" Width="30%">
                <br />
                <telerik:RadTextBox RenderMode="Lightweight" runat="server" ID="tbId" Label="Id:" LabelWidth="47%" WrapperCssClass="wrapper"
                    Enabled="false">
                </telerik:RadTextBox>
                <br />
                <telerik:RadTextBox RenderMode="Lightweight" runat="server" ID="tbFName" Label="First Name:" Width="250px" WrapperCssClass="wrapper">
                </telerik:RadTextBox>
                <br />
                <telerik:RadTextBox RenderMode="Lightweight" runat="server" ID="tbLName" Label="Last Name:" WrapperCssClass="wrapper" Width="250px">
                </telerik:RadTextBox>
                <br />
                <telerik:RadDatePicker runat="server" ID="dpDOB" Width="250px">
                    <DateInput runat="server" DateFormat="MM/dd/yyyy" DisplayDateFormat="MM/dd/yyyy" Label="DOB:" WrapperCssClass="wrapper" LabelCssClass="EntryLabelStyle" />
                </telerik:RadDatePicker>
                <br />
                <br />
                <telerik:RadTextBox RenderMode="Lightweight" runat="server" ID="tbAllergies" Label="Allergies:" WrapperCssClass="wrapper" LabelWidth="27%" Width="350px">
                </telerik:RadTextBox>
                <br />
                <br />

            </telerik:RadAjaxPanel>
        </div>
        <div style="margin: 10px">
            <telerik:RadGrid runat="server" RenderMode="Lightweight" ID="PatientsGrid" AllowPaging="True" AllowMultiRowSelection="true" AllowSorting="true"
                OnNeedDataSource="PatientsGrid_NeedDataSource" PageSize="3">
                <PagerStyle Mode="NextPrevAndNumeric" Position="Bottom" PageSizeControlType="RadComboBox"></PagerStyle>
                <ClientSettings Selecting-AllowRowSelect="true">
                    <ClientEvents OnRowDeselected="PatientRowDeselected" OnGridCreated="GridCreated" />
                </ClientSettings>
                <MasterTableView DataKeyNames="ID" AutoGenerateColumns="false">
                    <Columns>
                        <telerik:GridClientSelectColumn UniqueName="ClientRowSelect">
                        </telerik:GridClientSelectColumn>
                        <telerik:GridBoundColumn UniqueName="ID" HeaderText="ID" DataField="ID"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn UniqueName="LastName" HeaderText="Last Name" DataField="LastName"></telerik:GridBoundColumn>
                        <telerik:GridBoundColumn UniqueName="FirstName" HeaderText="First Name" DataField="FirstName"></telerik:GridBoundColumn>
                        <telerik:GridDateTimeColumn UniqueName="DOB" HeaderText="DOB" DataField="DOB" DataFormatString="{0:MM/dd/yyyy}"></telerik:GridDateTimeColumn>
                        <telerik:GridBoundColumn UniqueName="Allergies" HeaderText="Allergies" DataField="Allergies"></telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
        </div>


    </form>
</body>
</html>
