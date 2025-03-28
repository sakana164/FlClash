import 'dart:ui';

import 'package:fl_clash/clash/core.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GenProfile extends StatefulWidget {
  final String profileId;

  const GenProfile({
    super.key,
    required this.profileId,
  });

  @override
  State<GenProfile> createState() => _GenProfileState();
}

class _GenProfileState extends State<GenProfile> {
  final _currentClashConfigNotifier = ValueNotifier<ClashConfigSnippet?>(null);

  @override
  void initState() {
    super.initState();
    _initCurrentClashConfig();
  }

  _initCurrentClashConfig() async {
    _currentClashConfigNotifier.value =
        await clashCore.getProfile(widget.profileId);
  }

  Widget proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "自定义",
      body: ValueListenableBuilder(
        valueListenable: _currentClashConfigNotifier,
        builder: (_, clashConfig, ___) {
          if (clashConfig == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomScrollView(
            scrollBehavior: HiddenBarScrollBehavior(),
            slivers: [
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: EdgeInsets.all(16),
              //     child: Text(
              //       '代理组',
              //       style: context.textTheme.titleMedium,
              //     ),
              //   ),
              // ),
              // SliverPadding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 16,
              //   ),
              //   sliver: SliverGrid.builder(
              //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //       maxCrossAxisExtent: 120,
              //       mainAxisExtent: 54,
              //       mainAxisSpacing: 8,
              //       crossAxisSpacing: 8,
              //     ),
              //     itemCount: clashConfig.proxyGroups.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       final group = clashConfig.proxyGroups[index];
              //       return CommonCard(
              //         type: CommonCardType.filled,
              //         onPressed: () {},
              //         child: Container(
              //           constraints: BoxConstraints.expand(),
              //           padding: EdgeInsets.symmetric(
              //             horizontal: 12,
              //             vertical: 8,
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(
              //                 group.name,
              //                 maxLines: 1,
              //                 style: context.textTheme.bodyMedium?.copyWith(
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //               Text(
              //                 group.type.name,
              //                 style: context.textTheme.bodySmall?.toLight,
              //               )
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 14,
                  ),
                  child: ListHeader(
                    title: '规则',
                    subTitle: "在原有规则基础上附加规则",
                    actions: [
                      IconButton.filledTonal(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          globalState.showCommonDialog(
                            child: AddRuleDialog(),
                          );
                        },
                        iconSize: 16,
                        padding: EdgeInsets.all(4),
                        visualDensity: VisualDensity.compact,
                      )
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                sliver: SliverReorderableList(
                  itemBuilder: (context, index) {
                    final rule = clashConfig.rule[index];
                    return Material(
                      color: Colors.transparent,
                      key: ObjectKey(rule),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: ListTile(
                          minTileHeight: 0,
                          minVerticalPadding: 0,
                          titleTextStyle: context.textTheme.bodyMedium,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          trailing: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                          title: Text(rule),
                        ),
                      ),
                    );
                  },
                  proxyDecorator: proxyDecorator,
                  itemCount: clashConfig.rule.length,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final rules = List<String>.from(clashConfig.rule);
                    final item = rules.removeAt(oldIndex);
                    rules.insert(newIndex, item);
                    _currentClashConfigNotifier.value =
                        _currentClashConfigNotifier.value?.copyWith(
                      rule: rules,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AddRuleDialog extends StatelessWidget {
  const AddRuleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: "添加规则",
      actions: [
        TextButton(
          onPressed: () {},
          child: Text("确定"),
        ),
      ],
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton.tonal(
              onPressed: () {},
              child: Text("DOMAIN"),
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "内容",
              ),
            ),
            SizedBox(
              height: 24,
            ),
            DropdownMenu(
              dropdownMenuEntries: [
                ...RuleTarget.values.map(
                  (item) => DropdownMenuEntry(
                    value: item.name,
                    label: item.name,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ListItem(
              padding: EdgeInsets.zero,
              title: Text("解析IP"),
              trailing: Radio(
                value: null,
                groupValue: null,
                onChanged: (Null value) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
