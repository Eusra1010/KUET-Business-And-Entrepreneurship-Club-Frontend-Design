<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBEC Events</title>
    <link rel="stylesheet" href="kbec.css">
    <style>
        .events-page {
            padding-top: 120px;
            text-align: center;
        }

        .events-page-header {
            display: flex;
            justify-content: flex-start;
            max-width: 1200px;
            margin: 0 auto 24px;
            padding: 0 20px;
        }

        .events-grid {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 40px;
        }

        .event-item {
            width: 280px;
            background: #111;
            border-radius: 12px;
            overflow: hidden;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            color: white;
        }

        .event-item:hover {
            transform: translateY(-10px);
            box-shadow: 0 0 15px #f5c51844;
        }

        .event-item img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .event-item h3 {
            padding: 15px;
        }
    </style>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Events WHERE IsActive=1 ORDER BY CreatedAt DESC", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            while (reader.Read())
            {
                sb.Append("<a href='event-details.aspx?event=" + reader["EventKey"].ToString() + "' class='event-item'>");
                sb.Append("<img src='" + reader["ImagePath"].ToString() + "' alt='" + reader["Title"].ToString() + "' />");
                sb.Append("<h3>" + reader["Title"].ToString() + "</h3>");
                sb.Append("</a>");
            }
            reader.Close();

            if (sb.Length == 0)
                sb.Append("<p style='color:#666;'>No events available right now. Check back soon!</p>");

            eventsGrid.InnerHtml = sb.ToString();
        }
    }
</script>
</head>

<body>

    <section class="events-page">
        <div class="events-page-header">
            <a href="kbec.aspx" class="back-home-btn">&#8592; Back</a>
        </div>

        <h1>Our Events</h1>

        <div class="events-grid" id="eventsGrid" runat="server"></div>
    </section>

</body>
</html>