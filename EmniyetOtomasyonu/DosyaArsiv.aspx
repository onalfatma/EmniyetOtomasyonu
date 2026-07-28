<%@ Page Title="Raporlar ve Arşiv" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DosyaArsiv.aspx.cs" Inherits="EmniyetOtomasyonu.DosyaArsiv" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* KAĞIT TASARIMI (A4 SİMÜLASYONU) */
        .paper-container {
            background-color: #525659; /* Koyu Gri Arka Plan */
            padding: 30px;
            border-radius: 8px;
            overflow-x: auto;
        }

        .paper {
            background: white;
            width: 210mm; /* A4 Genişliği */
            min-height: 297mm; /* A4 Yüksekliği */
            margin: 0 auto;
            padding: 20mm;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
            position: relative;
            font-family: 'Times New Roman', Times, serif;
            color: #000;
        }

        /* FİLİGRAN (GİZLİ DAMGASI) */
        .watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 80px;
            color: rgba(255, 0, 0, 0.08);
            font-weight: bold;
            border: 5px solid rgba(255, 0, 0, 0.08);
            padding: 10px 40px;
            text-transform: uppercase;
            pointer-events: none;
            z-index: 0;
            white-space: nowrap;
        }

        /* KAĞIT BAŞLIĞI */
        .paper-header {
            text-align: center;
            border-bottom: 2px solid #000;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .paper-header h2 { font-size: 16pt; font-weight: bold; margin: 0; text-transform: uppercase; }
        .paper-header h3 { font-size: 12pt; font-weight: normal; margin: 5px 0 0 0; }
        
        .report-meta {
            margin-top: 15px;
            font-size: 10pt;
            display: flex;
            justify-content: space-between;
        }

        /* TABLO TASARIMI */
        .official-table { width: 100%; border-collapse: collapse; font-size: 10pt; position: relative; z-index: 1; }
        .official-table th, .official-table td { border: 1px solid #000; padding: 6px 8px; text-align: left; }
        .official-table th { background-color: #f0f0f0; font-weight: bold; text-align: center; }

        /* İMZA BLOĞU */
        .signature-block { margin-top: 60px; display: flex; justify-content: space-between; page-break-inside: avoid; }
        .signature-box { text-align: center; width: 200px; }
        .signature-title { font-weight: bold; font-size: 11pt; margin-top: 5px; }

        /* YAZDIRMA AYARLARI */
        @media print {
            body * { visibility: hidden; }
            .paper, .paper * { visibility: visible; }
            .paper { 
                position: absolute; left: 0; top: 0; width: 100%; margin: 0; padding: 0; 
                box-shadow: none; background: none; 
            }
            .paper-container { background: none; padding: 0; }
            .no-print { display: none !important; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-4">
        
        <div class="row">
            <div class="col-md-3 no-print">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-dark text-white fw-bold">
                        <i class="fas fa-print me-2"></i>Rapor Merkezi
                    </div>
                    <div class="card-body bg-light">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-muted">RAPOR TÜRÜ</label>
                            <asp:DropDownList ID="ddlRaporTuru" runat="server" CssClass="form-select shadow-sm">
                                <asp:ListItem Value="Genel" Selected="True">📄 Genel Asayiş Özeti</asp:ListItem>
                                <asp:ListItem Value="Arsiv">🗄️ Kapanmış Dosya Arşivi</asp:ListItem>
                                <asp:ListItem Value="Kritik">🚨 Kritik / Acil Dosyalar</asp:ListItem>
                                <asp:ListItem Value="Personel">👮 Personel Görev Dağılımı</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small text-muted">BAŞLANGIÇ TARİHİ</label>
                            <asp:TextBox ID="txtTarihBas" runat="server" TextMode="Date" CssClass="form-control shadow-sm"></asp:TextBox>
                        </div>

                        <hr class="text-muted" />

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnOlustur" runat="server" Text="RAPORU HAZIRLA" CssClass="btn btn-primary fw-bold shadow" OnClick="btnOlustur_Click" />
                            <button type="button" class="btn btn-secondary" onclick="window.print()">
                                <i class="fas fa-print me-2"></i>YAZDIR
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="paper-container">
                    <div class="paper">
                        
                        <div class="watermark">GİZLİ / HİZMETE ÖZEL</div>

                        <div class="paper-header">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/2/25/Emniyet_Genel_M%C3%BCd%C3%BCrl%C3%BC%C4%9F%C3%BC_logosu.png" alt="EGM" style="width: 70px;" />
                            <h2 class="mt-2">T.C. İÇİŞLERİ BAKANLIĞI</h2>
                            <h3>Emniyet Genel Müdürlüğü<br />Personel Daire Başkanlığı</h3>
                        </div>

                        <div class="report-meta border-bottom pb-2 mb-4">
                            <div>
                                <strong>KONU:</strong> <asp:Label ID="lblRaporBaslik" runat="server" Text="GENEL DURUM RAPORU"></asp:Label><br />
                                <strong>BİRİM:</strong> Asayiş Şube Müdürlüğü
                            </div>
                            <div class="text-end">
                                <strong>TARİH:</strong> <asp:Label ID="lblTarih" runat="server"></asp:Label><br />
                                <strong>SAYI:</strong> <asp:Label ID="lblEvrakNo" runat="server"></asp:Label>
                            </div>
                        </div>

                        <asp:GridView ID="gvRapor" runat="server" CssClass="official-table" AutoGenerateColumns="true" GridLines="None" EmptyDataText="Kriterlere uygun kayıt bulunamadı.">
                        </asp:GridView>

                        <div class="mt-3 text-end small">
                            <em>Toplam Kayıt Sayısı: <asp:Label ID="lblKayitSayisi" runat="server" Text="0"></asp:Label></em>
                        </div>

                        <div class="signature-block">
                            <div class="signature-box">
                                <p>Düzenleyen</p>
                                <br /><br />
                                ......................................<br />
                                <span class="signature-title">Polis Memuru</span>
                            </div>
                            <div class="signature-box">
                                <p>Onaylayan</p>
                                <br /><br />
                                ......................................<br />
                                <span class="signature-title">İl Emniyet Müdürü</span>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>