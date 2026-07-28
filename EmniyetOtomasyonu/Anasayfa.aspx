<%@ Page Title="Komuta Merkezi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AnaKumanda.aspx.cs" Inherits="EmniyetOtomasyonu.AnaKumanda" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Kart Tasarımları */
        .kpi-card { 
            border: none; border-radius: 12px; color: white; position: relative; overflow: hidden; 
            transition: all 0.3s ease; text-decoration: none; display: block;
        }
        .kpi-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.2); filter: brightness(1.1); color: white; }
        
        .kpi-icon { position: absolute; right: 15px; bottom: 15px; font-size: 3.5rem; opacity: 0.15; }
        .kpi-num { font-size: 2.5rem; font-weight: 800; line-height: 1; margin-bottom: 5px; }
        .kpi-title { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9; font-weight: 600; }
        .kpi-trend { font-size: 0.75rem; background: rgba(255,255,255,0.2); padding: 3px 8px; border-radius: 10px; margin-top: 5px; display: inline-block; }

        /* Renkler */
        .bg-gradient-primary { background: linear-gradient(135deg, #1a237e 0%, #283593 100%); }
        .bg-gradient-danger { background: linear-gradient(135deg, #b71c1c 0%, #d32f2f 100%); }
        .bg-gradient-warning { background: linear-gradient(135deg, #f57f17 0%, #fbc02d 100%); color: #333 !important; }
        .bg-gradient-success { background: linear-gradient(135deg, #1b5e20 0%, #2e7d32 100%); }

        /* Grafik Kutusu ve Kafes */
        .chart-container { 
            background: white; border-radius: 12px; padding: 20px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #eee; 
            height: auto; 
        }
        .canvas-box { position: relative; height: 300px; width: 100%; }

        .system-note { font-size: 0.85rem; color: #6c757d; font-style: italic; border-left: 3px solid #1a237e; padding-left: 10px; margin-bottom: 20px; }

        /* YAZDIRMA AYARLARI (Yazıcıda butonlar gizlenir) */
        @media print {
            .btn, .navbar, .sidebar, footer { display: none !important; } 
            .card, .chart-container { border: 1px solid #000; box-shadow: none; break-inside: avoid; }
            body { background: white; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-4">
        
        <div class="d-flex justify-content-between align-items-end mb-3">
            <div>
                <h2 class="fw-bold text-dark mb-1"><i class="fas fa-layer-group text-primary me-2"></i>Komuta ve Kontrol Merkezi</h2>
                <div class="system-note">
                    "Bu panel, olay kayıtlarını analiz ederek operasyonel kararları desteklemek amacıyla tasarlanmıştır."
                </div>
            </div>
            
            <div class="bg-white p-2 rounded shadow-sm border d-flex align-items-center">
                <button type="button" class="btn btn-sm btn-outline-secondary me-3" onclick="window.print()">
                    <i class="fas fa-print me-1"></i>Yazdır
                </button>
                
                <i class="fas fa-filter text-muted me-2"></i>
                <asp:DropDownList ID="ddlZaman" runat="server" CssClass="form-select form-select-sm border-0 fw-bold text-primary" AutoPostBack="true" OnSelectedIndexChanged="ddlZaman_SelectedIndexChanged">
                    <asp:ListItem Text="Tüm Zamanlar" Value="ALL"></asp:ListItem>
                    <asp:ListItem Text="Son 30 Gün" Value="30"></asp:ListItem>
                    <asp:ListItem Text="Son 7 Gün" Value="7"></asp:ListItem>
                    <asp:ListItem Text="Bugün" Value="1"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <a href="OlayKayitlari.aspx" class="card kpi-card bg-gradient-primary p-3 shadow-sm">
                    <div class="kpi-title">Toplam Vaka</div>
                    <div class="kpi-num"><asp:Label ID="lblToplamVaka" runat="server" Text="0"></asp:Label></div>
                    <div class="kpi-trend"><i class="fas fa-arrow-up me-1"></i>Bu hafta: <asp:Label ID="lblTrendToplam" runat="server"></asp:Label></div>
                    <i class="fas fa-folder kpi-icon"></i>
                </a>
            </div>
            <div class="col-md-3">
                <a href="OlayKayitlari.aspx?filtre=Kritik" class="card kpi-card bg-gradient-danger p-3 shadow-sm">
                    <div class="kpi-title">Kritik & Açık Olay</div>
                    <div class="kpi-num"><asp:Label ID="lblKritikVaka" runat="server" Text="0"></asp:Label></div>
                    <div class="kpi-trend">Acil Müdahale Gerekli</div>
                    <i class="fas fa-exclamation-circle kpi-icon"></i>
                </a>
            </div>
            <div class="col-md-3">
                <a href="SucluListesi.aspx" class="card kpi-card bg-gradient-warning p-3 shadow-sm">
                    <div class="kpi-title">Takipteki Şüpheli</div>
                    <div class="kpi-num"><asp:Label ID="lblSuclu" runat="server" Text="0"></asp:Label></div>
                    <div class="kpi-trend">Arşiv Kaydı</div>
                    <i class="fas fa-user-secret kpi-icon"></i>
                </a>
            </div>
            <div class="col-md-3">
                <a href="OlayKayitlari.aspx?filtre=Cozuldu" class="card kpi-card bg-gradient-success p-3 shadow-sm">
                    <div class="kpi-title">Başarı / Çözülen</div>
                    <div class="kpi-num"><asp:Label ID="lblCozulen" runat="server" Text="0"></asp:Label></div>
                    <div class="kpi-trend"><i class="fas fa-check me-1"></i>Sonuçlandı</div>
                    <i class="fas fa-clipboard-check kpi-icon"></i>
                </a>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="chart-container">
                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">
                        <i class="fas fa-chart-pie me-2 text-primary"></i>Suç Türü Dağılımı (Analiz)
                    </h6>
                    <div class="canvas-box">
                        <canvas id="chartSucTuru"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="chart-container">
                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">
                        <i class="fas fa-city me-2 text-primary"></i>Bölgesel Suç Yoğunluğu (Top 5)
                    </h6>
                    <div class="canvas-box">
                        <canvas id="chartSehirler"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 border-bottom">
                <div class="d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold text-primary mb-0"><i class="fas fa-bolt me-2"></i>SON VAKA HAREKETLERİ (CANLI AKIŞ)</h6>
                    <a href="OlayKayitlari.aspx" class="btn btn-sm btn-outline-primary">Tümünü Gör</a>
                </div>
            </div>
            <div class="card-body p-0">
                <asp:GridView ID="gridSonOlaylar" runat="server" CssClass="table table-hover align-middle mb-0" AutoGenerateColumns="false" GridLines="None">
                    <HeaderStyle CssClass="bg-light text-muted small fw-bold text-uppercase" />
                    <Columns>
                        <asp:BoundField DataField="DosyaNo" HeaderText="DOSYA NO" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="OlayTarihi" HeaderText="TARİH" DataFormatString="{0:dd.MM.yyyy}" />
                        
                        <asp:TemplateField HeaderText="ÖNCELİK">
                            <ItemTemplate>
                                <span class='badge <%# Eval("Oncelik").ToString() == "Kritik" ? "bg-danger" : (Eval("Oncelik").ToString() == "Önemli" ? "bg-warning text-dark" : "bg-light text-dark border") %>'>
                                    <%# Eval("Oncelik") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="SucAdi" HeaderText="SUÇ TÜRÜ" />
                        <asp:BoundField DataField="SehirAdi" HeaderText="BÖLGE" />

                        <asp:TemplateField HeaderText="DURUM">
                            <ItemTemplate>
                                <span class='badge rounded-pill <%# Eval("SonDurum").ToString() == "Açık" ? "bg-danger" : "bg-success" %>'>
                                    <%# Eval("SonDurum") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="AKSİYON">
                            <ItemTemplate>
                                <a href='OlayEkle.aspx?id=<%# Eval("OlayID") %>' class="btn btn-sm btn-outline-dark" title="Detay İncele">
                                    <i class="fas fa-search"></i> İncele
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <script>
        const sucEtiketleri = [<%= strSucEtiketleri %>];
        const sucVerileri = [<%= strSucVerileri %>];
        const sehirEtiketleri = [<%= strSehirEtiketleri %>];
        const sehirVerileri = [<%= strSehirVerileri %>];

        new Chart(document.getElementById('chartSucTuru'), {
            type: 'doughnut',
            data: {
                labels: sucEtiketleri,
                datasets: [{
                    data: sucVerileri,
                    backgroundColor: ['#b71c1c', '#1a237e', '#f9a825', '#2e7d32', '#455a64', '#0277bd'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'right' } }
            }
        });

        new Chart(document.getElementById('chartSehirler'), {
            type: 'bar',
            data: {
                labels: sehirEtiketleri,
                datasets: [{
                    label: 'Olay Sayısı',
                    data: sehirVerileri,
                    backgroundColor: '#1a237e',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });
    </script>
</asp:Content>