using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using QLDiem_SV;

namespace QLDiem1
{
    public partial class frmQLDiem : Form
    {
        private string str_Flag;
        clsKetQuaLHP cls = new clsKetQuaLHP();
        public frmQLDiem()
        {
            InitializeComponent();
            Lock(false);
        }
        public void Lock(bool bl)
        {
            
            txtDiem10.Enabled = bl;
            txtDiemChu.Enabled = bl;
            txtDiem4.Enabled = bl;
            
        }
        public void Enable(bool bl)
        {
            btnLuu.Enabled = bl;
            btnHuy.Enabled = bl;
            cboSinhVien.Enabled = bl;
            cboHP.Enabled = bl;
            cboMaLHP.Enabled = bl;
            txtDiemChuyenCan.Enabled = bl;
            txtDiemTX.Enabled = bl;
            txtDiemThi.Enabled = bl;
            btnThem.Enabled = !bl;
            btnSua.Enabled = !bl;
            btnXoa.Enabled = !bl;
        }

        private void CleaData()
        {
            cboHP.ResetText();
            cboMaLHP.ResetText();
            cboSinhVien.ResetText();
            txtDiemChuyenCan.ResetText();
            txtDiemTX.ResetText();
            txtDiemThi.ResetText();
            txtDiem10.ResetText();
            txtDiem4.ResetText();
            txtDiemChu.ResetText();
        }
        private void label1_Click(object sender, EventArgs e)
        {

        }
        public void load_dgv()
        {
            DataTable dt = cls.SelectAllDiemLHP();
            dgvDiem.DataSource = dt;
        }
        public void load_CBO_Khoa()
        {
            string conn = @"Data Source=DESKTOP-PGUCCN0;Initial Catalog=QLDiem_SV;integrated security=true";
            string sql = "Select MaKhoa, TenKhoa from Khoa order by tenkhoa";
            
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboKhoa.DataSource = dt;
            cboKhoa.ValueMember = "MaKhoa";
            cboKhoa.DisplayMember = "TenKhoa";
        }
        public void load_CBO_MaHP()
        {
            string conn = @"Data Source=DESKTOP-PGUCCN0;Initial Catalog=QLDiem_SV;integrated security=true";
            string sql = "Select MaHP,TenHP from HocPhan";
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboHP.DataSource = dt;
            cboHP.ValueMember = "MaHP";
            cboHP.DisplayMember = "TenHP";
        }
        public void load_CBO_MaSV_ALL()
        {
            string conn = @"Data Source=DESKTOP-PGUCCN0;Initial Catalog=QLDiem_SV;integrated security=true";
            string sql = "Select MaSV,HoTen from SinhVien";
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboSinhVien.DataSource = dt;
            cboSinhVien.ValueMember = "MaSV";
            cboSinhVien.DisplayMember = "HoTen";
        }
        public void load_CBO_MaLopHP(string MaHP)
        {
            string conn = @"Data Source=DESKTOP-PGUCCN0;Initial Catalog=QLDiem_SV;integrated security=true";
            string sql = "Select MaLopHP from LopHocPhan";
            if (MaHP != null)
                sql += " Where MaHP =  '" + MaHP + "'" ;
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboMaLHP.DataSource = dt;
            cboMaLHP.ValueMember = "MaLopHP";
            cboMaLHP.DisplayMember = "MaLopHP";
        }

        public void load_CBO_MaSV(string MaLHP)
        {
            string conn = @"Data Source=DESKTOP-PGUCCN0;Initial Catalog=QLDiem_SV;integrated security=true";
            string sql = "SELECT KetQuaLHP.MaSV, HoTen FROM dbo.KetQuaLHP JOIN dbo.SinhVien ON SinhVien.MaSV = KetQuaLHP.MaSV ";
            if (MaLHP != null)
                sql += " Where MaLopHP =  '" + MaLHP + "'";
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboSinhVien.DataSource = dt;
            cboSinhVien.ValueMember = "MaSV";
            cboSinhVien.DisplayMember = "HoTen";
        }
        private void frmQLDiem_Load(object sender, EventArgs e)
        {
            Enable(false);
            load_CBO_Khoa();
            load_dgv();
            load_CBO_MaHP();
            
        }


        private void btnThem_Click(object sender, EventArgs e)
        {
            str_Flag = "them";
            Enable(true);
            btnSua.Enabled = false;
            btnXoa.Enabled = false;
            CleaData();
            
            load_CBO_MaLopHP("");
            
        }
        
