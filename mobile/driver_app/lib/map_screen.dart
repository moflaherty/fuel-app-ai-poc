import 'dart:math' as math;
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Color palette
// ---------------------------------------------------------------------------

abstract class _MapColors {
  static const navy = Color(0xFF0D1B3E);
  static const mapBackground = Color(0xFF9EC8BE);
  static const mapBlock = Color(0xFF87BDB4);
  static const mapRoad = Color(0xFFF0EDDF);
  static const selectedNav = Color(0xFF1565C0);
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                color: _MapColors.navy,
                onPressed: () => Navigator.pop(context),
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                color: _MapColors.navy,
                onPressed: () {},
              ),
        title: const Text(
          'Kinetic Command',
          style: TextStyle(
            color: _MapColors.navy,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: _MapColors.navy,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const _VehicleSearchBar(),
          Expanded(
            child: Stack(
              children: [
                // Map background
                Positioned.fill(child: CustomPaint(painter: _MapPainter())),
                // Vehicle label + marker — centered in the map
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _VehicleLabel(),
                      SizedBox(height: 10),
                      _VehicleMarker(),
                    ],
                  ),
                ),
                // Signal & Battery cards (top-right)
                const Positioned(
                  top: 12,
                  right: 12,
                  child: _SignalBatteryPanel(),
                ),
                // Zoom +/- controls (bottom-right)
                const Positioned(bottom: 12, right: 12, child: _ZoomControls()),
              ],
            ),
          ),
          // ETA bottom bar
          const _EtaInfoBar(),
        ],
      ),
      bottomNavigationBar: _MapBottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (i) => setState(() => _selectedNavIndex = i),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom painter — simulated city grid map
// ---------------------------------------------------------------------------

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = _MapColors.mapBackground,
    );

    const roadWidth = 10.0;
    const cellSize = 52.0;
    const stride = roadWidth + cellSize;

    final blockPaint = Paint()..color = _MapColors.mapBlock;
    final roadPaint = Paint()..color = _MapColors.mapRoad;

    // City blocks
    for (double y = 0; y < size.height + stride; y += stride) {
      for (double x = 0; x < size.width + stride; x += stride) {
        canvas.drawRect(
          Rect.fromLTWH(x + roadWidth, y + roadWidth, cellSize, cellSize),
          blockPaint,
        );
      }
    }

    // Vertical roads
    for (double x = 0; x < size.width + stride; x += stride) {
      canvas.drawRect(Rect.fromLTWH(x, 0, roadWidth, size.height), roadPaint);
    }

    // Horizontal roads
    for (double y = 0; y < size.height + stride; y += stride) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, roadWidth), roadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Search bar
// ---------------------------------------------------------------------------

class _VehicleSearchBar extends StatelessWidget {
  const _VehicleSearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.local_shipping_outlined, color: Colors.grey),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Search vehicle ID or destination',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.tune, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vehicle label
// ---------------------------------------------------------------------------

class _VehicleLabel extends StatelessWidget {
  const _VehicleLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'UNIT-882  ·  MOVING',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vehicle marker — diamond shape with truck icon
// ---------------------------------------------------------------------------

class _VehicleMarker extends StatelessWidget {
  const _VehicleMarker();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 4, // rotate container 45° to form a diamond
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: _MapColors.navy,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(70),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Transform.rotate(
          angle: -math.pi / 4, // counter-rotate the icon to stay upright
          child: const Icon(
            Icons.local_shipping,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Signal & battery status panel
// ---------------------------------------------------------------------------

class _SignalBatteryPanel extends StatelessWidget {
  const _SignalBatteryPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusCard(
          label: 'SIGNAL',
          icon: Icons.signal_cellular_alt,
          iconColor: _MapColors.navy,
        ),
        SizedBox(height: 8),
        _StatusCard(
          label: 'BATTERY',
          icon: Icons.battery_3_bar,
          iconColor: Colors.orange,
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(235),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(28), blurRadius: 4),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Icon(icon, size: 20, color: iconColor),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Zoom controls (+/-)
// ---------------------------------------------------------------------------

class _ZoomControls extends StatelessWidget {
  const _ZoomControls();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ZoomButton(icon: Icons.add, onPressed: () {}),
        Container(height: 1, width: 36, color: Colors.grey.shade200),
        _ZoomButton(icon: Icons.remove, onPressed: () {}),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 4),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom ETA info bar
// ---------------------------------------------------------------------------

class _EtaInfoBar extends StatelessWidget {
  const _EtaInfoBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Direction icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _MapColors.navy,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.navigation, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          // ETA text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DESTINATION ETA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '14:20',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '(+12m)',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Details button
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: _MapColors.navy,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'DETAILS',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom navigation bar
// ---------------------------------------------------------------------------

class _MapBottomNavBar extends StatelessWidget {
  const _MapBottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _MapColors.selectedNav,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 10,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping_outlined),
          activeIcon: Icon(Icons.local_shipping),
          label: 'DELIVERIES',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car_outlined),
          activeIcon: Icon(Icons.directions_car),
          label: 'VEHICLES',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.headset_mic_outlined),
          activeIcon: Icon(Icons.headset_mic),
          label: 'SUPPORT',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'PROFILE',
        ),
      ],
    );
  }
}
