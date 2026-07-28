using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;

namespace EmniyetOtomasyonu
{
    public partial class AnaKumanda : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        // Grafikler için değişkenler
        public string strSucEtiketleri = "";
        public string strSucVerileri = "";
        public string strSehirEtiketleri = "";
        public string strSehirVerileri = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerileriGetir();
            }
        }

        protected void ddlZaman_SelectedIndexChanged(object sender, EventArgs e)
        {
            VerileriGetir();
        }

        void VerileriGetir()
        {
            // --- FİLTRELEME MANTIĞI ---
            string tarihFiltresi = "";
            int gun = 0;

            if (ddlZaman.SelectedValue == "1") gun = 1;
            else if (ddlZaman.SelectedValue == "7") gun = 7;
            else if (ddlZaman.SelectedValue == "30") gun = 30;

            if (ddlZaman.SelectedValue != "ALL")
            {
                tarihFiltresi = $" AND O.OlayTarihi >= DATEADD(day, -{gun}, GETDATE())";
            }

            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                baglan.Open();

                // 1. KART VERİLERİ
                string sql1 = "SELECT COUNT(*) FROM OlayKaydi O WHERE 1=1 " + tarihFiltresi;
                SqlCommand cmd1 = new SqlCommand(sql1, baglan);
                lblToplamVaka.Text = cmd1.ExecuteScalar().ToString();

                string sqlTrend = "SELECT COUNT(*) FROM OlayKaydi WHERE OlayTarihi >= DATEADD(day, -7, GETDATE())";
                SqlCommand cmdTrend = new SqlCommand(sqlTrend, baglan);
                lblTrendToplam.Text = "+" + cmdTrend.ExecuteScalar().ToString();

                string sql2 = "SELECT COUNT(*) FROM OlayKaydi O WHERE O.SonDurum='Açık' AND (O.Oncelik='Kritik' OR O.Oncelik='Önemli') " + tarihFiltresi;
                SqlCommand cmd2 = new SqlCommand(sql2, baglan);
                lblKritikVaka.Text = cmd2.ExecuteScalar().ToString();

                SqlCommand cmd3 = new SqlCommand("SELECT COUNT(*) FROM Suclular", baglan);
                lblSuclu.Text = cmd3.ExecuteScalar().ToString();

                string sql4 = "SELECT COUNT(*) FROM OlayKaydi O WHERE (O.SonDurum='Sonuçlandı' OR O.SonDurum='Çözüldü') " + tarihFiltresi;
                SqlCommand cmd4 = new SqlCommand(sql4, baglan);
                lblCozulen.Text = cmd4.ExecuteScalar().ToString();


                // 2. GRAFİKLER
                string sqlChart1 = @"SELECT TOP 6 T.SucAdi, COUNT(O.OlayID) as Adet 
                                     FROM OlayKaydi O 
                                     JOIN SucTurleri T ON O.OlayTurID = T.SucTurID 
                                     WHERE 1=1 " + tarihFiltresi +
                                     " GROUP BY T.SucAdi ORDER BY Adet DESC";
                DoldurGrafikVerileri(sqlChart1, baglan, ref strSucEtiketleri, ref strSucVerileri, "SucAdi");

                string sqlChart2 = @"SELECT TOP 5 S.SehirAdi, COUNT(O.OlayID) as Adet 
                                     FROM OlayKaydi O 
                                     JOIN Sehirler S ON O.SehirID = S.SehirID 
                                     WHERE 1=1 " + tarihFiltresi +
                                     " GROUP BY S.SehirAdi ORDER BY Adet DESC";
                DoldurGrafikVerileri(sqlChart2, baglan, ref strSehirEtiketleri, ref strSehirVerileri, "SehirAdi");


                // 3. TABLO
                string sqlTablo = @"SELECT TOP 5 O.OlayID, O.DosyaNo, O.OlayTarihi, O.SonDurum, O.Oncelik,
                                    ISNULL(T.SucAdi, 'Diğer') as SucAdi, 
                                    ISNULL(S.SehirAdi, '-') as SehirAdi
                                    FROM OlayKaydi O
                                    LEFT JOIN SucTurleri T ON O.OlayTurID = T.SucTurID
                                    LEFT JOIN Sehirler S ON O.SehirID = S.SehirID
                                    WHERE 1=1 " + tarihFiltresi +
                                    " ORDER BY O.OlayTarihi DESC";

                SqlDataAdapter da = new SqlDataAdapter(sqlTablo, baglan);
                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gridSonOlaylar.DataSource = dt;
                    gridSonOlaylar.DataBind();
                }
                catch { }
            }
        }

        void DoldurGrafikVerileri(string sql, SqlConnection con, ref string etiketler, ref string veriler, string kolonAdi)
        {
            SqlCommand cmd = new SqlCommand(sql, con);
            SqlDataReader dr = cmd.ExecuteReader();
            StringBuilder sbEtiket = new StringBuilder();
            StringBuilder sbVeri = new StringBuilder();
            while (dr.Read())
            {
                sbEtiket.Append("'" + dr[kolonAdi].ToString() + "',");
                sbVeri.Append(dr["Adet"].ToString() + ",");
            }
            dr.Close();
            etiketler = sbEtiket.ToString().TrimEnd(',');
            veriler = sbVeri.ToString().TrimEnd(',');
        }
    }
}