import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/support_controller.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available if not already bound via bindings
    final ctrl = Get.put(SupportController(), permanent: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.helpAndSupport,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          // Shimmer loader while fetching contacts
          return ListView.separated(
            padding: EdgeInsets.all(AppSize.height(height: 2.0)),
            itemCount: 6,
            separatorBuilder: (_, __) => SizedBox(height: AppSize.height(height: 1.0)),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.lightGray, width: 1.0),
                    borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.height(height: 1.0), vertical: AppSize.height(height: 1.0)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AppSize.height(height: 5.0),
                              height: AppSize.height(height: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                              ),
                            ),
                            SizedBox(width: AppSize.height(height: 1.0)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(height: 14, width: AppSize.width(width: 40), color: Colors.grey.shade300),
                                  SizedBox(height: 8),
                                  Container(height: 12, width: AppSize.width(width: 60), color: Colors.grey.shade300),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(height: 1.0)),
                        Divider(height: 1),
                        SizedBox(height: AppSize.height(height: 1.0)),
                        Row(
                          children: [
                            Container(
                              width: AppSize.height(height: 5.0),
                              height: AppSize.height(height: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
                              ),
                            ),
                            SizedBox(width: AppSize.height(height: 1.0)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(height: 14, width: AppSize.width(width: 50), color: Colors.grey.shade300),
                                  SizedBox(height: 8),
                                  Container(height: 12, width: AppSize.width(width: 70), color: Colors.grey.shade300),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        if (ctrl.errorMessage.isNotEmpty) {
          return _ErrorView(
            message: ctrl.errorMessage.value,
            onRetry: () => ctrl.fetchContacts(),
          );
        }
        if (ctrl.contacts.isEmpty) {
          return _EmptyView(onRetry: () => ctrl.fetchContacts());
        }

        return RefreshIndicator(
          onRefresh: () => ctrl.fetchContacts(),
          child: ListView.separated(
            padding: EdgeInsets.all(AppSize.height(height: 2.0)),
            itemCount: ctrl.contacts.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSize.height(height: 1.0)),
            itemBuilder: (context, index) {
              final c = ctrl.contacts[index];
              return _ContactCard(
                phone: c.displayPhone.isNotEmpty ? c.displayPhone : c.phone,
                email: c.email,
                location: c.location,
              );
            },
          ),
        );
      }),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String phone;
  final String email;
  final String location;

  const _ContactCard({
    required this.phone,
    required this.email,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGray, width: 1.0),
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.height(height: 1.0)),
        child: Column(
          children: [
            ListTile(
              leading: AppImage(
                imagePath: AppIcons.supportPhone,
                height: AppSize.height(height: 5.0),
                width: AppSize.height(height: 5.0),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: AppColors.error);
                },
              ),
              title: AppText(
                title: AppStaticKey.phone,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: AppText(
                title: phone,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray,
                    ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: AppImage(
                imagePath: AppIcons.supportMail,
                height: AppSize.height(height: 5.0),
                width: AppSize.height(height: 5.0),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: AppColors.error);
                },
              ),
              title: AppText(
                title: AppStaticKey.emailAddress,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: AppText(
                title: email,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray,
                    ),
              ),
            ),
            if (location.isNotEmpty) const Divider(height: 1),
            if (location.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Colors.redAccent),
                title: AppText(
                  title: 'Location',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: AppText(
                  title: location,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              title: message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSize.height(height: 1.5)),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSize.height(height: 2.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              title: 'No contacts found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSize.height(height: 1.5)),
            ElevatedButton(onPressed: onRetry, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}