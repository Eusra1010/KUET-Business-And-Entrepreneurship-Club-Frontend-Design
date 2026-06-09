<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alumni - KBEC</title>
    <link rel="stylesheet" href="kbec.css">
    <link rel="stylesheet" href="executives.css">
</head>
<body>

<% if (Session["AdminId"] != null) { %>
<div class="admin-toolbar">
    <span>🔧 Admin Mode — Logged in as <strong><%= Session["AdminName"] %></strong></span>
    <div class="admin-toolbar-btns">
        <a href="admin-dashboard.aspx" class="toolbar-btn">Dashboard</a>
        <a href="admin-logout.aspx" class="toolbar-btn toolbar-logout">Logout</a>
    </div>
</div>
<% } %>

<header class="navbar">
    <div class="nav-left">
        <img src="logo.jpg" alt="Logo" />
        <h2>KBEC</h2>
    </div>
    <nav class="nav-links">
        <a href="kbec.aspx">Home</a>
        <a href="#">About</a>
        <a href="events.aspx">Events</a>
        <a href="executives.aspx">Alumni</a>
    </nav>
</header>

<section class="executives-page">

    <div class="executives-header">
        <h1>Our Alumni</h1>
        <p>The passionate team driving KBEC forward</p>
        <% if (Session["AdminId"] != null) { %>
        <a href="admin-add-executive.aspx" class="admin-add-btn">+ Add New Member</a>
        <% } %>
    </div>

    <div id="presidentSection" runat="server"></div>

    <div class="executives-divider">
        <span>Executive Members</span>
    </div>

    <div class="executives-grid" id="executivesGrid" runat="server"></div>

</section>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-left">
            <img src="logo.jpg" alt="Logo" />
            <h3>KUET Business &amp; Entrepreneurship Club</h3>
            <p>The Premier Business And Entrepreneurship Club of KUET.</p>
            <div class="footer-contact">
                <p>&#128205; SWC-302, Students Welfare Center, KUET</p>
                <p>&#128222; +880 1822 076 101</p>
                <p>&#9993; kbec.kuet@gmail.com</p>
            </div>
        </div>
        <div class="footer-right">
            <h4>Follow Us</h4>
            <div class="footer-social">
                <a href="https://www.facebook.com/KBEC.official/" target="_blank" rel="noopener noreferrer" aria-label="Facebook">F</a>
                <a href="https://www.instagram.com/kbec.kuet/" target="_blank" rel="noopener noreferrer" aria-label="Instagram">IG</a>
                <a href="https://www.linkedin.com/company/kuet-business-and-entrepreneurship-club/" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn">in</a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        &copy; 2026 KBEC Official. All Rights Reserved.
    </div>
</footer>

<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        LoadExecutives();
    }

    void LoadExecutives()
    {
        bool isAdmin = Session["AdminId"] != null;
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Executives WHERE IsActive=1 ORDER BY DisplayOrder", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder president = new System.Text.StringBuilder();
            System.Text.StringBuilder others = new System.Text.StringBuilder();
            bool firstDone = false;

            while (reader.Read())
            {
                string id = reader["Id"].ToString();
                string name = reader["Name"].ToString();
                string role = reader["Role"].ToString();
                string photo = reader["PhotoPath"].ToString();

                string adminButtons = "";
                if (isAdmin)
                {
                    adminButtons = "<div class='exec-admin-btns'>" +
                        "<a href='admin-edit-executive.aspx?id=" + id + "' class='exec-edit-btn'>✏️ Edit</a>" +
                        "<a href='admin-remove-executive.aspx?id=" + id + "' class='exec-remove-btn' onclick=\"return confirm('Remove this member?')\">🗑️ Remove</a>" +
                        "</div>";
                }

                if (!firstDone)
                {
                    president.Append("<div class='president-card'>");
                    president.Append("<div class='president-img-wrap'><img src='" + photo + "' alt='" + name + "' /></div>");
                    president.Append("<div class='president-info'>");
                    president.Append("<span class='exec-role-badge president-badge'>" + role + "</span>");
                    president.Append("<h2>" + name + "</h2>");
                    president.Append("<p>Leading KBEC with vision and dedication.</p>");
                    president.Append(adminButtons);
                    president.Append("</div></div>");
                    firstDone = true;
                }
                else
                {
                    others.Append("<div class='exec-card'>");
                    others.Append("<div class='exec-img-wrap'><img src='" + photo + "' alt='" + name + "' /></div>");
                    others.Append("<div class='exec-info'>");
                    others.Append("<span class='exec-role-badge'>" + role + "</span>");
                    others.Append("<h3>" + name + "</h3>");
                    others.Append(adminButtons);
                    others.Append("</div></div>");
                }
            }

            presidentSection.InnerHtml = president.ToString();
            executivesGrid.InnerHtml = others.ToString();
        }
    }
</script>

</body>
</html>