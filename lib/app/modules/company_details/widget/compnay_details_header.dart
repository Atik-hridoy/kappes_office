import 'package:canuck_mall/app/constants/app_images.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_details_controller.dart';

class CompanyDetailsHeader extends StatelessWidget {
  const CompanyDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyDetailsController>();
    
    if (controller.isLoading) {
      return Row(
        children: [
          Container(
            height: AppSize.height(height: 13.0),
            width: AppSize.height(height: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.height(height: 1.5)),
              color: Colors.grey[300],
            ),
          ),
          SizedBox(width: AppSize.width(width: 2.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: AppSize.height(height: 0.5)),
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    if (controller.errorMessage != null) {
      return Container(
        height: AppSize.height(height: 13.0),
        child: Center(
          child: Text(
            controller.errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    
    final business = controller.business;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppSize.width(width: 2.0),
      children: [
        Container(
          height: AppSize.height(height: 13.0),
          width: AppSize.height(height: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppSize.height(height: 1.5),
            ),
            border: Border.all(color: AppColors.white),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppSize.height(height: 1.5),
            ),
            child: AppImage(
              imagePath: business.logo.isNotEmpty ? business.logo : AppImages.shopLogo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.business, color: AppColors.gray);
              },
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                business.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              Text(
                business.service,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              Row(
                children: [
                  // Star rating
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < business.rating.floor() 
                          ? Icons.star 
                          : Icons.star_border,
                        color: Colors.amber, 
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text("(${business.reviewCount} reviews)", style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(height: AppSize.height(height: 0.5)),
              if (business.isVerified)
                Row(
                  children: [
                    Icon(Icons.verified, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text("Verified Business", style: TextStyle(fontSize: 12, color: Colors.blue)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
