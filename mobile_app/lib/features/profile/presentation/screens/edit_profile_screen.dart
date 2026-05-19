import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../home/data/datasources/home_remote_datasource.dart';
import '../../../home/data/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final HomeRemoteDataSource _dataSource = HomeRemoteDatasourceImpl();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _schoolCtrl;

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isPublic = true;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _schoolCtrl = TextEditingController();
    _loadUser();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _schoolCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final user = await _dataSource.getUserInfo();
      if (!mounted) return;
      setState(() {
        _user = user;
        _nameCtrl.text = user.name;
        _emailCtrl.text = user.email;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final updated = await _dataSource.updateUserProfile(
        fullName: _nameCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _user = updated;
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật thông tin cá nhân.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Chỉnh sửa thông tin', style: AppTextStyles.heading2),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _isLoading ? null : _save,
                  child: const Text(
                    'Lưu',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Avatar ──
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: AppColors.white,
                            backgroundImage: (_user?.avatar != null &&
                                    _user!.avatar!.isNotEmpty)
                                ? NetworkImage(_user!.avatar!)
                                : null,
                            child: (_user?.avatar == null ||
                                    _user!.avatar!.isEmpty)
                                ? Icon(
                                    Icons.person,
                                    size: 44,
                                    color: AppColors.primary.withValues(
                                        alpha: 0.8),
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Chức năng đổi ảnh sẽ sớm ra mắt.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.primary,
                                child: Icon(Icons.camera_alt,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Role badge ──
                    if (_user?.role != null) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _user!.role!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── Họ và tên (từ API) ──
                    _buildField(
                      controller: _nameCtrl,
                      label: 'HỌ VÀ TÊN',
                      hint: 'Nhập họ và tên',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ và tên' : null,
                    ),

                    // ── Email (từ API, read-only) ──
                    _buildField(
                      controller: _emailCtrl,
                      label: 'EMAIL',
                      hint: 'Email đăng ký',
                      icon: Icons.email_outlined,
                      readOnly: true,
                      helperText: 'Email không thể thay đổi',
                    ),

                    // ── Số điện thoại ──
                    _buildField(
                      controller: _phoneCtrl,
                      label: 'SỐ ĐIỆN THOẠI',
                      hint: 'Nhập số điện thoại',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    // ── Trường học ──
                    _buildField(
                      controller: _schoolCtrl,
                      label: 'TRƯỜNG HỌC HIỆN TẠI',
                      hint: 'Nhập tên trường',
                      icon: Icons.school_outlined,
                    ),

                    const SizedBox(height: 4),

                    // ── Đổi mật khẩu ──
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Chức năng đổi mật khẩu sẽ sớm ra mắt.')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Đổi mật khẩu',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(fontWeight: FontWeight.w600)),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Public profile toggle ──
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.privacy_tip_outlined,
                              color: AppColors.warning),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text('Hiển thị hồ sơ công khai',
                                  style: AppTextStyles.bodyMedium)),
                          Switch(
                            value: _isPublic,
                            activeColor: AppColors.primary,
                            onChanged: (v) => setState(() => _isPublic = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    String? helperText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            validator: validator,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              prefixIcon:
                  Icon(icon, size: 18, color: AppColors.textSecondary),
              filled: true,
              fillColor: readOnly
                  ? AppColors.background
                  : AppColors.white,
              helperText: helperText,
              helperStyle: TextStyle(fontSize: 11, color: Colors.grey[500]),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
