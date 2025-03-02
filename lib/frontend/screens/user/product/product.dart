import 'package:flutter/material.dart';
import 'package:leez/frontend/models/property.dart';

class ListingDetailPage extends StatelessWidget {
  final Property property;

  const ListingDetailPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Enables vertical scrolling
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Section with overlay buttons and image counter.
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(property.images.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 40,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(1.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Share and Like Buttons
                Positioned(
                  top: 40,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(1.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.share),
                          color: Colors.black,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(1.0),
                        ),
                        child: IconButton(
                          icon: Icon(
                            property.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          color: property.isFavorite ? Colors.red : Colors.black,
                          onPressed: () {
                            // Optionally, implement toggle favorite functionality here
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Image Counter
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '1/27',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Main property details content.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use property title and location from the passed Property
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.location,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Example room info (customize as needed)
                  const Text(
                    '2 guests · 1 bedroom · 3 beds · 1 bathroom',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Host info row.
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/boy.png'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hosted by Kalyanasundaram',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Superhost · 3 years hosting',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Stats row: rating, reviews, guest favourite.
                  Row(
                    children: [
                      _buildStat(property.rating.toString(), '★'),
                      const SizedBox(width: 16),
                      _buildStat('79', 'Reviews'),
                      const SizedBox(width: 16),
                      _buildAward('Guest favourite'),
                    ],
                  ),
                  const Divider(height: 32),
                  // Feature items (bullets) – these can be customized or removed.
                  _buildFeatureItem(
                    Icons.emoji_events,
                    'Top 5% of homes',
                    'This home is highly ranked based on ratings, reviews and reliability.',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.ac_unit,
                    'Designed for staying cool',
                    'Beat the heat with the A/C and ceiling fan.',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.landscape,
                    'Amazing outdoor space',
                    'Guests mention the garden as a highlight.',
                  ),
                  const Divider(height: 32),
                  // Description text – you can include more details from property if available.
                  const Text(
                    'Under the foothills of Velliangiri Mountains...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Show more >'),
                  ),
                ],
              ),
            ),
            // Listing details section (rooms, amenities, host info).
            const ListingDetailsSection(),
            // Footer: Additional Host Details Section.
            const HostDetailsSection(),
          ],
        ),
      ),
    );
  }

  // Helper: Stat widget.
  Widget _buildStat(String value, String label) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Helper: Award widget.
  Widget _buildAward(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 78, 76, 70),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            size: 16,
            color: Colors.black,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Feature item row.
  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ListingDetailsSection: Shows additional info like rooms and amenities.
class ListingDetailsSection extends StatelessWidget {
  const ListingDetailsSection({super.key});
  @override
  Widget build(BuildContext context) {
    // You can also update this section to use data from the property if available.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Where you\'ll sleep'),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRoomCard(
                  'Simple Room',
                  '5 seater, 2 air bags',
                  'assets/car_.jpg',
                ),
                const SizedBox(width: 16),
                _buildRoomCard(
                  'Deluxe Room',
                  '7 seater, 4 air bags',
                  'assets/car_.jpg',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('What this place offers'),
          const SizedBox(height: 16),
          _buildAmenities(),
          const SizedBox(height: 32),
          _buildSectionTitle('Meet your host'),
          const SizedBox(height: 16),
          _buildHostCard(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRoomCard(String title, String description, String imageUrl) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    final amenities = [
      {'icon': Icons.landscape, 'text': 'Garden view'},
      {'icon': Icons.landscape_outlined, 'text': 'Mountain view'},
      {'icon': Icons.wifi, 'text': 'Wifi'},
      {'icon': Icons.work, 'text': 'Dedicated workspace'},
      {'icon': Icons.local_parking, 'text': 'Free parking on premises'},
      {'icon': Icons.warning_outlined, 'text': 'Carbon monoxide alarm'},
      {'icon': Icons.smoke_free, 'text': 'Smoke alarm'},
    ];
    return Column(
      children: amenities.map((amenity) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(
                amenity['icon'] as IconData,
                size: 24,
                color: Colors.black,
              ),
              const SizedBox(width: 16),
              Text(
                amenity['text'] as String,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHostCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/boy.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kalyanasundaram',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          '⭐ Superhost',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '3 years hosting',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildHostStat('79', 'Reviews'),
              const SizedBox(width: 24),
              _buildHostStat('5.0', 'Rating'),
              const SizedBox(width: 24),
              _buildHostStat('3', 'Years hosting'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHostStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildMessageButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Message Host',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildProtectionNote() {
    return Row(
      children: [
        // Replace with your actual asset if available.
        Image.asset(
          'assets/logo/quickleez_1.png',
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'To help protect your payment, always use our app to send money and communicate with hosts.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection(
    String title,
    String content, {
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
      ],
    );
  }
}

class HostDetailsSection extends StatelessWidget {
  const HostDetailsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.cake_outlined, 'Born in the 50s'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.work_outline, 'My work: Freelancing'),
          _buildTextButton('Show more'),
          const SizedBox(height: 24),
          const Text(
            'Kalyanasundaram is a Superhost',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Superhosts are experienced, highly rated hosts committed to providing great stays for guests.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Host details'),
          const SizedBox(height: 16),
          _buildDetailRow('Response rate: 100%'),
          const SizedBox(height: 8),
          _buildDetailRow('Responds within an hour'),
          const SizedBox(height: 16),
          _buildMessageButton(),
          const SizedBox(height: 16),
          _buildProtectionNote(),
          const SizedBox(height: 24),
          _buildExpandableSection(
            'Availability',
            '1-6 Apr',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildExpandableSection(
            'Cancellation policy',
            'Free cancellation before 27 Mar. Cancel before check-in on 1 Apr for a partial refund.',
            subtitle: 'Review full policy for details.',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('House rules'),
          const SizedBox(height: 16),
          _buildDetailRow('Check-in after 9:00 am'),
          const SizedBox(height: 8),
          _buildDetailRow('Checkout before 11:00 am'),
          const SizedBox(height: 8),
          _buildDetailRow('2 guests maximum'),
          _buildTextButton('Show more'),
          const SizedBox(height: 24),
          _buildSectionTitle('Safety & property'),
          const SizedBox(height: 16),
          _buildDetailRow('No carbon monoxide alarm'),
          const SizedBox(height: 8),
          _buildDetailRow('No smoke alarm'),
          const SizedBox(height: 8),
          _buildDetailRow('May encounter potentially dangerous animals'),
          _buildTextButton('Show more'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextButton(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildMessageButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Message Host',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildProtectionNote() {
    return Row(
      children: [
        Image.asset(
          'assets/logo/quickleez_1.png',
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'To help protect your payment, always use our app to send money and communicate with hosts.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection(
    String title,
    String content, {
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
      ],
    );
  }
}
