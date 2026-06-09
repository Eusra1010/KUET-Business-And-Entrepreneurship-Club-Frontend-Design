<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Executive - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="auth.css">
<script runat="server">
    string message = "";
    string messageClass = "";

    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
            Response.Redirect("admin-login.aspx");
    }

    void btnAdd_Click(object sender, EventArgs e)
    {
        string name = txtName.Text.Trim();
        string role = txtRole.Text.Trim();
        string photo = txtPhoto.Text.Trim();
        string order = txtOrder.Text.Trim();

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(role) || string.IsNullOrEmpty(photo))
        {
            message = "Name, role and photo path are required.";
            messageClass = "auth-server-msg error";
            return;
        }

        int displayOrder = string.IsNullOrEmpty(order) ? 99 : int.Parse(order);

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("INSERT INTO Executives (Name, Role, PhotoPath, DisplayOrder) VALUES (@Name, @Role, @Photo, @Order)", conn);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Role", role);
            cmd.Parameters.AddWithValue("@Photo", photo);
            cmd.Parameters.AddWithValue("@Order", displayOrder);
            cmd.ExecuteNonQuery();
        }

        message = "Member added successfully!";
        messageClass = "auth-server-msg success";
    }
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="auth-wrapper">
        <div class="auth-box">
            <h1 class="auth-title">Add Executive Member</h1>
            <% if (!string.IsNullOrEmpty(message)) { %>
                <div class="<%= messageClass %>"><%= message %></div>
            <% } %>
            <div class="auth-form">
                <div class="form-group">
                    <label>Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="Enter name" />
                </div>
                <div class="form-group">
                    <label>Role / Position</label>
                    <asp:TextBox ID="txtRole" runat="server" CssClass="form-input" placeholder="e.g. Vice President" />
                </div>
                <div class="form-group">
                    <label>Photo Path</label>
                    <asp:TextBox ID="txtPhoto" runat="server" CssClass="form-input" placeholder="images/executives/photo.jpg" />
                </div>
                <div class="form-group">
                    <label>Display Order</label>
                    <asp:TextBox ID="txtOrder" runat="server" CssClass="form-input" placeholder="e.g. 10" />
                </div>
                <asp:Button ID="btnAdd" runat="server" Text="Add Member"
                    CssClass="auth-btn" OnClick="btnAdd_Click" />
                <p class="auth-switch"><a href="executives.aspx">← Back to Alumni</a></p>
            </div>
        </div>
    </div>
    </form>
</body>
</html>