<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Check SQL Connection</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lblMessage" runat="server" Text="Checking connection..."></asp:Label>
            <br />
            <asp:GridView ID="GridView1" runat="server"></asp:GridView>
        </div>
    </form>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;
            using (System.Data.SqlClient.SqlConnection connection = new System.Data.SqlClient.SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();
                    lblMessage.Text = "Connection successful!";
                    
                    string query = "SELECT TOP 10 * FROM [dbo].[tbl_example]";
                    using (System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand(query, connection))
                    {
                        using (System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader())
                        {
                            System.Data.DataTable dataTable = new System.Data.DataTable();
                            dataTable.Load(reader);
                            GridView1.DataSource = dataTable;
                            GridView1.DataBind();
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Connection failed: " + ex.Message;
                }
            }
        }
    </script>
</body>
</html>