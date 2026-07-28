using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EmniyetOtomasyonu
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. GÜVENLİK KONTROLÜ: Giriş yapılmış mı?
            if (Session["Kullanici"] == null)
            {
                // Giriş yapılmamışsa Login sayfasına at
                Response.Redirect("Login.aspx");
            }

            else
            {
                // 2. KULLANICI ADINI YAZ
                // Eğer sistemde bir hatadan dolayı Label'ı bulamazsa diye try-catch koydum
                try
                {
                    if (Session["AdSoyad"] != null)
                        lblKullanici.Text = Session["AdSoyad"].ToString();
                    else
                        lblKullanici.Text = Session["Kullanici"].ToString();
                }
                catch
                {
                    // Bir hata olursa boş geç, sistemi bozma
                }
            }
        }

        protected void btnCikis_Click(object sender, EventArgs e)
        {
            // GÜVENLİ ÇIKIŞ
            Session.Abandon();
            Session.Clear();
            Session.RemoveAll();
            Response.Redirect("Login.aspx");
        }
    }
}