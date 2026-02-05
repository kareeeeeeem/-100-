import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/home/presentation/manager/payment_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lms/features/son_flow/payment/presentation/pages/payment_webview_page.dart';

class PaymentBottomSheet extends StatefulWidget {
  final int courseId;
  final double amount;
  final String courseTitle;
  final String priceLabel;

  final dynamic originalPrice;
  final String? discountPercentage;

  const PaymentBottomSheet({
    super.key,
    required this.courseId,
    required this.amount,
    required this.courseTitle,
    required this.priceLabel,
    this.originalPrice,
    this.discountPercentage,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentType = 'pay_now'; // 'pay_now' or 'ask_parent'
  final _phoneController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendWhatsAppMessage({String? redirectUrl}) async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رقم الهاتف')),
      );
      return;
    }

    // Ensure phone doesn't have + or spaces for wa.me
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    debugPrint('🔍 WhatsApp Debug: widget.priceLabel = "${widget.priceLabel}"');
    debugPrint('🔍 WhatsApp Debug: widget.amount = ${widget.amount}');

    final String pricePart = widget.priceLabel.isNotEmpty ? widget.priceLabel : '${widget.amount} EGP';
    final String courseLink = redirectUrl ?? 'https://100-academy.com/courses/${widget.courseId}';

    String pricingDetails = 'السعر: $pricePart';
    if (widget.originalPrice != null && widget.originalPrice.toString() != '0' && widget.originalPrice.toString() != widget.amount.toString()) {
      pricingDetails = 'السعر بعد الخصم: $pricePart\nالسعر الأصلي: ${widget.originalPrice} EGP';
      if (widget.discountPercentage != null) {
        pricingDetails += '\nنسبة الخصم: ${widget.discountPercentage}%';
      }
    }

    debugPrint('🔍 WhatsApp Debug: final pricePart = "$pricePart"');

    final message =
        'برجاء دفع تمن دورة: ${widget.courseTitle}\n$pricingDetails\n\nرابط الدفع المباشر:\n$courseLink';
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
          BlocConsumer<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is PaymentSuccess) {
                if (_selectedPaymentType == 'ask_parent') {
                  _sendWhatsAppMessage();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال الطلب بنجاح!')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم الاشتراك بنجاح!')),
                  );
                  Navigator.pop(context);
                }
              } else if (state is PaymentRedirect) {
                if (_selectedPaymentType == 'ask_parent') {
                  _sendWhatsAppMessage(redirectUrl: state.url);
                  // We might still want to open the webview if the parent has to pay there,
                  // but usually for "ask parent" the student just pings the parent.
                  // The screenshot shows a confirmation page. Let's open it.
                }
                _openPaymentWebView(state.url);
              } else if (state is PaymentError) {
                setState(() {
                  _errorMessage = state.message;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is PaymentLoading;
              
              if (_selectedPaymentType == 'ask_parent') {
                return _buildAskParentView(isLoading, _errorMessage);
              } else {
                return _buildPayNowView(isLoading, _errorMessage);
              }
            },
          ),
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

  Widget _buildAskParentView(bool isLoading, String? errorMessage) {
    return Form(
      key: _formKey,
      child: Column(
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
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.left,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '9665xxxxxxxxx',
              hintStyle: const TextStyle(color: AppColors.cC7C9D9),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.phone_android, color: AppColors.primary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cE8E8E8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cE8E8E8),
              ),
              errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال رقم الهاتف';
              }
              if (value.length < 9) {
                return 'رقم الهاتف قصير جداً';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'سيتم إرسال رابط الدفع المباشر لهذا الرقم ليقوم ولي أمرك بالسداد.',
            style: TextStyle(fontSize: 12, color: AppColors.c8C8C8C),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _errorMessage = null;
                      });
                      context.read<PaymentCubit>().processPayment(
                            courseId: widget.courseId,
                            paymentMethod: 'guardian',
                            guardianPhone: _phoneController.text.trim(),
                          );
                    }
                  },
                  title: 'إرسال الطلب لولي الأمر',
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.39),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPayNowView(bool isLoading, String? errorMessage) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.originalPrice != null && widget.originalPrice.toString() != '0' && widget.originalPrice.toString() != widget.amount.toString()) ...[
                        Text(
                          '${widget.originalPrice} EGP',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        if (widget.discountPercentage != null)
                          Text(
                            'خصم ${widget.discountPercentage}%',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                      Text(
                        widget.priceLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.c17AB13, // Use a green color for finalized price
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                  });
                  context.read<PaymentCubit>().processPayment(
                        courseId: widget.courseId,
                        paymentMethod: 'paynow',
                      );
                },
                title: 'تأكيد العملية',
              ),
      ],
    );
  }

  void _openPaymentWebView(String url) async {
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebViewPage(url: url),
      ),
    );

    if (success == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الدفع والاشتراك بنجاح!')),
        );
        Navigator.pop(context);
      }
    } else if (success == false) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشلت عملية الدفع. يرجى المحاولة مرة أخرى.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
