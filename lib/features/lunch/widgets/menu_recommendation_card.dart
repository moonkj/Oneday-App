import 'dart:math';
import 'package:flutter/material.dart';
import 'package:oneday/core/theme/text_styles.dart';
import 'package:oneday/data/models/time_mode.dart';
import 'package:oneday/features/home/widgets/glass_card.dart';

class MenuRecommendationCard extends StatefulWidget {
  const MenuRecommendationCard({super.key});

  @override
  State<MenuRecommendationCard> createState() => _MenuRecommendationCardState();
}

class _MenuRecommendationCardState extends State<MenuRecommendationCard>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentIndex = 0; // 0 = intro, 1~3 = menus

  late final AnimationController _arrowAnim;
  late final Animation<double> _arrowOffset;

  static const _allMenus = [
    _Menu('🍜', '김치찌개', '얼큰하고 든든한 한국의 국민 찌개'),
    _Menu('🥘', '된장찌개', '구수하고 따뜻한 전통 발효 찌개'),
    _Menu('🍱', '비빔밥', '다채로운 나물과 고추장의 조화'),
    _Menu('🥡', '냉면', '시원하고 쫄깃한 여름의 별미'),
    _Menu('🥩', '삼겹살', '불판 위의 황금빛 겉바속촉'),
    _Menu('🍛', '카레라이스', '부드럽고 깊은 인도풍 향신료'),
    _Menu('🥗', '샐러드', '가볍고 상큼하게 에너지 충전'),
    _Menu('🍔', '버거', '든든하고 빠른 점심 한 끼'),
    _Menu('🍜', '라면', '언제나 실패 없는 국민 메뉴'),
    _Menu('🍣', '초밥', '신선하고 담백한 일본식 한 끼'),
    _Menu('🍗', '치킨', '바삭하고 촉촉한 최애 메뉴'),
    _Menu('🥙', '샌드위치', '간편하고 든든한 점심 브런치'),
    _Menu('🍲', '순두부찌개', '부드럽고 칼칼한 두부의 변신'),
    _Menu('🍚', '볶음밥', '뚝딱 만들어 든든한 한 그릇'),
    _Menu('🍜', '우동', '따뜻하고 쫄깃한 일본식 면 요리'),
    _Menu('🍱', '돈가스', '바삭한 튀김과 새콤달콤 소스'),
    _Menu('🍱', '도시락', '정성 가득한 손수 만든 한 끼'),
    _Menu('🌮', '타코', '이색적이고 신선한 멕시칸 맛'),
    _Menu('🍜', '짜장면', '검은 소스와 면의 클래식 조합'),
    _Menu('🍜', '짬뽕', '얼큰하고 해산물 가득한 중화 국물'),
    _Menu('🍗', '닭갈비', '매콤달콤 볶은 닭고기의 매력'),
    _Menu('🥩', '제육볶음', '매콤한 돼지고기 한 그릇'),
    _Menu('🍳', '오므라이스', '폭신한 달걀과 케첩 소스의 만남'),
    _Menu('🍢', '떡볶이', '쫄깃하고 매콤한 길거리의 맛'),
    _Menu('🥘', '부대찌개', '햄, 소시지, 라면의 환상 조합'),
    _Menu('🍝', '파스타', '올리브오일과 향신료의 이탈리안 풍미'),
    _Menu('🍜', '쌀국수', '담백하고 깔끔한 베트남식 국물'),
    _Menu('🍱', '마파두부', '얼큰하고 부드러운 중화풍 두부'),
    _Menu('🍖', '갈비탕', '진하고 깊은 갈비 국물 한 그릇'),
    _Menu('🍜', '설렁탕', '뽀얗고 구수한 사골 국물'),
    _Menu('🥗', '콥 샐러드', '닭가슴살과 채소의 건강한 조합'),
    _Menu('🍗', '찜닭', '간장 양념의 달콤짭짤한 닭 요리'),
    _Menu('🥩', '스테이크', '특별한 날의 고급 한 끼'),
    _Menu('🍱', '연어덮밥', '신선한 연어와 밥의 깔끔한 조화'),
    _Menu('🍜', '소바', '담백하고 시원한 일본 메밀 면'),
    _Menu('🥘', '청국장', '구수하고 영양 가득한 발효 찌개'),
    _Menu('🍗', '오리구이', '담백하고 고소한 특별한 맛'),
    _Menu('🍱', '참치마요덮밥', '고소하고 간편한 자취생 레시피'),
    _Menu('🍜', '칼국수', '쫄깃한 면발과 시원한 국물'),
    _Menu('🥣', '콩나물국밥', '해장에 딱 맞는 시원한 한 그릇'),
    _Menu('🍱', '김밥', '간편하고 알록달록 영양 만점'),
    _Menu('🥗', '두부샐러드', '담백하고 건강한 두부 한 끼'),
    _Menu('🍖', '갈비구이', '진한 양념의 부드러운 갈비'),
    _Menu('🍱', '치킨덮밥', '달콤짭짤한 소스의 치킨 한 그릇'),
    _Menu('🥘', '해물뚝배기', '신선한 해산물이 가득한 뚝배기'),
    _Menu('🍜', '콩국수', '고소하고 시원한 여름 별미'),
    _Menu('🥙', '랩 샌드위치', '속 재료 가득 돌돌 만 점심'),
    _Menu('🍗', '마늘치킨', '고소한 마늘 향 가득한 치킨'),
    _Menu('🍱', '비빔국수', '새콤달콤 비빔 소스 쫄깃 면'),
    _Menu('🥘', '갈비찜', '부드럽고 달콤짭짤한 갈비 요리'),
    _Menu('🍜', '잔치국수', '담백하고 시원한 잔치 한 그릇'),
    _Menu('🥗', '시저 샐러드', '바삭한 크루통과 파마산 드레싱'),
    _Menu('🍔', '치즈버거', '진한 치즈 한 장 추가의 행복'),
    _Menu('🍱', '소고기덮밥', '부드러운 소고기와 달콤 간장 소스'),
    _Menu('🥩', '목살구이', '고소하고 쫄깃한 돼지 목살'),
    _Menu('🍜', '미소라멘', '구수한 미소 된장의 일본 라멘'),
    _Menu('🍱', '알리오올리오', '마늘과 올리브오일의 심플한 파스타'),
    _Menu('🥘', '오징어볶음', '매콤달콤 쫄깃한 오징어 요리'),
    _Menu('🍱', '낙지덮밥', '얼큰하고 쫄깃한 낙지 한 그릇'),
    _Menu('🥩', '차돌박이', '고소하고 부드러운 얇은 소고기'),
    _Menu('🍜', '돼지국밥', '구수하고 진한 돼지 뼈 국물'),
    _Menu('🥗', '그릭 샐러드', '상큼한 올리브와 페타 치즈'),
    _Menu('🍱', '참치김치볶음밥', '고소한 참치와 매콤한 김치'),
    _Menu('🍜', '만두국', '속 꽉 찬 만두와 시원한 국물'),
    _Menu('🍗', '양념치킨', '달콤매콤 소스의 대표 치킨'),
    _Menu('🥘', '두루치기', '돼지고기와 야채의 칼칼한 볶음'),
    _Menu('🍱', '쭈꾸미볶음', '쫄깃하고 매콤한 쭈꾸미 한 접시'),
    _Menu('🍜', '닭칼국수', '진한 닭 국물과 쫄깃한 면'),
    _Menu('🥙', '클럽 샌드위치', '층층이 쌓인 풍성한 샌드위치'),
    _Menu('🍳', '계란말이 정식', '폭신한 계란말이와 밥 한 그릇'),
    _Menu('🍱', '새우볶음밥', '탱글한 새우와 고소한 볶음밥'),
    _Menu('🥘', '소고기미역국', '진하고 깊은 소고기 미역 국물'),
    _Menu('🍜', '비빔냉면', '새콤매콤 고추장 소스 냉면'),
    _Menu('🥗', '닭가슴살 샐러드', '건강하고 담백한 다이어트 메뉴'),
    _Menu('🍱', '훈제연어덮밥', '스모키하고 부드러운 연어 한 그릇'),
    _Menu('🍔', '슈림프 버거', '탱글한 새우 패티와 신선한 야채'),
    _Menu('🥩', '등심 스테이크', '육즙 가득 두툼한 등심 한 점'),
    _Menu('🍜', '나가사키짬뽕', '해산물 가득한 깔끔한 국물 면'),
    _Menu('🍱', '명란젓 정식', '짭짤하고 고소한 명란과 밥'),
    _Menu('🥘', '해물순두부', '신선한 해산물과 부드러운 순두부'),
    _Menu('🍜', '해장라면', '시원하고 얼큰한 해장용 라면'),
    _Menu('🍱', '규동', '달콤짭짤한 일본식 소고기 덮밥'),
    _Menu('🥗', '스테이크 샐러드', '구운 소고기와 신선한 채소'),
    _Menu('🍳', '달걀프라이 정식', '심플하고 따뜻한 기본 밥상'),
    _Menu('🍜', '탄탄면', '고소하고 매콤한 중화 땅콩 면'),
    _Menu('🥘', '아귀찜', '매콤하고 쫄깃한 아귀 요리'),
    _Menu('🍱', '참치 정식', '담백한 참치와 반찬의 조화'),
    _Menu('🍔', '불고기버거', '달콤한 불고기 패티의 한국 버거'),
    _Menu('🥩', '돼지갈비', '달콤한 양념의 부드러운 갈비'),
    _Menu('🍜', '국밥', '뜨끈하고 든든한 국밥 한 그릇'),
    _Menu('🍱', '참깨 비빔밥', '고소한 참깨 드레싱의 건강 비빔밥'),
    _Menu('🥗', '연근조림 정식', '달콤짭짤한 연근과 반찬 한 상'),
    _Menu('🍜', '곱창전골', '진하고 구수한 곱창 국물'),
    _Menu('🥙', '불고기 랩', '달콤한 불고기를 돌돌 만 한 끼'),
    _Menu('🍱', '낙지볶음', '쫄깃하고 얼큰한 낙지 한 접시'),
    _Menu('🍳', '스크램블에그 토스트', '부드러운 에그와 바삭한 토스트'),
    _Menu('🥘', '동태찌개', '시원하고 얼큰한 동태 국물'),
    _Menu('🍜', '곰탕', '담백하고 진한 전통 소 뼈 국물'),
    _Menu('🍱', '참치전 정식', '고소하고 바삭한 참치 전 한 상'),
  ];

  late final List<_Menu> _todayMenus;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final shuffled = List<_Menu>.from(_allMenus)..shuffle(Random(now.year * 1000 + dayOfYear));
    _todayMenus = shuffled.take(3).toList();

    _arrowAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _arrowOffset = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _arrowAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _arrowAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // total pages: 1 intro + 3 menus
    final totalPages = 1 + _todayMenus.length;
    final menuIndex = _currentIndex - 1; // -1 when on intro

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                const Icon(Icons.restaurant_menu_outlined, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text('오늘의 점심 추천', style: AppTextStyles.label(TimeMode.lunch)),
                const Spacer(),
                // dots: only show for menu pages
                if (_currentIndex > 0)
                  Row(
                    children: List.generate(_todayMenus.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: i == menuIndex ? 16 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: i == menuIndex
                              ? Colors.white
                              : Colors.white.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
              ],
            ),
          ),
          // PageView
          SizedBox(
            height: 90,
            child: PageView.builder(
              controller: _controller,
              itemCount: totalPages,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                if (index == 0) return _IntroPage(arrowOffset: _arrowOffset);
                final menu = _todayMenus[index - 1];
                return _MenuPage(menu: menu, index: index - 1, total: _todayMenus.length);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final Animation<double> arrowOffset;

  const _IntroPage({required this.arrowOffset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '오늘 뭐 먹을까요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '밀어서 오늘의 메뉴 후보 확인',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: arrowOffset,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(arrowOffset.value, 0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _MenuPage extends StatelessWidget {
  final _Menu menu;
  final int index;
  final int total;

  const _MenuPage({required this.menu, required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          Text(menu.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  menu.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (index < total - 1)
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.25),
              size: 16,
            ),
        ],
      ),
    );
  }
}

class _Menu {
  final String emoji;
  final String name;
  final String description;

  const _Menu(this.emoji, this.name, this.description);
}
