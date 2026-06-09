<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="auth.css">
<script runat="server">
    string message = "";
    string messageClass = "";

    void btnAdminLogin_Click(object sender, EventArgs e)
    {
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text.Trim();
        string secretKey = txtSecretKey.Text.Trim();

        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
        {
            message = "Email and password are required.";
            messageClass = "auth-server-msg error";
            return;
        }

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            if (!string.IsNullOrEmpty(secretKey))
            {
                string superQuery = "SELECT Id, Name FROM Admins WHERE Email=@Email AND PasswordHash=@Password AND SecretKey=@SecretKey";
                SqlCommand superCmd = new SqlCommand(superQuery, conn);
                superCmd.Parameters.AddWithValue("@Email", email);
                superCmd.Parameters.AddWithValue("@Password", password);
                superCmd.Parameters.AddWithValue("@SecretKey", secretKey);
                SqlDataReader superReader = superCmd.ExecuteReader();

                if (superReader.Read())
                {
                    Session.Clear();
                    Session["AdminId"] = superReader["Id"].ToString();
                    Session["AdminName"] = superReader["Name"].ToString();
                    Session["AdminRole"] = "SuperAdmin";
                    superReader.Close();
                    Response.Redirect("kbec.aspx");
                    return;
                }
                superReader.Close();
                message = "Invalid credentials or secret code.";
                messageClass = "auth-server-msg error";
                return;
            }

            string memberQuery = "SELECT Id, Name, Position FROM MemberAdmins WHERE Email=@Email AND PasswordHash=@Password";
            SqlCommand memberCmd = new SqlCommand(memberQuery, conn);
            memberCmd.Parameters.AddWithValue("@Email", email);
            memberCmd.Parameters.AddWithValue("@Password", password);
            SqlDataReader memberReader = memberCmd.ExecuteReader();

            if (memberReader.Read())
            {
                Session.Clear();
                Session["AdminId"] = memberReader["Id"].ToString();
                Session["AdminName"] = memberReader["Name"].ToString();
                Session["AdminRole"] = "MemberAdmin";
                Session["AdminPosition"] = memberReader["Position"].ToString();
                memberReader.Close();
                Response.Redirect("member-dashboard.aspx");
                return;
            }

            message = "Invalid email or password.";
            messageClass = "auth-server-msg error";
        }
    }
</script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="auth-wrapper">
        <div class="auth-box">

            <div class="auth-logo">
                <img src="logo.jpg" alt="KBEC Logo" />
                <h2>KBEC</h2>
            </div>

            <h1 class="auth-title">Admin Login</h1>
            <p class="auth-subtitle">KBEC Management Portal</p>

            <% if (!string.IsNullOrEmpty(message)) { %>
                <div class="<%= messageClass %>"><%= message %></div>
            <% } %>

            <div class="auth-form">
                <div class="form-group">
                    <label>Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="Enter your email" />
                    <span id="emailError" class="field-error"></span>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter your password" />
                        <button type="button" class="toggle-pw" onclick="togglePassword('<%=txtPassword.ClientID%>', this)">Show</button>
                    </div>
                    <span id="pwError" class="field-error"></span>
                </div>
                <div class="form-group">
                    <label>Secret Code <span style="color:#555;font-size:0.78rem;font-weight:400;">(Super Admin only)</span></label>
                    <div class="input-wrap">
                        <asp:TextBox ID="txtSecretKey" runat="server" CssClass="form-input" TextMode="Password" placeholder="Leave empty if not Super Admin" />
                        <button type="button" class="toggle-pw" onclick="togglePassword('<%=txtSecretKey.ClientID%>', this)">Show</button>
                    </div>
                </div>

                <asp:Button ID="btnAdminLogin" runat="server" Text="Login"
                    CssClass="auth-btn" OnClick="btnAdminLogin_Click"
                    OnClientClick="return validateForm()" />

                <p class="auth-switch"><a href="kbec.aspx">Back to Website</a></p>
            </div>
        </div>
    </div>
    </form>
    <script>
        function togglePassword(fieldId, btn) {
            var field = document.getElementById(fieldId);
            if (field.type === 'password') { field.type = 'text'; btn.textContent = 'Hide'; }
            else { field.type = 'password'; btn.textContent = 'Show'; }
        }

        function validateForm() {
            var valid = true;
            var email = document.getElementById('<%=txtEmail.ClientID%>').value.trim();
            var pw = document.getElementById('<%=txtPassword.ClientID%>').value;
            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('emailError').textContent = 'Enter a valid email.';
                valid = false;
            } else { document.getElementById('emailError').textContent = ''; }
            if (!pw) {
                document.getElementById('pwError').textContent = 'Password is required.';
                valid = false;
            } else { document.getElementById('pwError').textContent = ''; }
            return valid;
        }
    </script>
</body>
</html>