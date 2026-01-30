import 'package:flutter/material.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_elevated_button.dart';
import 'package:lms/features/son_flow/payment/presentation/widgets/payment_text_form_field.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({super.key});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  bool _saveCard = false;

  void _changeSaveCard(bool value) {
    setState(() {
      _saveCard = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                const Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: Center(
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
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppImages.cashBack.image(fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppImages.masterCard.image(fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const PaymentTextFormField(hintText: 'رقم البطاقة'),
            const PaymentTextFormField(hintText: 'الاسم'),
            const Row(
              spacing: 20,
              children: [
                Expanded(
                  child: PaymentTextFormField(
                    hintText: 'تاريخ انتهاء الصلاحية',
                  ),
                ),
                Expanded(
                  child: PaymentTextFormField(
                    hintText: 'رمز التحقق من البطاقة (CVV)',
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
            CustomElevatedButton(onPressed: () {}, title: 'ادفع الان'),
          ],
        ),
      ),
    );
  }
}
