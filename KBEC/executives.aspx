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
    <div class="nav-right">
        <div style="position:relative;">
            <button class="profile-btn" id="profileMenuButton" type="button"
                aria-haspopup="true" aria-expanded="false" aria-controls="profileMenu">
                <span class="sr-only">Menu</span>
                <svg class="profile-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                    <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2c-4.42 0-8 2-8 4.5A1.5 1.5 0 0 0 5.5 20h13A1.5 1.5 0 0 0 20 18.5C20 16 16.42 14 12 14Z" />
                </svg>
                <% if (Session["AdminId"] != null) { %>
                <span class="profile-admin-dot" title="Logged in as Admin"></span>
                <% } else if (Session["UserId"] != null) { %>
                <span class="profile-user-dot" title="Logged in"></span>
                <% } %>
            </button>

            <div class="profile-menu" id="profileMenu" hidden>
                <% if (Session["AdminId"] != null) { %>
                
                <button type="button" class="profile-menu-item" onclick="window.location.href='admin-dashboard.aspx'">Dashboard</button>
                <div class="profile-menu-divider"></div>
                <button type="button" class="profile-menu-item profile-menu-logout" onclick="window.location.href='admin-logout.aspx'">Logout</button>

                <% } else if (Session["UserId"] != null) { %>
                <div class="profile-menu-title"><%= Session["UserName"] %></div>
                <button type="button" class="profile-menu-item" onclick="window.location.href='member-profile.aspx'">My Profile</button>
                <div class="profile-menu-divider"></div>
                <button type="button" class="profile-menu-item profile-menu-logout" onclick="window.location.href='member-logout.aspx'">Logout</button>

                <% } else { %>
                <div class="profile-menu-title">Login as</div>
                <button type="button" class="profile-menu-item" onclick="window.location.href='member-login.aspx'">Member Login</button>
                <div class="profile-menu-divider"></div>
                <button type="button" class="profile-menu-item" onclick="window.location.href='admin-login.aspx'">Admin Login</button>
                <% } %>
            </div>
        </div>
    </div>
</header>

<section class="executives-page">

    <div class="executives-header">
        <h1>Our Alumni</h1>
        <p>The passionate team driving KBEC forward</p>
        <% if (Session["AdminId"] != null) { %>
        <a href="admin-add-executive.aspx" class="admin-add-btn">+ Add New Executive</a>
        <% } %>
    </div>

    <div id="presidentSection" runat="server"></div>

    <div class="executives-divider"><span>Executive Members</span></div>
    <div class="executives-grid" id="executivesGrid" runat="server"></div>

    <div id="membersSection" runat="server"></div>

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
        LoadApprovedMembers();
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
                        "<a href='admin-edit-executive.aspx?id=" + id + "' class='exec-edit-btn'>Edit</a>" +
                        "<a href='admin-remove-executive.aspx?id=" + id + "' class='exec-remove-btn' onclick=\"return confirm('Remove this member?')\">Remove</a>" +
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

    void LoadApprovedMembers()
    {
        bool isAdmin = Session["AdminId"] != null;
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(
                "SELECT * FROM Members WHERE Status='Approved' ORDER BY CreatedAt ASC", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            bool hasMembers = false;

            while (reader.Read())
            {
                hasMembers = true;
                string id = reader["Id"].ToString();
                string name = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                string dept = reader["Department"].ToString();
                string batch = reader["Batch"].ToString();
                string pic = reader["ProfilePicturePath"] == DBNull.Value
                    ? "images/members/default.jpg"
                    : reader["ProfilePicturePath"].ToString();

                string adminButtons = "";
                if (isAdmin)
                {
                    adminButtons = "<div class='exec-admin-btns'>" +
                        "<a href='admin-edit-member.aspx?id=" + id + "' class='exec-edit-btn'>Edit</a>" +
                        "<a href='admin-remove-member.aspx?id=" + id + "' class='exec-remove-btn' onclick=\"return confirm('Remove this member?')\">Remove</a>" +
                        "</div>";
                }

                sb.Append("<div class='exec-card'>");
                sb.Append("<div class='exec-img-wrap'><img src='" + pic + "' alt='" + name + "' onerror=\"this.src='images/members/default.jpg'\" /></div>");
                sb.Append("<div class='exec-info'>");
                sb.Append("<span class='exec-role-badge member-badge'>Member</span>");
                sb.Append("<h3>" + name + "</h3>");
                sb.Append("<span class='exec-member-dept'>" + dept + " &middot; Batch " + batch + "</span>");
                sb.Append(adminButtons);
                sb.Append("</div></div>");
            }
            reader.Close();

            if (hasMembers)
            {
                string memberSection =
                    "<div class='executives-divider'><span>Club Members</span></div>" +
                    "<div class='executives-grid'>" + sb.ToString() + "</div>";
                membersSection.InnerHtml = memberSection;
            }
        }
    }
</script>

<script src="kbec.js"></script>
</body>
</html>