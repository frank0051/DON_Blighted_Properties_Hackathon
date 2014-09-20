using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Text;
using System.IO;

/// <summary>
/// REZA H. TESHNIZI
/// r.teshnizi@cse.tamu.edu
/// Summary description for GetHData
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class GetHData : System.Web.Services.WebService
{

    string ProjectActionsTable = ConfigurationManager.AppSettings["ProjectActionsTable"];
    string ProjectsTable = ConfigurationManager.AppSettings["ProjectsTable"];
    string LatLonTable = ConfigurationManager.AppSettings["LatLonTable"];
    string ViolationTable = ConfigurationManager.AppSettings["ViolationTable"];
    public GetHData()
    {
    }

    [WebMethod]
    public string[] GetRecords(string jsonobj)
    {
        string[] results = new string[2];
        results[0] = "1";
        string connection = System.Configuration.ConfigurationManager.AppSettings["ConnectionString"];
        Query query = JsonConvert.DeserializeObject<Query>(jsonobj);
        
        SqlConnection conn = new SqlConnection(connection);
        if (query.isEmptyQuery())
            throw new Exception("Empty Query");
        string sql = "SELECT [HCAD], [Merged_Situs], [ZipCode], [Latitude], [Longitude] FROM " + ProjectsTable + " WHERE " + query.Where.ToString() + " GROUP BY [HCAD], [Merged_Situs], [ZipCode], [Latitude], [Longitude]";
        try
        {
            conn.Open();
            if (conn.State == System.Data.ConnectionState.Open)
            {
                // Execute the command
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
                if (reader.RecordsAffected < 0 && reader.HasRows) // the SELECT statement has returned a record, then it might be an updated record. So we have to check the TimeStamp.
                {
                    while (reader.Read())
                    {
                        Dictionary<string, string> atts = new Dictionary<string, string>(reader.FieldCount);
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            atts.Add(reader.GetName(i), reader.GetValue(i).ToString());
                        }
                        rows.Add(atts);
                    }
                }
                results[1] = JsonConvert.SerializeObject(Clustering(rows, query));
            }
            else
            {
                results[0] = "0";
                results[1] = "Connection to SQL DB filed.";
            }
        }
        catch (SqlException ex) { results[0] = "0"; results[1] = "SQL exception: " + ex.Message; }
        return results;
    }

    public List<ClusterPoint> Clustering(List<Dictionary<string, string>> rows, Query query)
    {
        double dist = GetDistance(new LatLon(query.NELat, query.NELon), new LatLon(query.SWLat, query.NELon)) / 6; // in meters
        List<ClusterPoint> clusters = new List<ClusterPoint>();
        foreach (Dictionary<string, string> project in rows)
        {
            LatLon point = new LatLon(double.Parse(project["Latitude"]), double.Parse(project["Longitude"]));
            Project proj = new Project(project["HCAD"], point, project["Merged_Situs"], project["ZipCode"]);
            bool hasCluster = false;
            foreach (ClusterPoint cluster in clusters)
            {
                if (cluster.Projects.Count < 6000)
                {
                    if (GetDistance(cluster.Centroid, point) < dist)
                    {
                        cluster.AddPoint(proj);
                        hasCluster = true;
                        break;
                    }
                }
            }
            if (!hasCluster)
            {
                clusters.Add(new ClusterPoint(proj));
            }
        }
        return clusters;
    }

    [WebMethod]
    public string[] GetViolations(string jsonobj)
    {
        string[] results = new string[2];
        results[0] = "1";
        string connection = System.Configuration.ConfigurationManager.AppSettings["ConnectionString"];
        Query query = JsonConvert.DeserializeObject<Query>(jsonobj);

        SqlConnection conn = new SqlConnection(connection);
        if (query.isEmptyQuery())
            throw new Exception("Empty Query");
        string sql = "SELECT projects.[NPPRJId], projects.[Merged_Situs], projects.ZipCode, Latitude, Longitude, projects.RecordCreateDate, projects.[Subdivision], projects.[Council District], projects.Received_Method, projects.[Sr_Request_Num], projects.Project_Status ,Violation_Category,Ordno,ShortDes,DeadLineDate,CheckBackDate FROM projects LEFT JOIN [dbo].[violations] on projects.NPPRJId=violations.NPPRJId WHERE projects.HCAD = '" + query.HCAD + "' ORDER BY RecordCreateDate DESC";

        try
        {
            conn.Open();
            if (conn.State == System.Data.ConnectionState.Open)
            {
                // Execute the command
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
                if (reader.RecordsAffected < 0 && reader.HasRows) // the SELECT statement has returned a record, then it might be an updated record. So we have to check the TimeStamp.
                {
                    while (reader.Read())
                    {
                        Dictionary<string, string> atts = new Dictionary<string, string>(reader.FieldCount);
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            atts.Add(reader.GetName(i), reader.GetValue(i).ToString());
                        }
                        rows.Add(atts);
                    }
                }
                results[1] = JsonConvert.SerializeObject(rows);
            }
            else
            {
                results[0] = "0";
                results[1] = "Connection to SQL DB filed.";
            }
        }
        catch (SqlException ex) { results[0] = "0"; results[1] = "SQL exception: " + ex.Message; }
        return results;
    }

    [WebMethod]
    public string[] GetActions(string jsonobj)
    {
        string[] results = new string[2];
        results[0] = "1";
        string connection = System.Configuration.ConfigurationManager.AppSettings["ConnectionString"];
        Query query = JsonConvert.DeserializeObject<Query>(jsonobj);

        SqlConnection conn = new SqlConnection(connection);
        if (query.isEmptyQuery())
            throw new Exception("Empty Query");
        //string cleanUp = "WITH LATLON AS (SELECT [NPPRJId] ,[HCAD] ,iif(ISNUMERIC(latitude)=1,CAST([latitude] as decimal(9,6)),NULL) as Lat ,iif(ISNUMERIC(Longitude)=1,CAST(Longitude as decimal(9,6)),NULL) as Lon FROM [" + LatLonTable + "])";
        string sql = "SELECT projects.[NPPRJId], [Action_Type], [Date], [Action], [Comments] FROM projects LEFT JOIN [dbo].actions on projects.NPPRJId=actions.NPPRJId WHERE projects.HCAD = '" + query.HCAD + "' ORDER BY NPPRJId,Date";

        try
        {
            conn.Open();
            if (conn.State == System.Data.ConnectionState.Open)
            {
                // Execute the command
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
                if (reader.RecordsAffected < 0 && reader.HasRows) // the SELECT statement has returned a record, then it might be an updated record. So we have to check the TimeStamp.
                {
                    while (reader.Read())
                    {
                        Dictionary<string, string> atts = new Dictionary<string, string>(reader.FieldCount);
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            atts.Add(reader.GetName(i), reader.GetValue(i).ToString());
                        }
                        rows.Add(atts);
                    }
                }
                results[1] = JsonConvert.SerializeObject(rows);
            }
            else
            {
                results[0] = "0";
                results[1] = "Connection to SQL DB filed.";
            }
        }
        catch (SqlException ex) { results[0] = "0"; results[1] = "SQL exception: " + ex.Message; }
        return results;
    }

    [WebMethod]
    public string[] GetStatusList()
    {
        string[] results = new string[2];
        results[0] = "1";
        string connection = System.Configuration.ConfigurationManager.AppSettings["ConnectionString"];
        SqlConnection conn = new SqlConnection(connection);
        string sql = "SELECT DISTINCT [Project_Status] FROM " + ProjectsTable + " order by [Project_Status]";
        try
        {
            conn.Open();
            if (conn.State == System.Data.ConnectionState.Open)
            {
                // Execute the command
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
                if (reader.RecordsAffected < 0 && reader.HasRows) // the SELECT statement has returned a record, then it might be an updated record. So we have to check the TimeStamp.
                {
                    while (reader.Read())
                    {
                        Dictionary<string, string> atts = new Dictionary<string, string>(reader.FieldCount);
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            atts.Add(reader.GetName(i), reader.GetValue(i).ToString());
                        }
                        rows.Add(atts);
                    }
                }
                results[1] = JsonConvert.SerializeObject(rows);
            }
            else
            {
                results[0] = "0";
                results[1] = "Connection to SQL DB filed.";
            }
        }
        catch (SqlException ex) { results[0] = "0"; results[1] = "SQL exception: " + ex.Message; }
        return results;
    }


