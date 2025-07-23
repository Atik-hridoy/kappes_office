import 'package:flutter/material.dart';

class ShippingAddressCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final VoidCallback onEditTap;

  const ShippingAddressCard({
    required this.name,
    required this.phone,
    required this.address,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('SHIPPING ADDRESS'),
            trailing: IconButton(icon: Icon(Icons.edit), onPressed: onEditTap),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildInfoRow(Icons.person, name),
                _buildInfoRow(Icons.phone, phone),
                _buildInfoRow(Icons.home, address, maxLines: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 16),
          Expanded(child: Text(text, maxLines: maxLines)),
        ],
      ),
    );
  }
}
