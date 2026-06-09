<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Executive - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="auth.css">
<script runat="server">
    string message = "";
    string messageClass = "";
    string execId = "";

    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");

        execId = Request.QueryString["id"];

        if (!IsPostBack)
        {
            string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT * FROM Executives WHERE Id=@Id", conn);
                cmd.Parameters.AddWithValue("@Id", execId);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtName.Text = reader["Name"].ToString();
                    txtRole.Text = reader["Role"].ToString();
                    txtPhoto.Text = reader["PhotoPath"].ToString();
                    txtOrder.Text = reader["DisplayOrder"].ToString();
                }
            }
        }
    }

    void btnSave_Click(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("UPDATE Executives SET Name=@Name, Role=@Role, PhotoPath=@Photo, DisplayOrder=@Order WHERE Id=@Id", conn);
            cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
            cmd.Parameters.AddWithValue("@Role", txtRole.Text.Trim());
            cmd.Parameters.AddWithValue("@Photo", txtPhoto.Text.Trim());
            cmd.Parameters.AddWithValue("@Order", int.Parse(txtOrder.Text.Trim()));
            cmd.Parameters.AddWithValue("@Id", execId);
            cmd.ExecuteNonQuery();
        }
        message = "Member updated successfully!";
        messageClass = "auth-server-msg success";
    }
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="auth-wrapper">
        <div class="auth-box">
            <h1 class="auth-title">Edit Executive Member</h1>
            <% if (!string.IsNullOrEmpty(message)) { %>
                <div class="<%= messageClass %>"><%= message %></div>
            <% } %>
            <div class="auth-form">
                <div class="form-group">
                    <label>Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-input" />
                </div>
                <div class="form-group">
                    <label>Role / Position</label>
                    <asp:TextBox ID="txtRole" runat="server" CssClass="form-input" />
                </div>
                <div class="form-group">
                    <label>Photo Path</label>
                    <asp:TextBox ID="txtPhoto" runat="server" CssClass="form-input" />
                </div>
                <div class="form-group">
                    <label>Display Order</label>
                    <asp:TextBox ID="txtOrder" runat="server" CssClass="form-input" />
                </div>
                <asp:Button ID="btnSave" runat="server" Text="Save Changes"
                    CssClass="auth-btn" OnClick="btnSave_Click" />
                <p class="auth-switch"><a href="executives.aspx">← Back to Alumni</a></p>
            </div>
        </div>
    </div>
    </form>
</body>
</html>