/*    [WebMethod]
        public string[] ReadTestLatLons(string jsonobj)
        {
            string[] results = new string[2];
            results[0] = "1";
            Query query = JsonConvert.DeserializeObject<Query>(jsonobj);
            double dist = GetDistance(new LatLon(query.NELat, query.NELon), new LatLon(query.SWLat, query.NELon)) / 6; // in meters
            string inpath = @"C:\Elvis\PhD\Research\Programming\Houston\Houston_Ca.txt";
            StreamReader sr = null;
            List<ClusterPoint> clusters = new List<ClusterPoint>();
            sr = new StreamReader(inpath);
            sr = File.OpenText(inpath);
            string line = sr.ReadLine();
            int count = 0;
            while (line != null)
            {
                string[] latlon = line.Split('\t');
                LatLon point = new LatLon(double.Parse(latlon[0]), double.Parse(latlon[1]));
                Project proj = new Project(query.HCAD, point);
                bool hasCluster = false;
                foreach (ClusterPoint cluster in clusters)
                {
                    if (GetDistance(cluster.Centroid, point) < dist)
                    {
                        cluster.AddPoint(proj);
                        hasCluster = true;
                        break;
                    }
                }
                if (!hasCluster)
                {
                    clusters.Add(new ClusterPoint(proj));
                }
                line = sr.ReadLine();
                count++;
            }
            results[1] = JsonConvert.SerializeObject(clusters);
            sr.Close();
            return results;
        }*/

    private double GetDistance(LatLon p1, LatLon p2)
    {
        var R = 6378137; // Earth’s mean radius in meter
        var dLat = (p2.Lat - p1.Lat) * Math.PI / 180;
        var dLong = (p2.Lon - p1.Lon) * Math.PI / 180;
        var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) + Math.Cos((p1.Lat) * Math.PI / 180) * Math.Cos((p2.Lat) * Math.PI / 180) * Math.Sin(dLong / 2) * Math.Sin(dLong / 2);
        var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
        var d = R * c;
        return d; // returns the distance in meter
    }
}

