import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/home/presentation/manager/payment_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentBottomSheet extends StatefulWidget {
  final int courseId;
  final double amount;
  final String courseTitle;
  final String priceLabel;

  const PaymentBottomSheet({
    super.key,
    required this.courseId,
    required this.amount,
    required this.courseTitle,
    required this.priceLabel,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  String _selectedPaymentType = 'pay_now'; // 'pay_now' or 'ask_parent'
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendWhatsAppMessage() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رقم الهاتف')),
      );
      return;
    }

    // Ensure phone doesn't have + or spaces for wa.me
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    final message =
        'برجاء دفع تمن دورة: ${widget.courseTitle}\nالسعر: ${widget.priceLabel}';
    final httpsUrl = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";
    final whatsappUrl = "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}";

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else if (await canLaunchUrl(Uri.parse(httpsUrl))) {
        await launchUrl(Uri.parse(httpsUrl), mode: LaunchMode.externalApplication);
      } else {
        // Last resort effort
        await launchUrl(Uri.parse(httpsUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح واتساب. تأكد من تثبيت التطبيق على جهازك.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'تأكيد الاشتراك',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اختر الطريقة المناسبة لإتمام عملية التسجيل',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.c8C8C8C,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildTabButton(
                title: 'طلب من ولي الأمر',
                isSelected: _selectedPaymentType == 'ask_parent',
                icon: Icons.person_add_alt_1_outlined,
                onTap: () => setState(() => _selectedPaymentType = 'ask_parent'),
              ),
              const SizedBox(width: 16),
              _buildTabButton(
                title: 'ادفع الآن',
                isSelected: _selectedPaymentType == 'pay_now',
                icon: Icons.credit_card_outlined,
                onTap: () => setState(() => _selectedPaymentType = 'pay_now'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_selectedPaymentType == 'ask_parent') _buildAskParentView(),
          if (_selectedPaymentType == 'pay_now') _buildPayNowView(),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء والعودة',
              style: TextStyle(
                color: AppColors.c8C8C8C,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(
              BorderSide(
                color: isSelected ? Colors.black : AppColors.cE8E8E8,
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : AppColors.c8C8C8C,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.black : AppColors.c8C8C8C,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAskParentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'رقم جوال ولي الأمر (واتساب)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '9665xxxxxxxxx',
            hintStyle: const TextStyle(color: AppColors.cC7C9D9),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cE8E8E8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cE8E8E8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'سيتم إرسال رابط الدفع المباشر لهذا الرقم.',
          style: TextStyle(fontSize: 12, color: AppColors.c8C8C8C),
        ),
        const SizedBox(height: 24),
        CustomElevatedButton(
          onPressed: _sendWhatsAppMessage,
          title: 'إرسال الطلب لولي الأمر',
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25D366),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.39),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayNowView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الدورة:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.c8C8C8C,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.courseTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.c1E1E1E,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'إجمالي المبلغ:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.c8C8C8C,
                    ),
                  ),
                  Text(
                    widget.priceLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.c589B6E,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم الاشتراك في الدورة بنجاح!')),
              );
              Navigator.pop(context);
            } else if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return state is PaymentLoading
                ? const CircularProgressIndicator()
                : CustomElevatedButton(
                    onPressed: () {
                      // context.read<PaymentCubit>().checkout(...);
                      // TODO: Integrate Paymob WebView later
                    },
                    title: 'تأكيد العملية',
                  );
          },
        ),
      ],
    );
  }
}
