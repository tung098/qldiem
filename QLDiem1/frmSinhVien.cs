using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QLDiem_SV;
using System.Data.SqlClient;

namespace QLDiem1
{
    public partial class frmSinhVien : Form
    {
        private string str_Flag;
        clsSinhVien cls = new clsSinhVien();
        string conn = @"Data Source=DESKTOP-PGUCCN0;Initial Catalog=QLDiem_SV;integrated security=true";
        public frmSinhVien()
        {
            InitializeComponent();
        }

        public void load_dgv()
        {
            DataTable dt = cls.SelectAll();
            dgvSinhVien.DataSource = dt;
        }

        public void EnableCbo(bool b)
        {
            cboKhoa.Enabled = b;
            cboLop.Enabled = b;
        }

        public void Enable(bool bl)
        {
            txtMaSV.Enabled = bl;
            txtTenSV.Enabled = bl;
            dtpNgaySinh.Enabled = bl;
            rbNam.Enabled = bl;
            rbNu.Enabled = bl;
            txtQueQuan.Enabled = bl;
            txtDiaChiHT.Enabled = bl;
            cboMaLop.Enabled = bl;
            btnLuu.Enabled = bl;
            btnHuy.Enabled = bl;
            btnThem.Enabled = !bl;
            btnSua.Enabled = !bl;
            btnXoa.Enabled = !bl;
        }

        private void CleaData()
        {
            txtMaSV.ResetText();
            txtTenSV.ResetText();
            dtpNgaySinh.ResetText();
            //rbNam.ResetText();
            //rbNu.ResetText();
            txtQueQuan.ResetText();
            txtDiaChiHT.ResetText();
            cboMaLop.ResetText();
            txtSoTCDaDat.ResetText();
            txtSoTCDaDKy.ResetText();
            txtDiemTichLuy.ResetText();
        }


        public void load_CBO_Khoa()
        {
            string sql = "Select MaKhoa, TenKhoa from Khoa order by tenkhoa";

            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboKhoa.DataSource = dt;
            cboKhoa.ValueMember = "MaKhoa";
            cboKhoa.DisplayMember = "TenKhoa";
        }

        public void load_CBO_Lop(string MaKhoa)
        {
            string sql = "Select MaLop,TenLop from LOP";
            if (MaKhoa != null)
                sql += " Where MaKhoa =  '" + MaKhoa + "'";
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboLop.DataSource = dt;
            cboLop.ValueMember = "MaLop";
            cboLop.DisplayMember = "TenLop";
        }

        public void load_CBO_MaLop()
        {
            string sql = "Select distinct MaLop from Lop ";

            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboMaLop.DataSource = dt;
            cboMaLop.ValueMember = "MaLop";
            cboMaLop.DisplayMember = "MaLop";
        }

        private bool CheckDL()
        {
            if (txtMaSV.Text == null )
            {

                return false;
            }
            return true;
        }


        private void frmSinhVien_Load(object sender, EventArgs e)
        {
            Enable(false);
            load_CBO_Khoa();
            load_dgv();
            txtSoTCDaDat.Enabled = false;
            txtSoTCDaDKy.Enabled = false;
            txtDiemTichLuy.Enabled = false;
            load_CBO_MaLop();
        }