        private void btnSua_Click(object sender, EventArgs e)
        {
            str_Flag = "sua";
            Enable(true);
            btnThem.Enabled = false;
            btnXoa.Enabled = false;
            if (cboMaLHP.SelectedValue == null)
                load_CBO_MaSV("");
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvDiem.CurrentRow == null)
            {
                MessageBox.Show("Vui lòng chọn sinh viên","Thông báo:");
            }
            DialogResult dg = MessageBox.Show("Bạn có muốn xóa không?","Warning",MessageBoxButtons.YesNo);
            if (dg == DialogResult.Yes)
            {
                cls.MaSV = cboSinhVien.SelectedValue.ToString();
                cls.MaLopHP = cboMaLHP.SelectedValue.ToString();
                cls.Delete();
            }
            MessageBox.Show("Thành công.");
            load_dgv();
            Lock(false);
            Enable(false);
            str_Flag = "";
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (CheckDL())
            {
                cls.MaSV = cboSinhVien.SelectedValue.ToString();
                cls.MaLopHP = cboMaLHP.SelectedValue.ToString();
                cls.DiemCC = Convert.ToDouble(txtDiemChuyenCan.Text);
                cls.DiemTX = Convert.ToDouble(txtDiemTX.Text);
                cls.DiemThi = Convert.ToDouble(txtDiemThi.Text);
                cls.DiemHe10 = 0;
                cls.DiemHeBon = 0;
                cls.DiemChu = "";
                if (str_Flag == "them")
                {

                    cls.Insert();
                }
                else
                if (str_Flag == "sua")
                {
                    cls.Update();
                }
               
                MessageBox.Show("Thành công.");
                load_dgv();
                Lock(false);
                Enable(false);
                str_Flag = "";
            }
            else
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin.", "Warning");
        }

        private bool CheckDL()
        {
            if (cboHP.SelectedValue == null || cboMaLHP.SelectedValue == null || cboSinhVien.SelectedValue == null)
            {
                
                return false;
            }
            return true;
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            str_Flag = "";
            CleaData();
            Enable(false);
            load_CBO_MaHP();
        }

        private void cboKhoa_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable dt = cls.SelectAllDiemLHP_Khoa(cboKhoa.SelectedValue.ToString().Trim());
            dgvDiem.DataSource = dt;
        }
        private void cboHocPhan_SelectedValueChanged(object sender, EventArgs e)
        {
            if (cboHP.SelectedValue != null)
                load_CBO_MaLopHP(cboHP.SelectedValue.ToString().Trim());
        }

        private void cboMaLHP_SelectedValueChanged(object sender, EventArgs e)
        {
            if (str_Flag == "sua")
            {
                if (cboMaLHP.SelectedValue != null)
                    load_CBO_MaSV(cboMaLHP.SelectedValue.ToString().Trim());
                else
                    cboSinhVien.SelectedValue = null;
            }
            if (str_Flag =="them")
            {
                if (cboMaLHP.SelectedValue != null)
                    load_CBO_MaSV_ALL();
                else
                    cboSinhVien.SelectedValue = null;
            }
        }

        private void dgvDiem_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            cboHP.Text = dgvDiem.CurrentRow.Cells["TenHP"].Value.ToString();
            cboMaLHP.SelectedValue = dgvDiem.Rows[e.RowIndex].Cells["MaLopHP"].Value.ToString();
            cboSinhVien.SelectedValue = dgvDiem.Rows[e.RowIndex].Cells["MaSV"].Value.ToString();
            cboSinhVien.Text = dgvDiem.Rows[e.RowIndex].Cells["HoTen"].Value.ToString();
            txtDiemChuyenCan.Text = dgvDiem.Rows[e.RowIndex].Cells["DiemCC"].Value.ToString();
            txtDiemTX.Text = dgvDiem.Rows[e.RowIndex].Cells["DiemTX"].Value.ToString();
            txtDiemThi.Text = dgvDiem.Rows[e.RowIndex].Cells["DiemThi"].Value.ToString();
            txtDiem10.Text = dgvDiem.Rows[e.RowIndex].Cells["DiemHe10"].Value.ToString();
            txtDiem4.Text = dgvDiem.Rows[e.RowIndex].Cells["DiemHeBon"].Value.ToString();
            txtDiemChu.Text = dgvDiem.Rows[e.RowIndex].Cells["DiemChu"].Value.ToString();

        }

        
    }
}
