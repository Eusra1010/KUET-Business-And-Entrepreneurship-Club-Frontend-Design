<%@ Page Language="C#" ContentType="application/json" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (Session["AdminId"] == null)
        {
            Response.Write("{}");
            Response.End();
            return;
        }

        string id = Request.QueryString["id"];
        if (string.IsNullOrEmpty(id))
        {
            Response.Write("{}");
            Response.End();
            return;
        }

        string connStr = ConfigurationManager.ConnectionStrings["KBECConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Members WHERE Id=@Id", conn);
            cmd.Parameters.AddWithValue("@Id", id);
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                string name = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                string email = reader["Email"].ToString();
                string dept = reader["Department"].ToString();
                string batch = reader["Batch"].ToString();
                string cgpa = reader["CGPA"] == DBNull.Value ? "" : reader["CGPA"].ToString();
                string contact = reader["ContactNumber"] == DBNull.Value ? "" : reader["ContactNumber"].ToString();
                string about = reader["AboutYourself"] == DBNull.Value ? "" : reader["AboutYourself"].ToString();
                string pic = reader["ProfilePicturePath"] == DBNull.Value ? "images/members/default.jpg" : reader["ProfilePicturePath"].ToString();
                string status = reader["Status"].ToString();
                string date = Convert.ToDateTime(reader["CreatedAt"]).ToString("dd MMM yyyy");

                // Escape for JSON
                name = name.Replace("\\", "\\\\").Replace("\"", "\\\"");
                email = email.Replace("\"", "\\\"");
                dept = dept.Replace("\"", "\\\"");
                about = about.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "");

                Response.Write("{");
                Response.Write("\"id\":\"" + id + "\",");
                Response.Write("\"name\":\"" + name + "\",");
                Response.Write("\"email\":\"" + email + "\",");
                Response.Write("\"dept\":\"" + dept + "\",");
                Response.Write("\"batch\":\"" + batch + "\",");
                Response.Write("\"cgpa\":\"" + cgpa + "\",");
                Response.Write("\"contact\":\"" + contact + "\",");
                Response.Write("\"about\":\"" + about + "\",");
                Response.Write("\"pic\":\"" + pic + "\",");
                Response.Write("\"status\":\"" + status + "\",");
                Response.Write("\"date\":\"" + date + "\"");
                Response.Write("}");
            }
            else
            {
                Response.Write("{}");
            }
        }
        Response.End();
    }
</script>