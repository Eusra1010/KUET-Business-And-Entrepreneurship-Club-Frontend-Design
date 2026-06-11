<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBEC - KUET Business &amp; Entrepreneurship Club</title>
    <link rel="stylesheet" href="kbec.css">
    <style>
        /* ===== HERO VIDEO BACKGROUND ===== */
        .hero {
            position: relative;
            width: 100%;
            min-height: 80vh; /* Ensures a spacious cinematic layout */
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background-color: #0b0f14; /* Solid fallback color */
        }

        .hero-video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover; /* Crops cleanly to fill container proportions */
            z-index: 0;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(11, 15, 20, 0.65); /* Keeps white text readable over video */
            z-index: 1;
        }

        .hero-text {
            position: relative;
            z-index: 2; /* Ensures content stays on top of video layers */
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* ===== ABOUT SECTION ===== */
        .about-section {
            padding: 100px 60px;
            background: radial-gradient(circle at bottom right, rgba(245,197,24,0.06), transparent 50%), #0b0f14;
            position: relative;
            overflow: hidden;
        }

        .about-section::before {
            content: "";
            position: absolute;
            inset: 0;
            background-image: linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
                              linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
            background-size: 48px 48px;
            pointer-events: none;
        }

        .about-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: start;
            position: relative;
            z-index: 1;
        }

        .about-left h2 {
            font-size: clamp(48px, 6vw, 80px);
            font-weight: 800;
            color: #fff;
            line-height: 1;
            margin-bottom: 24px;
            letter-spacing: -1px;
        }

        .about-left h2 span {
            color: #f5c518;
        }

        .about-left p {
            color: #aaa;
            font-size: 1rem;
            line-height: 1.8;
            margin-bottom: 32px;
            max-width: 480px;
        }

        .about-founded {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 18px;
            border-radius: 999px;
            background: rgba(245,197,24,0.08);
            border: 1px solid rgba(245,197,24,0.25);
            color: #f5c518;
            font-size: 0.82rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        .about-founded-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #f5c518;
        }

        .about-right {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .about-card {
            background: rgba(17,17,17,0.9);
            border: 1px solid rgba(245,197,24,0.12);
            border-radius: 16px;
            padding: 24px;
            transition: border-color 0.2s, transform 0.2s;
        }

        .about-card:hover {
            border-color: rgba(245,197,24,0.3);
            transform: translateX(4px);
        }

        .about-card-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: rgba(245,197,24,0.1);
            border: 1px solid rgba(245,197,24,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            margin-bottom: 12px;
        }

        .about-card h3 {
            color: #f5c518;
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .about-card p {
            color: #888;
            font-size: 0.88rem;
            line-height: 1.6;
        }

        .about-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-top: 8px;
        }

        .about-stat {
            background: rgba(17,17,17,0.9);
            border: 1px solid #1e1e1e;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
        }

        .about-stat strong {
            display: block;
            font-size: 1.6rem;
            font-weight: 800;
            color: #f5c518;
            line-height: 1;
            margin-bottom: 4px;
        }

        .about-stat span {
            color: #666;
            font-size: 0.75rem;
        }

        @media (max-width: 900px) {
            .about-inner {
                grid-template-columns: 1fr;
                gap: 40px;
            }
            .about-section {
                padding: 80px 24px;
            }
            .about-stats {
                grid-template-columns: repeat(3, 1fr);
            }
        }
    </style>
<script runat="server">
    int noticeCount = 0;

    void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            if (Session["UserId"] != null)
            {
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Notices WHERE IsActive=1", conn);
                noticeCount = (int)cmd.ExecuteScalar();
            }

            SqlCommand sCmd = new SqlCommand("SELECT * FROM Sponsors WHERE IsActive=1 ORDER BY DisplayOrder ASC", conn);
            SqlDataReader reader = sCmd.ExecuteReader();

            var items = new System.Collections.Generic.List<string>();
            while (reader.Read())
            {
                string name = reader["Name"].ToString();
                string logo = reader["LogoPath"].ToString();
                string url = reader["WebsiteUrl"] == DBNull.Value ? "" : reader["WebsiteUrl"].ToString();

                string item = string.IsNullOrEmpty(url)
                    ? "<div><img src='" + logo + "' alt='" + name + "' /></div>"
                    : "<div><a href='" + url + "' target='_blank' rel='noopener noreferrer'><img src='" + logo + "' alt='" + name + "' /></a></div>";
                items.Add(item);
            }
            reader.Close();

            var sb = new System.Text.StringBuilder();
            foreach (string item in items) sb.Append(item);
            foreach (string item in items)
                sb.Append(item.Replace("<div>", "<div aria-hidden='true'>")
                             .Replace("<div><a ", "<div aria-hidden='true'><a "));

            sponsorLogos.InnerHtml = sb.ToString();
        }
    }
</script>
</head>

<body class="<%= Session["AdminId"] != null ? "admin-mode" : "" %>">

