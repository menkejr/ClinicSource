using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using System.Data.SqlClient;

public partial class Default : System.Web.UI.Page 
{
    static String ConnString = ConfigurationManager.ConnectionStrings["PatientsConnection"].ConnectionString;    
    SqlDataAdapter adapter = new SqlDataAdapter();
    SqlConnection conn = new SqlConnection(ConnString);

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void PatientsGrid_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
    {        
        PatientsGrid.DataSource = GetPatientsTable(); 
    }

    public DataTable GetPatientsTable()
    {
        string query = "SELECT * FROM Patients WHERE Deleted <> 1";        
        adapter.SelectCommand = new SqlCommand(query, conn);

        DataTable patientTable = new DataTable();

        conn.Open();
        try
        {
            adapter.Fill(patientTable);
        }
        finally
        {
            conn.Close();
        }

        return patientTable;
    }   

    protected void RadToolBar1_ButtonClick(object sender, RadToolBarEventArgs e)
    {
        var btnName = e.Item.Value;
        if(btnName == "New")
        {
            AddNewPatientRow();
            ClearDataEntryFields();
        }
        else if(btnName == "Save")
        {
            var item = PatientsGrid.SelectedItems[0] as Telerik.Web.UI.GridDataItem;
            int id = (int)item.GetDataKeyValue("ID");            
            UpdatePatientRow(id);
            ClearDataEntryFields();
        }    
        else if(btnName == "Delete")
        {
            string ids = string.Empty;
            foreach (Telerik.Web.UI.GridDataItem i in PatientsGrid.SelectedItems)
            {
                int id = (int)i.GetDataKeyValue("ID");
                ids = ids + id + ", ";
            }
            ids = ids.TrimEnd().Substring(0, ids.LastIndexOf(','));            
            DeletePatientRow(ids);
            ClearDataEntryFields();
        }
        
    }

    private void DeletePatientRow(string ids)
    {
        string query = "SELECT * FROM Patients WHERE Id in (" + ids + ")";
        adapter.SelectCommand = new SqlCommand(query, conn);
        DataSet dsPatients = new DataSet();
        conn.Open();
        try
        {
            adapter.Fill(dsPatients, "Patients");
            foreach (DataRow row in dsPatients.Tables["Patients"].Rows)
            {
                row["Deleted"] = 1;
            }            
            new SqlCommandBuilder(adapter);
            adapter.Update(dsPatients, "Patients");
        }
        finally
        {
            conn.Close();
            PatientsGrid.DataSource = GetPatientsTable();
            PatientsGrid.DataBind();
        }
    }

    private void ClearDataEntryFields()
    {
        tbId.Text = string.Empty;
        tbFName.Text = string.Empty;
        tbLName.Text = string.Empty;
        tbAllergies.Text = string.Empty;
        dpDOB.Clear();        
    }

    private void UpdatePatientRow(int id)
    {        
        string query = "SELECT * FROM Patients WHERE Id = " + id ;
        adapter.SelectCommand = new SqlCommand(query, conn);
        DataSet dsPatients = new DataSet();
        conn.Open();
        try
        {
            adapter.Fill(dsPatients, "Patients");
            dsPatients.Tables["Patients"].Rows[0]["FirstName"] = tbFName.Text;
            dsPatients.Tables["Patients"].Rows[0]["LastName"] = tbLName.Text;
           
            if (dpDOB.DateInput.DisplayText == "")
            {
                dsPatients.Tables["Patients"].Rows[0]["DOB"] = DBNull.Value;
            }
            else
            {
                dsPatients.Tables["Patients"].Rows[0]["DOB"] = dpDOB.DateInput.DisplayText;
            }
            
            dsPatients.Tables["Patients"].Rows[0]["Allergies"] = tbAllergies.Text;
            dsPatients.Tables["Patients"].Rows[0]["Deleted"] = 0;
            new SqlCommandBuilder(adapter);
            adapter.Update(dsPatients, "Patients");
        }
        finally
        {
            conn.Close();
            PatientsGrid.DataSource = GetPatientsTable();
            PatientsGrid.DataBind();
        }
    }

    private void AddNewPatientRow()
    {
        var query = "select * from Patients where 0 = 1";        
        adapter.SelectCommand = new SqlCommand(query, conn);
        DataSet dsPatients = new DataSet();
        conn.Open();
        try
        {
            adapter.Fill(dsPatients, "Patients");
            var newRow = dsPatients.Tables["Patients"].NewRow();
            newRow["Deleted"] = 0;
            dsPatients.Tables["Patients"].Rows.Add(newRow);
            new SqlCommandBuilder(adapter);            
            adapter.Update(dsPatients, "Patients");
        }
        finally
        {
            conn.Close();
            PatientsGrid.DataSource = GetPatientsTable();            
            PatientsGrid.DataBind();
        }
       
    }
}
