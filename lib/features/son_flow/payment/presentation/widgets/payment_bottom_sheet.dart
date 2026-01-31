import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/home/presentation/manager/payment_cubit.dart';
import 'package:lms/features/son_flow/payment/presentation/widgets/payment_text_form_field.dart';

class PaymentBottomSheet extends StatefulWidget {
  final int courseId;
  const PaymentBottomSheet({super.key, required this.courseId});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  bool _saveCard = false;
  String _selectedPaymentType = 'card'; // Default
  
  final _cardNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _nameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _changeSaveCard(bool value) {
    setState(() {
      _saveCard = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم الاشتراك في الدورة بنجاح!')),
          );
          Navigator.pop(context); // Close bottom sheet
        } else if (state is PaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'حجز الدورة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    _buildPaymentTypeCard(
                      label: 'ولي الامر',
                      type: 'parent',
                      child: const Center(
                        child: Text(
                          'ولي الامر',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    _buildPaymentTypeCard(
                      label: 'Cashback',
                      type: 'cashback',
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppImages.cashBack.image(fit: BoxFit.contain),
                      ),
                    ),
                    _buildPaymentTypeCard(
                      label: 'Card',
                      type: 'card',
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppImages.masterCard.image(fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
                if (_selectedPaymentType == 'card') ...[
                  PaymentTextFormField(
                    controller: _cardNumberController,
                    hintText: 'رقم البطاقة',
                    keyboardType: TextInputType.number,
                  ),
                  PaymentTextFormField(
                    controller: _nameController,
                    hintText: 'الاسم',
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: PaymentTextFormField(
                          controller: _expiryDateController,
                          hintText: 'تاريخ انتهاء الصلاحية',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      Expanded(
                        child: PaymentTextFormField(
                          controller: _cvvController,
                          hintText: 'رمز التحقق من البطاقة (CVV)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'احفظ هذه البطاقة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Switch.adaptive(
                        value: _saveCard,
                        onChanged: (value) {
                          _changeSaveCard(value);
                        },
                        inactiveTrackColor: AppColors.cE8E8E8,
                        inactiveThumbColor: Colors.white,
                        trackOutlineColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        activeTrackColor: AppColors.primary,
                      ),
                    ],
                  ),
                ],
                state is PaymentLoading
                    ? const CircularProgressIndicator()
                    : CustomElevatedButton(
                        onPressed: () {
                          context.read<PaymentCubit>().checkout(
                                courseId: widget.courseId,
                                cardNumber: _cardNumberController.text,
                                expiryDate: _expiryDateController.text,
                                cvv: _cvvController.text,
                                paymentType: _selectedPaymentType,
                              );
                        },
                        title: 'ادفع الان',
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentTypeCard({required String label, required String type, required Widget child}) {
    bool isSelected = _selectedPaymentType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPaymentType = type),
        child: SizedBox(
          height: 100,
          child: Card(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