<% if (Session["AdminId"] != null) { %>
<div class="admin-toolbar">
    <span>Admin Mode — <strong><%= Session["AdminName"] %></strong></span>
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
            <a href="#about">About</a>
            <a href="events.aspx">Events</a>
            <a href="executives.aspx">Alumni</a>
        </nav>
        <div class="nav-right">
            <% if (Session["UserId"] != null) { %>
            <div class="notif-wrap" style="position:relative;">
                <button class="notif-btn" id="notifBtn" type="button" onclick="toggleNotif()">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
                        <path d="M12 22a2 2 0 0 0 2-2h-4a2 2 0 0 0 2 2zm6-6V11a6 6 0 0 0-5-5.91V4a1 1 0 0 0-2 0v1.09A6 6 0 0 0 6 11v5l-2 2v1h16v-1l-2-2z"/>
                    </svg>
                    <% if (noticeCount > 0) { %>
                    <span class="notif-badge"><%= noticeCount %></span>
                    <% } %>
                </button>
                <div class="notif-dropdown" id="notifDropdown" hidden>
                    <div class="notif-title">Notices</div>
                    <div id="notifList" runat="server"></div>
                    <a href="notices.aspx" class="notif-view-all">View all notices</a>
                </div>
            </div>
            <% } %>

            <div style="position:relative;">
                <button class="profile-btn" id="profileMenuButton" type="button"
                    aria-haspopup="true" aria-expanded="false" aria-controls="profileMenu">
                    <span class="sr-only">Menu</span>
                    <svg class="profile-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                        <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2c-4.42 0-8 2-8 4.5A1.5 1.5 0 0 0 5.5 20h13A1.5 1.5 0 0 0 20 18.5C20 16 16.42 14 12 14Z" />
                    </svg>
                    <% if (Session["AdminId"] != null) { %>
                    <span class="profile-admin-dot" title="Logged in as admin"></span>
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

    <section class="hero">
        <video autoplay muted loop playsinline class="hero-video">
            <source src="kbec-video.mp4" type="video/mp4">
        </video>
        <div class="hero-overlay"></div>

        <div class="hero-text">
            <h1>KBEC</h1>
            <p>
                Igniting innovation, leadership, and entrepreneurial excellence at KUET.
                Empowering students to grow, lead, and succeed globally.
            </p>
            <div class="hero-buttons">
                <button class="btn btn-outline" type="button" onclick="scrollToAbout()">Discover More</button>
                <a class="btn btn-primary" href="events.aspx">View Events</a>
            </div>
        </div>
    </section>

    <section class="what-next" aria-labelledby="whats-next-title">
        <div class="section-heading">
            <h2 id="whats-next-title">What's Next</h2>
        </div>
        <div class="what-next-marquee" aria-label="Upcoming events">
            <div class="what-next-track">
                <div class="what-next-item">KBEC NEXUS S3</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item">CASE CRACK 3.0</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item">TEDX KUET 2026</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item" aria-hidden="true">KBEC NEXUS S3</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item" aria-hidden="true">CASE CRACK 3.0</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item" aria-hidden="true">TEDX KUET 2026</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
            </div>
        </div>
    </section>

    <section class="about-section" id="about">
        <div class="about-inner">

            <div class="about-left">
                <h2>About <span>Us</span></h2>
                <p>
                    KBEC, the premier business and entrepreneurship club of Khulna University of
                    Engineering &amp; Technology, founded in 2019, bridges engineering excellence
                    with entrepreneurial vision. Through KBEC Nexus, Entrepreneurial Voice, Case Crack,
                    workshops, seminars, startup programs, and TEDxKUET, it empowers students from
                    idea to launch, fostering leadership, innovation, and real-world impact.
                </p>
                <div class="about-founded">
                    <div class="about-founded-dot"></div>
                    Est. 2019 &nbsp;&#183;&nbsp; KUET, Khulna
                </div>

                <div class="about-stats" style="margin-top:28px;">
                    <div class="about-stat">
                        <strong>6+</strong>
                        <span>Years Active</span>
                    </div>
                    <div class="about-stat">
                        <strong>500+</strong>
                        <span>Members</span>
                    </div>
                    <div class="about-stat">
                        <strong>20+</strong>
                        <span>Events Hosted</span>
                    </div>
                </div>
            </div>

            <div class="about-right">
                <div class="about-card">
                    <div class="about-card-icon">&#127919;</div>
                    <h3>Our Vision</h3>
                    <p>To become the leading hub for cultivating leadership, innovation and professional excellence, empowering students to thrive both nationally and globally.</p>
                </div>
                <div class="about-card">
                    <div class="about-card-icon">&#128161;</div>
                    <h3>Our Mission</h3>
                    <p>To bridge engineering excellence with entrepreneurial vision by providing platforms, mentorship, and real-world opportunities that transform ideas into impactful ventures.</p>
                </div>
                <div class="about-card">
                    <div class="about-card-icon">&#127775;</div>
                    <h3>What We Do</h3>
                    <p>KBEC Nexus, Entrepreneurial Voice, Case Crack, workshops, seminars, startup programs, and TEDxKUET — events that take students from idea to launch.</p>
                </div>
            </div>

        </div>
    </section>

    <section class="sponsors">
        <h2>Our Sponsors</h2>
        <div class="sponsor-marquee">
            <div class="sponsor-logos" id="sponsorLogos" runat="server" aria-label="Sponsor logos"></div>
        </div>
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
            <a href="admin-login.aspx" style="color:#222;font-size:0.7rem;margin-left:20px;">Admin</a>
        </div>
    </footer>

    <script src="kbec.js"></script>
    <script>
        function scrollToAbout() {
            document.getElementById('about').scrollIntoView({ behavior: 'smooth' });
        }

        function toggleNotif() {
            var dropdown = document.getElementById('notifDropdown');
            dropdown.hidden = !dropdown.hidden;
        }
        document.addEventListener('click', function (e) {
            var dropdown = document.getElementById('notifDropdown');
            var btn = document.getElementById('notifBtn');
            if (dropdown && !dropdown.hidden && btn && !dropdown.contains(e.target) && e.target !== btn)
                dropdown.hidden = true;
        });
    </script>
</body>
</html>