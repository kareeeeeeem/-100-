import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_images.dart';
import 'package:lms/core/widgets/custom_container.dart';
import 'package:lms/features/parent_flow/payment/presentation/widgets/payment_bottom_sheet.dart';

class PaymentRequestsPage extends StatelessWidget {
  const PaymentRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات الدفع')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.9,
                    child: const PaymentBottomSheet(),
                  );
                },
              );
            },
            child: CustomContainer(
              borderRadius: 5,
              borderWidth: 0.3,
              borderAlpha: 0.4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppImages.parentSectionItem.image(
                        width: 60,
                        height: 60,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'تصميم الوجهات',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '20',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 20);
        },
        itemCount: 20,
      ),
    );
  }
}
