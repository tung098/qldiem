namespace QLDiem1
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.superTabControl1 = new DevComponents.DotNetBar.SuperTabControl();
            this.btnDangXuat = new DevComponents.DotNetBar.SuperTabControlPanel();
            this.superTabItem2 = new DevComponents.DotNetBar.SuperTabItem();
            this.superTabControlPanel1 = new DevComponents.DotNetBar.SuperTabControlPanel();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.label1 = new System.Windows.Forms.Label();
            this.lblTen = new System.Windows.Forms.Label();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.btnQlUser = new DevComponents.DotNetBar.ButtonX();
            this.btnQLLHP = new DevComponents.DotNetBar.ButtonX();
            this.btnQLHocPhan = new DevComponents.DotNetBar.ButtonX();
            this.btnQLLop = new DevComponents.DotNetBar.ButtonX();
            this.btnQLDiem = new DevComponents.DotNetBar.ButtonX();
            this.btnQLGiangVien = new DevComponents.DotNetBar.ButtonX();
            this.btnSinhVien = new DevComponents.DotNetBar.ButtonX();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.superTabItem1 = new DevComponents.DotNetBar.SuperTabItem();
            this.buttonItem1 = new DevComponents.DotNetBar.ButtonItem();
            ((System.ComponentModel.ISupportInitialize)(this.superTabControl1)).BeginInit();
            this.superTabControl1.SuspendLayout();
            this.superTabControlPanel1.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // superTabControl1
            // 
            // 
            // 
            // 
            // 
            // 
            // 
            this.superTabControl1.ControlBox.CloseBox.Name = "";
            // 
            // 
            // 
            this.superTabControl1.ControlBox.MenuBox.Name = "";
            this.superTabControl1.ControlBox.Name = "";
            this.superTabControl1.ControlBox.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.superTabControl1.ControlBox.MenuBox,
            this.superTabControl1.ControlBox.CloseBox});
            this.superTabControl1.Controls.Add(this.superTabControlPanel1);
            this.superTabControl1.Controls.Add(this.btnDangXuat);
            this.superTabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.superTabControl1.Location = new System.Drawing.Point(0, 0);
            this.superTabControl1.Name = "superTabControl1";
            this.superTabControl1.ReorderTabsEnabled = true;
            this.superTabControl1.SelectedTabFont = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold);
            this.superTabControl1.SelectedTabIndex = 0;
            this.superTabControl1.Size = new System.Drawing.Size(862, 429);
            this.superTabControl1.TabFont = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.superTabControl1.TabIndex = 0;
            this.superTabControl1.Tabs.AddRange(new DevComponents.DotNetBar.BaseItem[] {
            this.superTabItem1,
            this.superTabItem2,
            this.buttonItem1});
            this.superTabControl1.Text = "superTabControl1";
            // 
            // btnDangXuat
            // 
            this.btnDangXuat.AntiAlias = false;
            this.btnDangXuat.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnDangXuat.Location = new System.Drawing.Point(0, 26);
            this.btnDangXuat.Name = "btnDangXuat";
            this.btnDangXuat.Size = new System.Drawing.Size(862, 403);
            this.btnDangXuat.TabIndex = 0;
            this.btnDangXuat.TabItem = this.superTabItem2;
            // 
            // superTabItem2
            // 
            this.superTabItem2.AttachedControl = this.btnDangXuat;
            this.superTabItem2.GlobalItem = false;
            this.superTabItem2.Name = "superTabItem2";
            this.superTabItem2.Text = "Xem thông tin điểm";
            // 
            // superTabControlPanel1
            // 
            this.superTabControlPanel1.Controls.Add(this.tableLayoutPanel1);
            this.superTabControlPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.superTabControlPanel1.Location = new System.Drawing.Point(0, 26);
            this.superTabControlPanel1.Name = "superTabControlPanel1";
            this.superTabControlPanel1.Size = new System.Drawing.Size(862, 403);
            this.superTabControlPanel1.TabIndex = 1;
            this.superTabControlPanel1.TabItem = this.superTabItem1;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 16.70534F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 83.29466F));
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel3, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.flowLayoutPanel1, 1, 1);
            this.tableLayoutPanel1.Controls.Add(this.pictureBox1, 1, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 2;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 12.90323F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 87.09677F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(862, 403);
            this.tableLayoutPanel1.TabIndex = 2;
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.tableLayoutPanel2.ColumnCount = 1;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel2.Controls.Add(this.label1, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.lblTen, 0, 1);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(3, 3);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 2;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(137, 46);
            this.tableLayoutPanel2.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(3, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(131, 23);
            this.label1.TabIndex = 0;
            this.label1.Text = "Xin chào";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lblTen
            // 
            this.lblTen.AutoSize = true;
            this.lblTen.Dock = System.Windows.Forms.DockStyle.Fill;
            this.lblTen.Font = new System.Drawing.Font("Microsoft Sans Serif", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTen.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.lblTen.Location = new System.Drawing.Point(3, 23);
            this.lblTen.Name = "lblTen";
            this.lblTen.Size = new System.Drawing.Size(131, 23);
            this.lblTen.TabIndex = 1;
            this.lblTen.Text = "label2";
            this.lblTen.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.BackColor = System.Drawing.SystemColors.GradientInactiveCaption;
            this.tableLayoutPanel3.ColumnCount = 1;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Controls.Add(this.btnQlUser, 0, 6);
            this.tableLayoutPanel3.Controls.Add(this.btnQLLHP, 0, 5);
            this.tableLayoutPanel3.Controls.Add(this.btnQLHocPhan, 0, 4);
            this.tableLayoutPanel3.Controls.Add(this.btnQLLop, 0, 3);
            this.tableLayoutPanel3.Controls.Add(this.btnQLDiem, 0, 2);
            this.tableLayoutPanel3.Controls.Add(this.btnQLGiangVien, 0, 1);
            this.tableLayoutPanel3.Controls.Add(this.btnSinhVien, 0, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(3, 55);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 7;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 14.28571F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(137, 345);
            this.tableLayoutPanel3.TabIndex = 1;
            // 
            // btnQlUser
            // 
            this.btnQlUser.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnQlUser.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnQlUser.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnQlUser.Location = new System.Drawing.Point(10, 304);
            this.btnQlUser.Margin = new System.Windows.Forms.Padding(10);
            this.btnQlUser.Name = "btnQlUser";
            this.btnQlUser.Size = new System.Drawing.Size(117, 31);
            this.btnQlUser.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnQlUser.TabIndex = 6;
            this.btnQlUser.Text = "Quản lý Người dùng";
            // 
            // btnQLLHP
            // 
            this.btnQLLHP.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnQLLHP.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnQLLHP.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnQLLHP.Location = new System.Drawing.Point(10, 255);
            this.btnQLLHP.Margin = new System.Windows.Forms.Padding(10);
            this.btnQLLHP.Name = "btnQLLHP";
            this.btnQLLHP.Size = new System.Drawing.Size(117, 29);
            this.btnQLLHP.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnQLLHP.TabIndex = 5;
            this.btnQLLHP.Text = "Quản lý Lớp học phần";
            this.btnQLLHP.Click += new System.EventHandler(this.btnQLLHP_Click);
            // 
            // btnQLHocPhan
            // 
            this.btnQLHocPhan.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnQLHocPhan.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnQLHocPhan.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnQLHocPhan.Location = new System.Drawing.Point(10, 206);
            this.btnQLHocPhan.Margin = new System.Windows.Forms.Padding(10);
            this.btnQLHocPhan.Name = "btnQLHocPhan";
            this.btnQLHocPhan.Size = new System.Drawing.Size(117, 29);
            this.btnQLHocPhan.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnQLHocPhan.TabIndex = 4;
            this.btnQLHocPhan.Text = "Quản lý Học phần";
            this.btnQLHocPhan.Click += new System.EventHandler(this.btnQLHocPhan_Click);
            // 
            // btnQLLop
            // 
            this.btnQLLop.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnQLLop.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnQLLop.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnQLLop.Location = new System.Drawing.Point(10, 157);
            this.btnQLLop.Margin = new System.Windows.Forms.Padding(10);
            this.btnQLLop.Name = "btnQLLop";
            this.btnQLLop.Size = new System.Drawing.Size(117, 29);
            this.btnQLLop.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnQLLop.TabIndex = 3;
            this.btnQLLop.Text = "Quản lý Lớp";
            this.btnQLLop.Click += new System.EventHandler(this.btnQLLop_Click);
            // 
            // btnQLDiem
            // 
            this.btnQLDiem.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnQLDiem.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnQLDiem.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnQLDiem.Location = new System.Drawing.Point(10, 108);
            this.btnQLDiem.Margin = new System.Windows.Forms.Padding(10);
            this.btnQLDiem.Name = "btnQLDiem";
            this.btnQLDiem.Size = new System.Drawing.Size(117, 29);
            this.btnQLDiem.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnQLDiem.TabIndex = 2;
            this.btnQLDiem.Text = "Quản lý điểm";
            this.btnQLDiem.Click += new System.EventHandler(this.btnQLDiem_Click);
            // 
            // btnQLGiangVien
            // 
            this.btnQLGiangVien.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnQLGiangVien.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnQLGiangVien.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnQLGiangVien.Location = new System.Drawing.Point(10, 59);
            this.btnQLGiangVien.Margin = new System.Windows.Forms.Padding(10);
            this.btnQLGiangVien.Name = "btnQLGiangVien";
            this.btnQLGiangVien.Size = new System.Drawing.Size(117, 29);
            this.btnQLGiangVien.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnQLGiangVien.TabIndex = 1;
            this.btnQLGiangVien.Text = "Quản lý giáo viên\r\n";
            this.btnQLGiangVien.Click += new System.EventHandler(this.btnQLGiangVien_Click);
            // 
            // btnSinhVien
            // 
            this.btnSinhVien.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
            this.btnSinhVien.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;
            this.btnSinhVien.Dock = System.Windows.Forms.DockStyle.Fill;
            this.btnSinhVien.Location = new System.Drawing.Point(10, 10);
            this.btnSinhVien.Margin = new System.Windows.Forms.Padding(10);
            this.btnSinhVien.Name = "btnSinhVien";
            this.btnSinhVien.Size = new System.Drawing.Size(117, 29);
            this.btnSinhVien.Style = DevComponents.DotNetBar.eDotNetBarStyle.StyleManagerControlled;
            this.btnSinhVien.TabIndex = 0;
            this.btnSinhVien.Text = "Quản lý sinh viên";
            this.btnSinhVien.Click += new System.EventHandler(this.btnSinhVien_Click);
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(146, 55);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(713, 345);
            this.flowLayoutPanel1.TabIndex = 2;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(146, 3);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(713, 46);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 3;
            this.pictureBox1.TabStop = false;
            // 
            // superTabItem1
            // 
            this.superTabItem1.AttachedControl = this.superTabControlPanel1;
            this.superTabItem1.GlobalItem = false;
            this.superTabItem1.Name = "superTabItem1";
            this.superTabItem1.Text = "Quản lý danh mục";
            // 
            // buttonItem1
            // 
            this.buttonItem1.FontBold = true;
            this.buttonItem1.ForeColor = System.Drawing.Color.Red;
            this.buttonItem1.Name = "buttonItem1";
            this.buttonItem1.Text = "Đăng xuất";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(862, 429);
            this.Controls.Add(this.superTabControl1);
            this.IsMdiContainer = true;
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(878, 468);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Trang chủ";
            ((System.ComponentModel.ISupportInitialize)(this.superTabControl1)).EndInit();
            this.superTabControl1.ResumeLayout(false);
            this.superTabControlPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel2.PerformLayout();
            this.tableLayoutPanel3.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private DevComponents.DotNetBar.SuperTabControl superTabControl1;
        private DevComponents.DotNetBar.SuperTabControlPanel superTabControlPanel1;
        private DevComponents.DotNetBar.SuperTabItem superTabItem1;
        private DevComponents.DotNetBar.SuperTabControlPanel btnDangXuat;
        private DevComponents.DotNetBar.SuperTabItem superTabItem2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private DevComponents.DotNetBar.ButtonX btnQLLHP;
        private DevComponents.DotNetBar.ButtonX btnQLHocPhan;
        private DevComponents.DotNetBar.ButtonX btnQLLop;
        private DevComponents.DotNetBar.ButtonX btnQLDiem;
        private DevComponents.DotNetBar.ButtonX btnQLGiangVien;
        private DevComponents.DotNetBar.ButtonX btnSinhVien;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblTen;
        private System.Windows.Forms.PictureBox pictureBox1;
        private DevComponents.DotNetBar.ButtonX btnQlUser;
        private DevComponents.DotNetBar.ButtonItem buttonItem1;
    }
}