        private void dgvSinhVien_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            txtMaSV.Text = dgvSinhVien.Rows[e.RowIndex].Cells["MaSV"].Value.ToString();
            txtTenSV.Text = dgvSinhVien.Rows[e.RowIndex].Cells["HoTen"].Value.ToString();
            dtpNgaySinh.Text = dgvSinhVien.Rows[e.RowIndex].Cells["NgaySinh"].Value.ToString();
            txtQueQuan.Text = dgvSinhVien.Rows[e.RowIndex].Cells["QueQuan"].Value.ToString();
            txtDiaChiHT.Text = dgvSinhVien.Rows[e.RowIndex].Cells["DiaChiHT"].Value.ToString();
            cboMaLop.Text = dgvSinhVien.Rows[e.RowIndex].Cells["MaLop"].Value.ToString();
            txtSoTCDaDat.Text = dgvSinhVien.Rows[e.RowIndex].Cells["SoTinChiDaDat"].Value.ToString();
            txtSoTCDaDKy.Text = dgvSinhVien.Rows[e.RowIndex].Cells["SoTinChiDaDKi"].Value.ToString();
            txtDiemTichLuy.Text = dgvSinhVien.Rows[e.RowIndex].Cells["DiemTichLuy"].Value.ToString();
            if (dgvSinhVien.Rows[e.RowIndex].Cells["GioiTinh"].Value.ToString().Trim() == "Nam")
            {
                rbNam.Checked = true;
                rbNu.Checked = false;
            }
            else
            {
                rbNu.Checked = true;
                rbNam.Checked = false;
            }

        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            str_Flag = "them";
            Enable(true);
            btnSua.Enabled = false;
            btnXoa.Enabled = false;
            CleaData();
            EnableCbo(false);
            txtMaSV.Enabled = false;
            //load_CBO_MaLop();
            
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            str_Flag = "sua";
            Enable(true);
            btnThem.Enabled = false;
            btnXoa.Enabled = false;
            EnableCbo(false);
            txtMaSV.Enabled = false;
            
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvSinhVien.CurrentRow == null)
            {
                MessageBox.Show("Vui lòng chọn sinh viên", "Thông báo:");
            }
            DialogResult dg = MessageBox.Show("Bạn có muốn xóa không?", "Warning", MessageBoxButtons.YesNo);
            if (dg == DialogResult.Yes)
            {
                cls.MaSV = txtMaSV.Text;
                //cls.MaLopHP = cboMaLHP.SelectedValue.ToString();
                cls.Delete();
                MessageBox.Show("Thành công.");
                load_dgv();
                Enable(false);
                str_Flag = "";


            }
            
            
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (CheckDL())
            {
                cls.MaSV = txtMaSV.Text;
                cls.HoTen = txtTenSV.Text;
                cls.NgaySinh = Convert.ToDateTime(dtpNgaySinh.Value.ToShortDateString());
                if (rbNam.Checked)
                {
                    cls.GioiTinh = "Nam";
                }
                else
                {
                    cls.GioiTinh = "Nữ";
                }
                
                cls.QueQuan = txtQueQuan.Text;
                cls.DiaChiHT = txtDiaChiHT.Text;
                cls.MaLop = cboMaLop.SelectedValue.ToString();
                cls.SoTinChiDaDat = 0;
                cls.DiemTichLuy = 0;
                cls.SoTinChiDaDKi = 0;
                if (str_Flag == "them")
                {
                    cls.MaSV = "";

                    cls.Insert();
                }
                else
                if (str_Flag == "sua")
                {
                    cls.Update();
                }

                MessageBox.Show("Thành công.");
                load_dgv();
                Enable(false);
                str_Flag = "";
            }
            else
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin.", "Warning");
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            str_Flag = "";
            CleaData();
            Enable(false);
            EnableCbo(true);
        }

        private void cboKhoa_SelectedValueChanged(object sender, EventArgs e)
        {

            if (cboKhoa.SelectedValue != null)
            {
                load_CBO_Lop(cboKhoa.SelectedValue.ToString().Trim());               
            }

            if (cboLop.SelectedValue != null)
            {
                DataTable dt = cls.SelectAllSV_Khoa(cboKhoa.SelectedValue.ToString().Trim());
                dgvSinhVien.DataSource = dt;
            }
                

            
        }

        private void cboLop_SelectedValueChanged(object sender, EventArgs e)
        {
            if(cboLop.SelectedValue != null)
            {
                DataTable dt = cls.SelectAllSV_Lop(cboLop.SelectedValue.ToString().Trim());
                dgvSinhVien.DataSource = dt;
            }
            
        }

        private void txtTimKiem_TextChanged(object sender, EventArgs e)
        {
            string key = txtTimKiem.Text;
            string sql = "SELECT * FROM SinhVien  WHERE HoTen LIKE N'%" + key + "%'";
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            dgvSinhVien.DataSource = dt;
        }
    }
}
