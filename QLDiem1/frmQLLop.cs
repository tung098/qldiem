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
    public partial class frmQLLop : Form
    {
        string conn = @"Data Source=DESKTOP-PGUCCN0;Initial Catalog=QLDiem_SV;integrated security=true";
        private bool m_Flag = true;
        clsLop cls = new clsLop();
        public frmQLLop()
        {
            InitializeComponent();
        }

        private void frmQLLop_Load(object sender, EventArgs e)
        {
            LockEdit(true);
            EndEdit(true);
            LoadData();
            LoadcbKhoa();
            LoadKhoa();
            
        }

        private void LoadData()
        {
            DataTable dt = cls.SelectAll();
            dgvLop.DataSource = dt;
        }

        private void LockEdit(bool v)
        {
            btnThem.Visible = v;
            btnSua.Visible = v;
            btnThoat.Visible = v;
            gbLopHoc.Enabled = v;
            btnHuy.Visible = !v;
            btnLuu.Visible = !v;
            gbChiTiet.Enabled = !v;

        }

        private void EndEdit(bool p)
        {
            btnSua.Enabled = !p;
            txtMaLop.Enabled = !p;
            txtSiSo.Enabled = false;
            
        }

        private void LoadKhoa()
        {
            string sql = "Select MaKhoa, TenKhoa from Khoa order by tenkhoa";

            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            cboKhoa.DataSource = dt;
            cboKhoa.ValueMember = "MaKhoa";
            cboKhoa.DisplayMember = "TenKhoa";
            //cmb.Tag = 1;
        }

        private void LoadcbKhoa()
        {
            var cmb = cboTenKhoa;
            var cb = cboKhoa;
            cmb.Tag = 0;
            clsKhoa cls = new clsKhoa();
            DataTable dt = cls.SelectAll();
            cmb.DataSource = dt;
            cb.DataSource = dt;
            cmb.DisplayMember = "TenKhoa";
            cb.DisplayMember = "TenKhoa";
            cmb.ValueMember = "MaKhoa";
            cb.ValueMember = "MaKhoa";
            cmb.Tag = 1;
        }
        private void ResetBox()
        {
            txtMaLop.Clear();
            txtTenLop.Clear();
            txtSiSo.Clear();
            txtNienKhoa.Clear();
            cboTenKhoa.ResetText();
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            LockEdit(false);
            EndEdit(false);
            ResetBox();
            m_Flag = true;
            txtMaLop.Focus();
        }


        private void btnSua_Click(object sender, EventArgs e)
        {
            LockEdit(false);
            EndEdit(true);
            m_Flag = false;          
        }

        //private void btnXoa_Click(object sender, EventArgs e)
        //{
        //    //if(txtMaLop.Text == null || txtMaLop.Text == " ")
        //    //{
        //    //    MessageBox.Show("Chưa chọn lớp học","Thông báo",MessageBoxButtons.OK, MessageBoxIcon.Error);
        //    //}
        //    if (MessageBox.Show("Ban có muốn xóa không?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No) return;
        //    clsLop cls = new clsLop();
        //    cls.MaLop = Convert.ToString(txtMaLop.Text);
        //    cls.Delete();
        //    LoadData();
        //    EndEdit(true);
        //}

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (!IsValid()) return;
            SaveData();
            LoadData();
            LockEdit(true);
            EndEdit(true);
            ResetBox();
        }

        private void SaveData()
        {
            clsLop cls = new clsLop();
            cls.MaLop = txtMaLop.Text;
            cls.TenLop = txtTenLop.Text;
            cls.SiSo = 0;
            cls.MaKhoa = cboTenKhoa.SelectedValue.ToString();
            cls.NienKhoa = txtNienKhoa.Text;
            if(m_Flag == true)
            {
                cls.Insert();
            }
            else
            {
                cls.Update();
            }
            MessageBox.Show("Thành công", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private bool IsValid()
        {
           for (int i = 0 ; i < dgvLop.Rows.Count - 1; i++)
            {
                string Ma_Lop = dgvLop.Rows[i].Cells["MaLop"].Value.ToString().Trim();
                if(txtMaLop.Text == ""|| txtTenLop.Text == ""|| txtNienKhoa.Text == "")
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ thông tin!!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return false;
                }
                if(m_Flag == true && txtMaLop.Text == Ma_Lop)
                {
                    MessageBox.Show("Mã lớp vừa nhập đã trùng với dòng thứ " + (i+1).ToString());
                    return false;
                }
            }
            return true;
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có thực sự muốn hủy?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No) return;
            LockEdit(true);
            EndEdit(true);
            LoadData();
            ResetBox();
        }
        private void dgvLop_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            int n = e.RowIndex;
            txtMaLop.Text = dgvLop.Rows[n].Cells[0].Value.ToString();
            txtTenLop.Text = dgvLop.Rows[n].Cells[1].Value.ToString();
            txtSiSo.Text = dgvLop.Rows[n].Cells[2].Value.ToString();
            cboTenKhoa.SelectedValue = dgvLop.Rows[n].Cells[3].Value.ToString();
            txtNienKhoa.Text = dgvLop.Rows[n].Cells[4].Value.ToString();
            EndEdit(false);
        }

        private void txtTimKiem_TextChanged(object sender, EventArgs e)
        {
            string tukhoa = txtTimKiem.Text;
            string sql = "SELECT * FROM dbo.Lop  WHERE TenLop LIKE N'%" + tukhoa + "%'";
            SqlDataAdapter daPhong = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            daPhong.Fill(dt);
            dgvLop.DataSource = dt;
        }

        private void cboKhoa_SelectedValueChanged(object sender, EventArgs e)
        {
            if (cboKhoa.SelectedValue != null)
            {
                DataTable dt = cls.SelectAllLop_Khoa(cboKhoa.SelectedValue.ToString().Trim());
                dgvLop.DataSource = dt;
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
