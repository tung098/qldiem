using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLDiem1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            this.WindowState = FormWindowState.Maximized;
        }
        private Form IsActive(Type type)
        {
            foreach (Form f in this.MdiChildren)
            {
                if (f.GetType() == type)
                    return f;
            }
            return null;
        }
       
        private void btnSinhVien_Click(object sender, EventArgs e)
        {
            flowLayoutPanel1.Controls.Clear();
            //frmBanHang frm = new frmBanHang();
            frmSinhVien frm = new frmSinhVien();
            frm.TopLevel = false;
            flowLayoutPanel1.Controls.Add(frm);
           // frm.Dock = DockStyle.Fill;
            frm.Size = new System.Drawing.Size(flowLayoutPanel1.Size.Width,flowLayoutPanel1.Size.Height);
            frm.Show();
        }

        private void btnQLGiangVien_Click(object sender, EventArgs e)
        {
            flowLayoutPanel1.Controls.Clear();
            //frmBanHang frm = new frmBanHang();
            frmGiangVien frm = new frmGiangVien();
            frm.TopLevel = false;
            flowLayoutPanel1.Controls.Add(frm);
            // frm.Dock = DockStyle.Fill;
            frm.Size = new System.Drawing.Size(flowLayoutPanel1.Size.Width, flowLayoutPanel1.Size.Height);
            frm.Show();
        }

        private void btnQLDiem_Click(object sender, EventArgs e)
        {
            flowLayoutPanel1.Controls.Clear();
            //frmBanHang frm = new frmBanHang();
            frmQLDiem frm = new frmQLDiem();
            frm.TopLevel = false;
            flowLayoutPanel1.Controls.Add(frm);
            // frm.Dock = DockStyle.Fill;
            frm.Size = new System.Drawing.Size(flowLayoutPanel1.Size.Width, flowLayoutPanel1.Size.Height);
            frm.Show();
        }

        private void btnQLLop_Click(object sender, EventArgs e)
        {
            flowLayoutPanel1.Controls.Clear();
            //frmBanHang frm = new frmBanHang();
            frmQLLop frm = new frmQLLop();
            frm.TopLevel = false;
            flowLayoutPanel1.Controls.Add(frm);
            // frm.Dock = DockStyle.Fill;
            frm.Size = new System.Drawing.Size(flowLayoutPanel1.Size.Width, flowLayoutPanel1.Size.Height);
            frm.Show();
        }

        private void btnQLHocPhan_Click(object sender, EventArgs e)
        {

            flowLayoutPanel1.Controls.Clear();
            //frmBanHang frm = new frmBanHang();
            frmQLHocPhan frm = new frmQLHocPhan();
            frm.TopLevel = false;
            flowLayoutPanel1.Controls.Add(frm);
            // frm.Dock = DockStyle.Fill;
            frm.Size = new System.Drawing.Size(flowLayoutPanel1.Size.Width, flowLayoutPanel1.Size.Height);
            frm.Show();
        }

        private void btnQLLHP_Click(object sender, EventArgs e)
        {
            flowLayoutPanel1.Controls.Clear();
            //frmBanHang frm = new frmBanHang();
            frmQLLHP frm = new frmQLLHP();
            frm.TopLevel = false;
            flowLayoutPanel1.Controls.Add(frm);
            // frm.Dock = DockStyle.Fill;
            frm.Size = new System.Drawing.Size(flowLayoutPanel1.Size.Width, flowLayoutPanel1.Size.Height);
            frm.Show();
        }
    }
}
