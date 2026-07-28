<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EmniyetOtomasyonu.Login" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8">
    <title>Emniyet Genel Müdürlüğü - Personel Giriş</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

    <style>
        /* GENEL SAYFA (Arka Plan) */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center; /* Yatay Ortala */
            align-items: center;     /* Dikey Ortala */
            /* Arka Plan: Derin Devlet Laciverti */
            background: radial-gradient(circle at center, #1e3c72, #2a5298, #000000);
            overflow: hidden;
        }

        /* GİRİŞ KARTI */
        .login-card {
            background: #ffffff;
            width: 380px;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5); /* Derin Gölge */
            
            /* SİREN DETAYI (Üst Kırmızı, Alt Mavi Çizgi) */
            border-top: 5px solid #b71c1c; 
            border-bottom: 5px solid #1a237e; 
            
            text-align: center;
            position: relative;
            animation: slideIn 0.8s ease-out; /* Açılış Animasyonu */
        }

        /* Sayfa açılınca kutunun süzülerek gelmesi */
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* LOGO VE BAŞLIKLAR */
        .logo-img {
            width: 110px;
            margin-bottom: 15px;
        }

        .title {
            color: #1a237e; /* Resmi Lacivert */
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .subtitle {
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
            font-weight: 400;
        }

        /* GİRİŞ KUTULARI (Inputlar) */
        .input-group {
            position: relative;
            margin-bottom: 20px;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            top: 14px;
            color: #1a237e; /* İkon Rengi */
            font-size: 18px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px 12px 45px; /* İkon için soldan boşluk */
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 15px;
            outline: none;
            box-sizing: border-box; /* Kutunun taşmasını engeller */
            transition: 0.3s;
        }

        /* Kutuya tıklayınca kenarı parlasın */
        .form-control:focus {
            border-color: #1a237e;
            box-shadow: 0 0 8px rgba(26, 35, 126, 0.2);
        }

        /* GİRİŞ BUTONU */
        .btn-giris {
            width: 100%;
            padding: 14px;
            /* Buton Rengi: Soldan sağa lacivert geçiş */
            background: linear-gradient(90deg, #1a237e, #283593); 
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.3s;
            box-shadow: 0 5px 15px rgba(26, 35, 126, 0.3);
        }

        .btn-giris:hover {
            transform: translateY(-2px); /* Üzerine gelince hafif zıplar */
            box-shadow: 0 8px 20px rgba(26, 35, 126, 0.4);
        }

        /* ALT BİLGİ VE HATA MESAJI */
        .footer {
            margin-top: 25px;
            font-size: 11px;
            color: #999;
            line-height: 1.5;
        }

        .error-msg {
            color: #d32f2f; /* Hata Kırmızısı */
            font-weight: bold;
            font-size: 13px;
            margin-top: 15px;
            display: block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            
          <img src="Resimler/logo-emniyet-genel-mudurluu.png" alt="EGM Logo" class="logo-img" />

            <div class="title">Emniyet Genel Müdürlüğü</div>
            <div class="subtitle">Personel Bilgi Sistemi Girişi</div>

            <div class="input-group">
                <i class="fas fa-id-card"></i> <asp:TextBox ID="txtKullanici" runat="server" CssClass="form-control" placeholder="Sicil No / Kullanıcı Adı"></asp:TextBox>
            </div>

            <div class="input-group">
                <i class="fas fa-lock"></i> <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control" TextMode="Password" placeholder="Parola"></asp:TextBox>
            </div>

            <asp:Button ID="btnGiris" runat="server" Text="Sisteme Giriş Yap" CssClass="btn-giris" OnClick="btnGiris_Click" />

            <asp:Label ID="lblMesaj" runat="server" CssClass="error-msg"></asp:Label>

            <div class="footer">
                © 2026 T.C. İçişleri Bakanlığı<br />
                Bu sisteme yetkisiz giriş yapmaya çalışmak yasal suçtur<br />ve IP adresiniz kayıt altına alınmaktadır.
            </div>
        </div>
    </form>
</body>
</html>