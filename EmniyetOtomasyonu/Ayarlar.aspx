<%@ Page Title="Sistem Ayarları" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ayarlar.aspx.cs" Inherits="EmniyetOtomasyonu.Ayarlar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Sekme Tasarımı */
        .nav-pills .nav-link { color: #495057; font-weight: 500; border-radius: 8px; padding: 12px 20px; transition: all 0.3s; }
        .nav-pills .nav-link.active { background-color: #0d6efd; color: white; box-shadow: 0 4px 6px rgba(13, 110, 253, 0.3); }
        .nav-pills .nav-link:hover:not(.active) { background-color: #e9ecef; }
        
        /* Kart Tasarımı */
        .settings-card { border: none; border-radius: 12px; box-shadow: 0 0 20px rgba(0,0,0,0.05); }
        
        /* Tablo Başlıkları */
        .table thead th { background-color: #f8f9fa; border-bottom: 2px solid #dee2e6; color: #6c757d; font-size: 0.85rem; text-transform: uppercase; }
        
        /* Log Satırları */
        .log-row { font-size: 0.9rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-4">
        
        <div class="row">
            <div class="col-md-3 mb-4">
                <div class="card settings-card h-100">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-4 text-dark"><i class="fas fa-cogs me-2 text-primary"></i>YÖNETİM PANELİ</h5>
                        
                        <div class="nav flex-column nav-pills me-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                            
                            <button class="nav-link active text-start mb-2" id="v-pills-users-tab" data-bs-toggle="pill" data-bs-target="#v-pills-users" type="button" role="tab">
                                <i class="fas fa-users-cog me-2"></i>Kullanıcı Yönetimi
                            </button>

                            <button class="nav-link text-start mb-2" id="v-pills-system-tab" data-bs-toggle="pill" data-bs-target="#v-pills-system" type="button" role="tab">
                                <i class="fas fa-sliders-h me-2"></i>Sistem Parametreleri
                            </button>
                            
                            <button class="nav-link text-start mb-2" id="v-pills-logs-tab" data-bs-toggle="pill" data-bs-target="#v-pills-logs" type="button" role="tab">
                                <i class="fas fa-shield-alt me-2"></i>Güvenlik & Loglar
                            </button>
                            
                            <button class="nav-link text-start" id="v-pills-about-tab" data-bs-toggle="pill" data-bs-target="#v-pills-about" type="button" role="tab">
                                <i class="fas fa-info-circle me-2"></i>Sistem Hakkında
                            </button>

                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-9">
                <div class="tab-content" id="v-pills-tabContent">
                    
                    <div class="tab-pane fade show active" id="v-pills-users" role="tabpanel">
                        <div class="card settings-card">
                            <div class="card-header bg-white py-3">
                                <h6 class="mb-0 fw-bold">Kayıtlı Personel ve Yetkiler</h6>
                            </div>
                            <div class="card-body">
                                <asp:GridView ID="gridKullanicilar" runat="server" CssClass="table table-hover align-middle" AutoGenerateColumns="false" GridLines="None">
                                    <Columns>
                                        <asp:BoundField DataField="Ad" HeaderText="AD" />
                                        <asp:BoundField DataField="Soyad" HeaderText="SOYAD" />
                                        <asp:BoundField DataField="Rutbe" HeaderText="RÜTBE / ROL" ItemStyle-Font-Bold="true" />
                                        <asp:BoundField DataField="GorevYeri" HeaderText="GÖREV YERİ" />
                                        <asp:TemplateField HeaderText="DURUM">
                                            <ItemTemplate>
                                                <span class="badge bg-success rounded-pill">Aktif</span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="İŞLEM">
                                            <ItemTemplate>
                                                <button class="btn btn-sm btn-outline-primary"><i class="fas fa-edit"></i></button>
                                                <button class="btn btn-sm btn-outline-danger"><i class="fas fa-ban"></i></button>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="v-pills-system" role="tabpanel">
                        <div class="card settings-card mb-4">
                            <div class="card-header bg-white py-3">
                                <h6 class="mb-0 fw-bold">Genel Sistem Ayarları</h6>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold small text-muted">VARSAYILAN RAPOR FORMATI</label>
                                        <select class="form-select">
                                            <option>PDF (Adobe Acrobat)</option>
                                            <option>XLSX (Excel)</option>
                                            <option>HTML (Web Görünümü)</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold small text-muted">OTURUM ZAMAN AŞIMI (Dakika)</label>
                                        <input type="number" class="form-control" value="15" />
                                    </div>
                                    <div class="col-md-12">
                                        <hr />
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" id="switch1" checked>
                                            <label class="form-check-label" for="switch1">Kritik Olaylarda Yöneticiye E-Posta Gönder</label>
                                        </div>
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" id="switch2" checked>
                                            <label class="form-check-label" for="switch2">Otomatik Günlük Veritabanı Yedeği Al</label>
                                        </div>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="switch3">
                                            <label class="form-check-label" for="switch3">Bakım Modunu Aktif Et (Sadece Admin Girişi)</label>
                                        </div>
                                    </div>
                                    <div class="col-12 text-end mt-3">
                                        <button class="btn btn-primary px-4 shadow-sm"><i class="fas fa-save me-2"></i>Ayarları Kaydet</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="v-pills-logs" role="tabpanel">
                        <div class="card settings-card">
                            <div class="card-header bg-dark text-white py-3 d-flex justify-content-between align-items-center">
                                <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>SİSTEM İŞLEM KAYITLARI (LOG)</h6>
                                <span class="badge bg-danger">CANLI İZLEME</span>
                            </div>
                            <div class="card-body p-0">
                                <asp:GridView ID="gridLoglar" runat="server" CssClass="table table-striped table-hover mb-0 log-row" AutoGenerateColumns="false" GridLines="None">
                                    <Columns>
                                        <asp:BoundField DataField="LogID" HeaderText="#" />
                                        <asp:BoundField DataField="Tarih" HeaderText="ZAMAN" DataFormatString="{0:dd.MM.yyyy HH:mm:ss}" />
                                        <asp:BoundField DataField="Kullanici" HeaderText="KULLANICI" ItemStyle-Font-Bold="true" />
                                        <asp:BoundField DataField="IslemTuru" HeaderText="İŞLEM TÜRÜ" />
                                        <asp:BoundField DataField="Detay" HeaderText="DETAY / AÇIKLAMA" />
                                        <asp:BoundField DataField="IPAdresi" HeaderText="IP ADRESİ" ItemStyle-CssClass="text-muted small" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                            <div class="card-footer bg-white text-center">
                                <button class="btn btn-sm btn-outline-secondary"><i class="fas fa-sync-alt me-1"></i>Listeyi Yenile</button>
                                <button class="btn btn-sm btn-outline-danger"><i class="fas fa-trash-alt me-1"></i>Eski Kayıtları Temizle</button>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="v-pills-about" role="tabpanel">
                        <div class="card settings-card text-center p-5">
                            <img src="https://upload.wikimedia.org/wikipedia/tr/0/08/Emniyet_Genel_M%C3%BCd%C3%BCrl%C3%BC%C4%9F%C3%BC_logosu.png" width="100" class="mb-3 mx-auto d-block" />
                            <h4 class="fw-bold">EGM OTOMASYON SİSTEMİ</h4>
                            <p class="text-muted">Kurumsal Personel ve Vaka Takip Yazılımı</p>
                            <hr class="w-25 mx-auto my-4" />
                            <div class="row justify-content-center text-start" style="max-width: 400px; margin: 0 auto;">
                                <div class="col-6 fw-bold text-muted">Versiyon:</div>
                                <div class="col-6">v2.0.4 (Beta)</div>
                                
                                <div class="col-6 fw-bold text-muted mt-2">Geliştirici:</div>
                                <div class="col-6 mt-2">Yazılım Ekibi</div>
                                
                                <div class="col-6 fw-bold text-muted mt-2">Framework:</div>
                                <div class="col-6 mt-2">ASP.NET WebForms / .NET 4.8</div>

                                <div class="col-6 fw-bold text-muted mt-2">Lisans:</div>
                                <div class="col-6 mt-2"><span class="badge bg-warning text-dark">EĞİTİM AMAÇLI</span></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</asp:Content>