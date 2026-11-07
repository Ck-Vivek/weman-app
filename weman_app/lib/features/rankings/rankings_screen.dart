import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/weman_colors.dart';
import '../../core/theme/weman_typography.dart';

class AthleteRankItem {
  final int rank;
  final String name;
  final String handle;
  final String title;
  final String xp;
  final String avatarUrl;
  final String change;
  final bool isUp;
  final bool isDown;

  const AthleteRankItem({
    required this.rank,
    required this.name,
    required this.handle,
    required this.title,
    required this.xp,
    required this.avatarUrl,
    required this.change,
    this.isUp = false,
    this.isDown = false,
  });
}

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  int _selectedScopeIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _scopes = [
    'National (India)',
    'State (Karnataka)',
    'District (Bangalore Urban)',
    'Region (South)',
    'College (Metro Univ)',
  ];

  final List<AthleteRankItem> _allContenders = [
    const AthleteRankItem(
      rank: 4,
      name: 'Rohan Sharma',
      handle: '@rohan.lifts',
      title: 'Master Athlete',
      xp: '8,640 XP',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBf3GkMVsk20JlZGEJ3-1o3Sk5T1uvds3SwWm-b-C_AJHN0Zr3PGeyh4W2Fwnspmpn-3OciY5wQ-l8G0ePSxMl2G99cyu3PB9HZX9sbUI-kaa4w_ZrCoT58jsUMn7JyGmvT32k7kiBrW54khf9WdoS7YTDqLKWQPwfvVxaSb92jJ34ut-f8uHTfDHIk8fo-MYPynlQx_jUHuwpB03I8xoSyJG7SkIzLALO6JqTJ2Tcxkji2QJc-UC39',
      change: '+2',
      isUp: true,
    ),
    const AthleteRankItem(
      rank: 5,
      name: 'Maya Torres',
      handle: '@maya.fit',
      title: 'Elite Athlete',
      xp: '8,420 XP',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC_SKEyjObMOSKEzssvbDmmvz8EVGbCKGootMUP9AaQCx_9IJWuK1URt8lQLlMIWERbwpXzjJa-iYeUU0c8rCdeDrWhAL7zOpH4--cTSCCA5Zzd_LMO3XKTSEF75bNPHemS-LluW0719dhxlMIg_CfIe-72DRStHRWjKwjsVkKQLTcJp4f6JCCnui0WmC_rqvd28CULaeF7RTfYJSPJtXlKl4-6hCurkHSndIo-YvjldV86QInO4LKL',
      change: '+4',
      isUp: true,
    ),
    const AthleteRankItem(
      rank: 6,
      name: 'Dev Patel',
      handle: '@dev.runs',
      title: 'Consistency Warrior',
      xp: '8,190 XP',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBBDRm7yb23gnYkj2AQIU_V6Ze7644ktfhghSl30qzDiBHuPvZWmDfCu1H0YRfTJ0V0cuEdLj8RIwnfDAs6Pwo-Hq16nnMdOE49OLAIJ-KDRbzuedol3-URq58THYdaWXG6-99Yw60YmdXCDI7hSZekIGCk4BWjZe3AvrrjNn5ZO6HEgar0qaaXhaUH1yB0B8clJNJl4l8GmuPskfcrEmVtdD3rjspBVTZqTkvOeMiBFfRXIbMrzhju',
      change: '0',
    ),
    const AthleteRankItem(
      rank: 7,
      name: 'Ananya Sen',
      handle: '@ananya.power',
      title: 'Master Athlete',
      xp: '8,050 XP',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDj6NLMjkJYQNxRVdMqjxoJQ-FQOXD-gHDI72VMcdrIPfhMTr0-ZDry-nyvkIs5P0IrKeIM9BqJC6O72XJtYfle20J3F7KYeN4sOyhlqHwDfwAmzmWgjVRuFZ9NMB5jlsGMzrroYOs6djnZw1ektYvGfgRZ9R5IXIKhA2oIfPes1v-mkf1bHAfui-zf94FeOgngY6VCLsE6ABzlSDg7UKJPZ50x05qfzBtgHm0H8qZCf7oCirvyfXrz',
      change: '+1',
      isUp: true,
    ),
    const AthleteRankItem(
      rank: 8,
      name: 'Kabir Roy',
      handle: '@kabir.lifts',
      title: 'Elite Athlete',
      xp: '7,980 XP',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCidtLJJ4t_Uxjr1LiE3x6z-xWcSe1loGt7o3gM7GbAa5xFTtj09L-P-j6doDcLyGBTQ08nD6vzi6v45YcDkQRK7l7TaSlDiB_0Xo6fLPVQDcjSz6fiDh8SFjYuF8Xn6Z2JNfDQjx2Vhz4Fit3x4du7R0U8YDDJhRlfAULm6E5oDnKMMFoc0rutLxidY4B5RJuVIfUZG80jF6oFfWrehPlVnyWSq_dlQpjl6zX2PGmfPb0ZPI22IDue',
      change: '-1',
      isDown: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredContenders = _allContenders.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return item.name.toLowerCase().contains(q) ||
          item.handle.toLowerCase().contains(q) ||
          item.title.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: WemanColors.surface,
      appBar: AppBar(
        backgroundColor: WemanColors.surface.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: WemanColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Leaderboard',
          style: WemanTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w800,
            color: WemanColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_rounded,
                color: WemanColors.onSurface, size: 22),
            onPressed: () => context.push('/inbox'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: WemanColors.onSurface, size: 22),
            onPressed: () => _showRankingsInfo(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Search Bar
                _buildSearchBar(),
                const SizedBox(height: 12),

                // 2. Scope Filter Chips
                _buildScopeFilterChips(),
                const SizedBox(height: 14),

                // 3. Athletic Top 3 Podium
                _buildTopThreePodium(),
                const SizedBox(height: 18),

                // 4. Section Header: Top Contenders
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.leaderboard_rounded,
                            color: WemanColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Top Contenders',
                          style: WemanTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Updated 10m ago',
                      style: WemanTypography.labelSmall.copyWith(
                        color: WemanColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 5. Contenders List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredContenders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = filteredContenders[index];
                    return _buildContenderCard(item);
                  },
                ),
                const SizedBox(height: 18),

                // 6. Illustrative Disclaimer
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Rankings are illustrative demo computations based on logged workout consistency and volume.',
                      textAlign: TextAlign.center,
                      style: WemanTypography.bodySmall.copyWith(
                        color: WemanColors.textMuted,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // 7. Sticky Current-User Rank Card (Floating at bottom)
          Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: _buildStickyCurrentUserCard(),
          ),
        ],
      ),
    );
  }

  // --- 1. SEARCH BAR ---
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: WemanTypography.bodySmall.copyWith(color: WemanColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search athletes, gym clubs...',
          hintStyle: WemanTypography.bodySmall
              .copyWith(color: WemanColors.textMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded,
              color: WemanColors.textMuted, size: 20),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: WemanColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune_rounded,
                size: 16, color: WemanColors.onSurface),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // --- 2. SCOPE FILTER CHIPS ---
  Widget _buildScopeFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _scopes.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedScopeIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedScopeIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? WemanColors.neonLime : WemanColors.cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? WemanColors.neonLime
                        : WemanColors.surfaceContainerHigh,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? WemanColors.neonLime.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: WemanColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      _scopes[index],
                      style: WemanTypography.labelSmall.copyWith(
                        color: isSelected
                            ? WemanColors.onSurface
                            : WemanColors.textMuted,
                        fontWeight:
                            isSelected ? FontWeight.w900 : FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 3. ATHLETIC TOP 3 PODIUM ---
  Widget _buildTopThreePodium() {
    return Container(
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient Glow behind 1st Place
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 140,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WemanColors.neonLime.withValues(alpha: 0.22),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Rank 2: Silver Pedestal (Left)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: WemanColors.surfaceContainerHigh,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuAbWhwTXn23u8f0wBHsMBpPnWzNsvnB_ylpJHQAEAJ0UnmaLW_a_XcAxE0fcL8Us5GnRuZZtBFBbd3yn3LPvzPKwoX42hB95iJVY5vdz2xGqiZxHVU2ZVw8w7mcBaEo63yBi3MlrWCnUsQJ4mfwlC8XE_Qq0sNmIwMFrPSq0DfnjNy8aE78rxgDXRwthgBtj08i1odm7V4X7ij2brJd3qmG5VQ30AqpmNlF_KMw4okxuIu0n5hgglSB',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: WemanColors.onSurface),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -4,
                            right: -2,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8C6C5),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Icon(Icons.workspace_premium_rounded,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sneha Rao',
                        style: WemanTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1.5),
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: WemanColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Master',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: WemanColors.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '9,210 XP',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          color: WemanColors.primary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Silver Pillar
                      Container(
                        height: 84,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: WemanColors.surfaceContainerHigh,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '2',
                              style: WemanTypography.headlineLarge.copyWith(
                                fontWeight: FontWeight.w900,
                                color: WemanColors.secondary,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'SILVER',
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                                letterSpacing: 0.8,
                                color: WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Rank 1: Gold Pedestal (Center, Elevated)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 74,
                            height: 74,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: WemanColors.neonLime, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: WemanColors.neonLime
                                      .withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDQNTLCikX5_o5zgXSYFLVFiY9ejIQCSYPv8j5kMpr0SsEo1_sr6F7XZ9ArRiA_a-979Yb6XkdtJWKeyAAlCaHlepSasYfIN2vWJyF1ExRVHN60S_f_wegIIbt-r8AzsAaOtXlZQcUtZZ4iAjv2mQ4krD7bREdPGjA-Um_6o_xd6x5_WKwVA4ujzj_doBu72ifB3n75lBeLyC0gpqiAqmW8VT9ILsuAH5R5rxCLgIMHlOadshYWCkYW',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: WemanColors.onSurface),
                              ),
                            ),
                          ),
                          // Crown Badge on top
                          Positioned(
                            top: -12,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: WemanColors.neonLime,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.emoji_events_rounded,
                                  size: 14, color: WemanColors.onSurface),
                            ),
                          ),
                          // Rank 1 pin
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: WemanColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Arjun Mehta',
                        style: WemanTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: WemanColors.neonLime,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'GRANDMASTER',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: WemanColors.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '9,840 XP',
                        style: WemanTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: WemanColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Gold / Volt Pillar (Tallest)
                      Container(
                        height: 114,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              WemanColors.neonLime,
                              WemanColors.softLime.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18)),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  WemanColors.neonLime.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1',
                              style: WemanTypography.displaySmall.copyWith(
                                fontWeight: FontWeight.w900,
                                color: WemanColors.onSurface,
                                fontSize: 32,
                              ),
                            ),
                            Text(
                              'TOP GYMER',
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 9.5,
                                letterSpacing: 0.8,
                                color: WemanColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Rank 3: Bronze Pedestal (Right)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: WemanColors.surfaceContainerHigh,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBdpje1OjY-ytgLnTbNe51sK7RJaIxf49Bh3glTeVZX77iVCQOPevaXPSdZfZh2W2jtfUvKUuzzogmmiuEhtbfGcGg89MFh1fhli4BmuEU2roUb7rnBWsUTTN1RkdBhLBgOXnFbsC7P2udurhx0JYm1NIMD5S9OqE44cNY9OiRCrCPxYMuBYTPr6rw7rGG0tn0uAopTSQhqPu4XNpPTBnrciUmRQ9AsT6oVX61KfKBmZXEMQrrxJe5R',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: WemanColors.onSurface),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -4,
                            left: -2,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC48858),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Icon(Icons.military_tech_rounded,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vikram Das',
                        style: WemanTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1.5),
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: WemanColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Elite',
                          style: WemanTypography.labelSmall.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: WemanColors.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '8,890 XP',
                        style: WemanTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          color: WemanColors.primary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Bronze Pillar
                      Container(
                        height: 72,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: WemanColors.surfaceContainerHigh,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '3',
                              style: WemanTypography.headlineLarge.copyWith(
                                fontWeight: FontWeight.w900,
                                color: WemanColors.secondary,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'BRONZE',
                              style: WemanTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                                letterSpacing: 0.8,
                                color: WemanColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. CONTENDER CARD ---
  Widget _buildContenderCard(AthleteRankItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: WemanColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WemanColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '${item.rank}',
                  textAlign: TextAlign.center,
                  style: WemanTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: WemanColors.textMuted,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: WemanColors.surfaceContainerHigh,
                ),
                child: ClipOval(
                  child: Image.network(
                    item.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.person, color: WemanColors.onSurface),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: WemanTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.handle,
                        style: WemanTypography.bodySmall.copyWith(
                          color: WemanColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: WemanColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.title,
                      style: WemanTypography.labelSmall.copyWith(
                        fontSize: 9.5,
                        color: WemanColors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.xp,
                style: WemanTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  if (item.isUp) ...[
                    const Icon(Icons.arrow_upward_rounded,
                        size: 12, color: WemanColors.primary),
                    Text(
                      item.change,
                      style: WemanTypography.labelSmall.copyWith(
                        color: WemanColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ] else if (item.isDown) ...[
                    const Icon(Icons.arrow_downward_rounded,
                        size: 12, color: WemanColors.error),
                    Text(
                      item.change,
                      style: WemanTypography.labelSmall.copyWith(
                        color: WemanColors.error,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.horizontal_rule_rounded,
                        size: 12, color: WemanColors.textMuted),
                    Text(
                      item.change,
                      style: WemanTypography.labelSmall.copyWith(
                        color: WemanColors.textMuted,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 5. STICKY CURRENT-USER RANK CARD ---
  Widget _buildStickyCurrentUserCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WemanColors.inverseSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: WemanColors.neonLime, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCUeNEOq_OI8qAaqCiIcK2TOOy_G69RAJYDlG-Gh0eqh-6Rm53Q2SztEjtAPxwdZqNPsX6YlKDDi9wbIU9KnQ7IUqAcxkkujRIdNd4X-AUb5YcbgGmEGx0S6vmJtYxHvGSCmWc384c9pD4xVXDFhJjGW0mFyRZhJ9cnRvzqQ2osYmo_XiWMmRoFuqK7p-x35puCiidAeukRmzklOB1FnvIxx6od0STy_dBVOLaaUfvkOOZQhCEgce8u',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: WemanColors.neonLime,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt_rounded,
                          size: 11, color: WemanColors.onSurface),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Pavan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '@pavan.fit',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      Text(
                        '#14 National',
                        style: TextStyle(
                          color: WemanColors.neonLime,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        ' | ',
                        style: TextStyle(
                          color: Color(0x66FFFFFF),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '#2 State',
                        style: TextStyle(
                          color: WemanColors.neonLime,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '7,920 XP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.trending_up_rounded,
                      size: 14, color: WemanColors.neonLime),
                  SizedBox(width: 2),
                  Text(
                    '+2 this week',
                    style: TextStyle(
                      color: WemanColors.neonLime,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRankingsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: WemanColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About Leaderboard & Rankings',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'Rankings are illustrative demo computations that benchmark user training frequency, session completions, and consistency XP.\n\nScopes (National, State, District, Region, College) provide comparative peer group standing.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it',
                style: TextStyle(
                    color: WemanColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
