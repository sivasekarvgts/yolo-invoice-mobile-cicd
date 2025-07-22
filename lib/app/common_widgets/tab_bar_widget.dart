import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';

class TabItems {
  final Widget tab;
  final String title;
  final IconData? icon;
  final String? svg;
  final GlobalKey<NavigatorState>? navigatorkey;

  TabItems({
    required this.tab,
    this.icon,
    this.svg,
    this.navigatorkey,
    required this.title,
  });
}

class TabBarHeaderWidget extends StatefulWidget {
  const TabBarHeaderWidget({
    super.key,
    required this.tabController,
    required this.tabs,
    this.color,
    this.height,
    this.activeColor,
    this.inactiveColor,
  });

  final TabController? tabController;
  final List<TabItems> tabs;
  final Color? color;
  final double? height;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  State<TabBarHeaderWidget> createState() => _TabBarHeaderWidgetState();
}

class _TabBarHeaderWidgetState extends State<TabBarHeaderWidget> {
  void _handleTabChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.tabController?.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(covariant TabBarHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabController != widget.tabController) {
      oldWidget.tabController?.removeListener(_handleTabChange);
      widget.tabController?.addListener(_handleTabChange);
    }
  }

  @override
  void dispose() {
    widget.tabController?.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.activeColor ?? AppColors.primary;
    final Color inactiveColor = widget.inactiveColor ?? AppColors.greyColor;
    return Container(
      color: widget.color,
      // height: widget.height ?? .h,
      child: TabBar(
        controller: widget.tabController,
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: activeColor,
        indicatorWeight: 3,
        labelPadding: EdgeInsets.zero,
        labelStyle: AppTextStyle.titleMedium.copyWith(
          color: AppColors.primary,
          fontWeight: fontWeight600,fontFamily: "Manrope"
        ),
        unselectedLabelStyle: AppTextStyle.titleMedium.copyWith(
          color: AppColors.greyColor,
          fontWeight: fontWeight600,fontFamily: "Manrope"
        ),
        tabs: List.generate(widget.tabs.length, (index) {
          final tabItem = widget.tabs[index];
          final bool isSelected = widget.tabController?.index == index;
          final Color iconColor = isSelected ? activeColor : inactiveColor;
          final TextStyle labelStyle = AppTextStyle.titleMedium.copyWith(
            color: isSelected ? activeColor : inactiveColor,
            fontWeight: fontWeight600,
          );

          return Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (tabItem.svg != null)
                  SvgPicture.asset(
                    tabItem.svg!,
                    height: 16,
                    width: 16,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                if (tabItem.svg != null && tabItem.icon != null)
                  const SizedBox(width: 4),
                if (tabItem.icon != null)
                  Icon(
                    tabItem.icon,
                    color: iconColor,
                    size: 13,
                  ),
                if ((tabItem.svg != null || tabItem.icon != null))
                  const SizedBox(width: 6),
                Text(tabItem.title, style: labelStyle),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class TabBarHeaderWidgetV2 extends StatefulWidget {
  const TabBarHeaderWidgetV2({
    super.key,
    required this.tabController,
    required this.tabs,
    this.color,
    this.height,
  });

  final TabController? tabController;
  final List<TabItems> tabs;
  final Color? color;
  final double? height;

  @override
  State<TabBarHeaderWidgetV2> createState() => _TabBarHeaderWidgetV2State();
}

class _TabBarHeaderWidgetV2State extends State<TabBarHeaderWidgetV2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: widget.height ?? 38.h,
            child: TabBar(
              controller: widget.tabController,
              isScrollable: true,
              indicator: BoxDecoration(),
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.zero,
              labelStyle: AppTextStyle.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: fontWeight500,fontFamily: "Manrope"
              ),
              onTap: (v) {
                setState(() {});
              },
              unselectedLabelStyle: AppTextStyle.labelSmall.copyWith(
                color: AppColors.greyColor,
                fontWeight: fontWeight500,fontFamily: "Manrope"
              ),
              tabs: widget.tabs.map((e) {
                final index = widget.tabs.indexOf(e);
                final isSelected = widget.tabController?.index == index;

                final TextStyle labelStyle = AppTextStyle.titleSmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.greyColor,
                  fontWeight: fontWeight500,
                );


                return Tab(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey),
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (e.icon != null)
                          Icon(
                            e.icon,
                            size: 14,
                          ),
                        if (e.icon != null) const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Center(child: Text(e.title,style: labelStyle,)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
        // Divider(height: 0, color: AppColors.greyDivider, thickness: 1),
      ],
    );
  }
}

class TabBarBodyWidget extends StatelessWidget {
  const TabBarBodyWidget({
    super.key,
    required this.tabController,
    required this.tabs,
    this.needScroll = true,
  });

  final TabController? tabController;
  final List<TabItems> tabs;
  final bool needScroll;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: needScroll ? null : const NeverScrollableScrollPhysics(),
      children: tabs.map((e) => e.tab).toList(),
    );
  }
}