public class Query
{
    public string HCAD { get; set; }
    public string Status { get; set; }
    public string CouncilDistrict { get; set; }
    public string SRNumber { get; set; }
    public double NELat { get; set; }
    public double NELon { get; set; }
    public double SWLat { get; set; }
    public double SWLon { get; set; }
    public StringBuilder WhereBounds { get; private set; }
    public StringBuilder Where { get; private set; }
    private bool queryHasBeenBuilt = false;

    public bool isEmptyQuery()
    {
        if (!queryHasBeenBuilt)
            this.BuildQueryString();
        if (Where.ToString() == "")
            return true;
        return false;
    }

    public string BuildQueryString()
    {
        if (Where == null)
        {
            WhereBounds = new StringBuilder();
            Where = new StringBuilder();
        }
        WhereBounds = this.GetLatLonBounds(Where);
        Where = this.GetHCAD(Where);
        Where = this.GetStatus(Where);
        Where = this.GetCouncil(Where);
        Where = this.GetSRNumber(Where);
        queryHasBeenBuilt = true;
        return Where.ToString();
    }

    private StringBuilder GetLatLonBounds(StringBuilder where)
    {
        if (where.Length > 0 && this.NELat != null && this.NELon != null && this.SWLat != null && this.SWLon != null)
            where.Append(" AND ");
        if (this.NELat != null && this.NELon != null && this.SWLat != null && this.SWLon != null)
            where.Append(" Latitude < " + this.NELat + " AND Latitude > " + this.SWLat + " AND Longitude < " + NELon + " AND Longitude > " + SWLon);
        return where;
    }

    private StringBuilder GetHCAD(StringBuilder where)
    {
        if (this.HCAD != null && this.HCAD.Trim().Length > 1)
        {
            if (where.Length > 0)
                where.Append(" AND ");
            where.Append(" HCAD LIKE '" + this.HCAD.Trim() + "'");
        }
        /*else
            where.Append(" HCAD IS NOT NULL");*/ //Commented to improve SQL efficiency
        return where;
    }

    private StringBuilder GetSRNumber(StringBuilder where)
    {
        if (this.SRNumber != null && this.SRNumber.Trim().Length > 1)
        {
            if (where.Length > 0)
                where.Append(" AND ");
            where.Append(" [Sr_Request_Num] LIKE '" + this.SRNumber.Trim() + "'");
        }
        return where;
    }

    private StringBuilder GetStatus(StringBuilder where)
    {
        if (where.Length > 0)
            where.Append(" AND ");
        where.Append(" Project_Status IN (" + this.Status + ")");
        return where;
    }

    private StringBuilder GetCouncil(StringBuilder where)
    {

        if (this.CouncilDistrict==null || this.CouncilDistrict.Length <= 1)
            return where;

        //If call Council Districts are selected, don't append to query to 
        //conserve SQL processing time and to allow selection of null and dirty data
        if (this.CouncilDistrict == "'A','B','C','D','E','F','G','H','I','J','K'")
            return where; 

        if (where.Length > 0)
            where.Append(" AND ");
        where.Append(" [Council District] IN (" + this.CouncilDistrict + ")");
        return where;
    }
}

public class LatLon
{
    public double Lat { get; set; }
    public double Lon { get; set; }
    public LatLon(double lat, double lon)
    {
        Lat = lat;
        Lon = lon;
    }
}

public class Project
{
    public LatLon Location { get; set; }
    public string HCAD { get; set; }
    public string Address { get; set; }
    public string ZipCode { get; set; }
    public Project(string hcad, LatLon location, string address, string zip)
    {
        this.HCAD = hcad;
        this.Location = location;
        this.Address = address;
        this.ZipCode = zip;
    }
}

public class ClusterPoint
{
    public LatLon Centroid { get; set; }
    public List<Project> Projects = new List<Project>();

    public ClusterPoint(Project proj)
    {
        Centroid = proj.Location;
        Projects.Add(proj);
    }

    public void AddPoint(Project p)
    {
        if (Projects.Count == 0)
        {
            Projects.Add(p);
            Centroid = p.Location;
        }
        else
        {
            double sumLats = Centroid.Lat * Projects.Count;
            double sumLons = Centroid.Lon * Projects.Count;
            sumLats += p.Location.Lat;
            sumLons += p.Location.Lon;
            Projects.Add(p);
            Centroid.Lat = sumLats / Projects.Count;
            Centroid.Lon = sumLons / Projects.Count;
        }
    }
}