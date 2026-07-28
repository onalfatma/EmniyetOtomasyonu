<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SucluListesi.aspx.cs" Inherits="EmniyetOtomasyonu.SucluListesi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* GENEL TASARIM */
        .page-header-title { font-weight: 800; color: #222; text-transform: uppercase; letter-spacing: 0.5px; margin: 0; }
        .page-sub-title { color: #666; font-size: 0.9rem; }
        .panel-heading { text-align: center; font-weight: 700; color: #333; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 15px; font-size: 1.6rem; }
        
        /* ARAMA KUTUSU */
        .search-wrapper { max-width: 850px; margin: 0 auto; }
        .form-control-lg { padding: 15px 20px; font-size: 1.1rem; border: 1px solid #ccc; border-right: none; border-radius: 5px 0 0 5px; }
        .btn-sorgula { background-color: #dc3545; color: white; font-weight: bold; font-size: 1.1rem; padding: 0 40px; border-radius: 0 5px 5px 0; text-transform: uppercase; }
        .btn-sorgula:hover { background-color: #c82333; color: white; }

        /* YANIP SÖNEN BADGE */
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.4; } 100% { opacity: 1; } }
        .blink-badge { animation: pulse 1s infinite; font-size: 0.75rem; padding: 5px 8px; }

        /* TABLO */
        .custom-table th { background: #f8f9fa; color: #333; font-weight: bold; text-transform: uppercase; font-size: 0.8rem; padding: 15px; border-bottom: 2px solid #ddd; }
        .custom-table td { padding: 12px 15px; vertical-align: middle; }
        .red-border-left { border-left: 5px solid #dc3545; }
        .avatar-img { width: 45px; height: 45px; border-radius: 50%; border: 2px solid #dc3545; object-fit: cover; }

        /* MODAL (POP-UP) STİLLERİ */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 9999; justify-content: center; align-items: center; }
        .modal-content-box { background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 0 50px rgba(220,53,69,0.5); position: relative; animation: fadeIn 0.3s; }
        @keyframes fadeIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }
        
        .fingerprint-box { position: relative; width: 120px; height: 120px; margin: 20px auto; }
        .scan-bar { width: 100%; height: 4px; background: #dc3545; position: absolute; top: 0; animation: scan 1.5s infinite linear; box-shadow: 0 0 10px #dc3545; }
        @keyframes scan { 0% { top: 0; } 100% { top: 100%; } }
    </style>

    <script>
        // Parmak İzi Pop-up Aç
        function openFinger(ad, soyad) {
            document.getElementById('modalFinger').style.display = 'flex';
            document.getElementById('fingerName').innerText = ad + " " + soyad;
        }
        function closeFinger() { document.getElementById('modalFinger').style.display = 'none'; }

        // Dosya Pop-up Aç
        function openFile(ad, soyad, suc, yer) {
            document.getElementById('modalFile').style.display = 'flex';
            document.getElementById('fileName').innerText = ad + " " + soyad;
            document.getElementById('fileSuc').innerText = suc;
            document.getElementById('fileYer').innerText = yer;
        }
        function closeFile() { document.getElementById('modalFile').style.display = 'none'; }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-4 px-4">

        <div class="d-flex justify-content-between align-items-center mb-5 pb-4 border-bottom">
            <div>
                <h3 class="page-header-title">GBT & SUÇLU SORGULAMA</h3>
                <span class="page-sub-title">Emniyet Genel Müdürlüğü Veri Tabanı Üzerinden Anlık Sorgu</span>
            </div>
            <a href="SucluEkle.aspx" class="btn btn-dark px-4 py-2 fw-bold shadow-sm">
                <i class="fas fa-plus me-2"></i>Yeni Kayıt Aç
            </a>
        </div>

        <div class="text-center mb-5">
            <h2 class="panel-heading">KİMLİK SORGULAMA PANELİ</h2>
            <div class="mb-4">
                <span class="badge bg-light text-dark border px-3 py-2 shadow-sm">
                    <i class="fas fa-wifi text-success me-2"></i>Canlı Veritabanı Bağlantısı
                </span>
            </div>

            <div class="search-wrapper">
                <div class="input-group input-group-lg shadow-sm">
                    <asp:TextBox ID="txtGBTArama" runat="server" CssClass="form-control form-control-lg" placeholder="T.C. Kimlik No veya İsim Soyisim giriniz..."></asp:TextBox>
                    <asp:Button ID="btnSorgula" runat="server" Text="SORGULA" CssClass="btn btn-sorgula" OnClick="btnSorgula_Click" />
                </div>
                
                <asp:Label ID="lblDurum" runat="server" Visible="false" CssClass="d-block mt-4 p-3 fw-bold rounded shadow text-white text-uppercase" style="font-size:1.1rem;"></asp:Label>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <h6 class="p-3 m-0 text-danger fw-bold border-bottom bg-light">
                    <i class="fas fa-list-ul me-2"></i>Sorgu Sonuçları
                </h6>
                
                <div class="table-responsive">
                    <asp:GridView ID="gridSuclular" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover custom-table mb-0" GridLines="None"
                        DataKeyNames="SucluID" OnRowCommand="gridSuclular_RowCommand" OnRowDataBound="gridSuclular_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="PROFİL" ItemStyle-Width="70px" ItemStyle-CssClass="ps-4">
                                <ItemTemplate><asp:Image ID="imgProfil" runat="server" CssClass="avatar-img" /></ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="KimlikNo" HeaderText="T.C." ItemStyle-Font-Bold="true" />
                            
                            <asp:TemplateField HeaderText="AD SOYAD">
                                <ItemTemplate><span class="fw-bold text-dark"><%# Eval("Ad") %> <%# Eval("Soyad") %></span></ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="DogumTarihi" HeaderText="D. TARİHİ" DataFormatString="{0:dd.MM.yyyy}" />
                            <asp:BoundField DataField="SucTuru" HeaderText="SUÇ TÜRÜ" />
                            <asp:BoundField DataField="Sehir" HeaderText="YER" />

                            <asp:TemplateField HeaderText="DURUM">
                                <ItemTemplate>
                                    <span class="badge bg-danger blink-badge">ARANIYOR</span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="KRİMİNAL" ItemStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <button type="button" class="btn btn-sm btn-outline-danger me-1" title="Parmak İzi Tara"
                                            onclick="openFinger('<%# Eval("Ad") %>', '<%# Eval("Soyad") %>')">
                                        <i class="fas fa-fingerprint"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-dark" title="Dosyayı İncele"
                                            onclick="openFile('<%# Eval("Ad") %>', '<%# Eval("Soyad") %>', '<%# Eval("SucTuru") %>', '<%# Eval("Sehir") %>')">
                                        <i class="fas fa-folder-open"></i>
                                    </button>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="YÖNETİM" ItemStyle-CssClass="text-end pe-4">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="Duzenle" CommandArgument='<%# Eval("SucluID") %>' 
                                        CssClass="btn btn-sm btn-primary me-1" ToolTip="Düzenle">
                                        <i class="fas fa-pen"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDel" runat="server" CommandName="Sil" CommandArgument='<%# Eval("SucluID") %>' 
                                        CssClass="btn btn-sm btn-warning text-dark" ToolTip="Sil"
                                        OnClientClick="return confirm('Silmek istediğinize emin misiniz?');">
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div id="modalFinger" class="modal-overlay">
            <div class="modal-content-box" style="width:350px; background:#222; color:white; border: 2px solid #dc3545;">
                <div style="padding:20px; text-align:center;">
                    <h5 class="text-danger fw-bold"><i class="fas fa-fingerprint"></i> EŞLEŞTİRME</h5>
                    <div class="fingerprint-box">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/b/b5/Fingerprint_picture.svg" width="120" style="filter:invert(1); opacity:0.6;">
                        <div class="scan-bar"></div>
                    </div>
                    <h5 id="fingerName" class="fw-bold my-3"></h5>
                    <div class="alert alert-success p-1 small fw-bold">BİYOMETRİK EŞLEŞME: %99.9</div>
                    <button class="btn btn-danger w-100 mt-3" onclick="closeFinger()">KAPAT</button>
                </div>
            </div>
        </div>

        <div id="modalFile" class="modal-overlay">
            <div class="modal-content-box" style="width:600px;">
                <div style="background:#333; color:white; padding:15px; display:flex; justify-content:space-between; align-items:center;">
                    <span class="fw-bold"><i class="fas fa-folder-open me-2"></i>SUÇ KAYDI DETAYI</span>
                    <button class="btn btn-sm btn-danger" onclick="closeFile()">X</button>
                </div>
                <div style="padding:30px; text-align:left; color:#333;">
                    <h2 id="fileName" class="fw-bold border-bottom pb-2 mb-3"></h2>
                    <div class="row g-3 fs-5">
                        <div class="col-6"><strong>Suç Türü:</strong> <span id="fileSuc" class="text-danger"></span></div>
                        <div class="col-6"><strong>Olay Yeri:</strong> <span id="fileYer"></span></div>
                    </div>
                    <div class="alert alert-danger mt-4 mb-0">
                        <i class="fas fa-exclamation-triangle me-2"></i><strong>UYARI:</strong> Şahıs hakkında aktif yakalama kararı bulunmaktadır.
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>