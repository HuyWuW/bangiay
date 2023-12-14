
package model;


public class SanPhamBanChay {
    private int idhd;
    private String masp;
    private int tongtien;
    private String tensp;
    private String ngaytao;
    private int slban;

    public int getIdhd() {
        return idhd;
    }

    public void setIdhd(int idhd) {
        this.idhd = idhd;
    }

    public String getMasp() {
        return masp;
    }

    public void setMasp(String masp) {
        this.masp = masp;
    }

    public int getTongtien() {
        return tongtien;
    }

    public void setTongtien(int tongtien) {
        this.tongtien = tongtien;
    }

    public String getTensp() {
        return tensp;
    }

    public void setTensp(String tensp) {
        this.tensp = tensp;
    }

    public String getNgaytao() {
        return ngaytao;
    }

    public void setNgaytao(String ngaytao) {
        this.ngaytao = ngaytao;
    }

    public int getSlban() {
        return slban;
    }

    public void setSlban(int slban) {
        this.slban = slban;
    }

    public SanPhamBanChay(int idhd, String masp, int tongtien, String tensp, String ngaytao, int slban) {
        this.idhd = idhd;
        this.masp = masp;
        this.tongtien = tongtien;
        this.tensp = tensp;
        this.ngaytao = ngaytao;
        this.slban = slban;
    }

    public SanPhamBanChay() {
    }
    
}
