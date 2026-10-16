import 'smartisan_material_theme.dart';
import 'smartisan_palette.dart';
import 'smartisan_widgets.dart';

import 'package:flutter/material.dart';

/// Standalone visual playground. The coordinator can expose it on any route.
class SmartisanGalleryPage extends StatefulWidget {
  const SmartisanGalleryPage({super.key});

  @override
  State<SmartisanGalleryPage> createState() => _SmartisanGalleryPageState();
}

class _SmartisanGalleryPageState extends State<SmartisanGalleryPage> {
  bool? _dark;
  bool _switch = true;
  double _slider = .6;
  int _segment = 0;
  int _tab = 0;
  int _nav = 0;
  int _radio = 0;
  final _wheel = [1, 1];
  final _checked = <int>{0};
  final _alarms = ['07:30', '09:00'];

  void _setSwitch(bool value) => setState(() => _switch = value);
  void _setSlider(double value) => setState(() => _slider = value);

  @override
  Widget build(BuildContext context) {
    final dark = _dark ?? Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: SmartisanMaterialTheme.build(isDark: dark),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Smartisan 组件'),
            actions: [
              IconButton(
                tooltip: dark ? '切换亮色' : '切换暗色',
                icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => setState(() => _dark = !dark),
              ),
            ],
          ),
          body: SPage(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _GallerySection(
                    title: '标题栏与图标',
                    children: [
                      SAppBar(
                        title: '设置',
                        shadow: true,
                        onBack: () {},
                        actions: [
                          SIconButton(icon: SIcons.menuAdd, onTap: () {}),
                        ],
                      ),
                      SAppBar(title: 'Smartisan', red: true, onBack: () {}),
                      Wrap(
                        spacing: 18,
                        runSpacing: 12,
                        children: [
                          for (final icon in [
                            SIcons.back,
                            SIcons.confirm,
                            SIcons.close,
                            SIcons.closeThin,
                            SIcons.setting,
                            SIcons.search,
                            SIcons.star,
                            SIcons.starFill,
                            SIcons.chevronRight,
                            SIcons.chevronUp,
                            SIcons.chevronDown,
                            SIcons.play,
                            SIcons.playing,
                            SIcons.playlist,
                            SIcons.more,
                            SIcons.mute,
                            SIcons.volume,
                            SIcons.add,
                            SIcons.menuAdd,
                            SIcons.likeOutlined,
                            SIcons.list,
                            SIcons.gameFilled,
                            SIcons.check,
                          ])
                            SIcon(icon),
                          const SmartisanChevron(),
                          const SRedBadge.check(),
                          const SRedBadge.delete(),
                          SIconButtonPlain(icon: SIcons.confirm, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                  _GallerySection(
                    title: '按钮',
                    children: [
                      SButton('主按钮', onPressed: () {}),
                      const SButton('禁用主按钮'),
                      SButton(
                        '弹窗按钮',
                        kind: SButtonKind.sheet,
                        onPressed: () {},
                      ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SButton(
                            '小按钮',
                            kind: SButtonKind.small,
                            onPressed: () {},
                          ),
                          const SButton('禁用', kind: SButtonKind.small),
                          SButton(
                            '描边',
                            kind: SButtonKind.outline,
                            onPressed: () {},
                          ),
                          SButton(
                            '文字按钮',
                            kind: SButtonKind.text,
                            onPressed: () {},
                          ),
                          SRoundButton(onTap: () {}),
                          SRoundButton(small: true, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                  _GallerySection(
                    title: '分组列表',
                    children: [
                      SListGroup(
                        header: '系统设置',
                        description: '长按列表行可查看按下状态',
                        children: [
                          SListTile(
                            title: '声音',
                            subtitle: '铃声和音量',
                            leading: SIcons.volume,
                            detail: '默认',
                            onTap: () {},
                          ),
                          SListTile(
                            title: '无线网络',
                            leading: SIcons.setting,
                            trailing: SSwitch(
                              value: _switch,
                              onChanged: _setSwitch,
                            ),
                          ),
                          SListTile(
                            title: '禁用设置',
                            leading: SIcons.setting,
                            enabled: false,
                            onTap: () {},
                          ),
                          const SListTileSimple(title: '简单列表', detail: '详情'),
                        ],
                      ),
                    ],
                  ),
                  SmartisanListSection(
                    header: '列表适配器',
                    footer: '卡片与缩进分隔线',
                    children: [
                      ListTile(
                        title: const Text('SmartisanSwitch'),
                        trailing: SmartisanSwitch(
                          value: _switch,
                          onChanged: _setSwitch,
                        ),
                      ),
                      const ListTile(
                        title: Text('更多设置'),
                        trailing: SmartisanChevron(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _GallerySection(
                    title: '开关、滑块、单选',
                    children: [
                      Wrap(
                        spacing: 24,
                        runSpacing: 12,
                        children: [
                          SSwitch(value: _switch, onChanged: _setSwitch),
                          SSwitch(
                            value: !_switch,
                            onChanged: (v) => _setSwitch(!v),
                          ),
                          const SmartisanSwitch(value: true, onChanged: null),
                          const SmartisanSwitch(value: false, onChanged: null),
                          SRadio(
                            selected: _radio == 0,
                            onTap: () => setState(() => _radio = 0),
                          ),
                          SRadio(
                            selected: _radio == 1,
                            onTap: () => setState(() => _radio = 1),
                          ),
                        ],
                      ),
                      SSlider(value: _slider, onChanged: _setSlider),
                      const SSlider(value: .4, onChanged: null),
                      SSliderRow(value: _slider, onChanged: _setSlider),
                      SSliderCard(value: _slider, onChanged: _setSlider),
                      SListGroup(
                        children: [
                          for (var i = 0; i < 2; i++)
                            SRadioTile(
                              label: '选项 ${i + 1}',
                              selected: _radio == i,
                              onTap: () => setState(() => _radio = i),
                            ),
                        ],
                      ),
                    ],
                  ),
                  _GallerySection(
                    title: '标签与导航',
                    children: [
                      SSegmented(
                        labels: const ['全部', '关注', '收藏'],
                        selected: _segment,
                        onChanged: (v) => setState(() => _segment = v),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: STabs(
                          labels: const ['视频', '动态', '专栏'],
                          selected: _tab,
                          onChanged: (v) => setState(() => _tab = v),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final colors in [
                            SChipColors.white,
                            SChipColors.yellow,
                            SChipColors.blue,
                            SChipColors.red,
                            SChipColors.grey,
                          ])
                            SChip(
                              '标签',
                              colors: colors,
                              leading: SIcons.star,
                              trailing: true,
                              onTap: () {},
                            ),
                        ],
                      ),
                      SBottomNav(
                        items: [
                          SNavItem('首页', SIcons.list),
                          SNavItem('收藏', SIcons.star),
                          SNavItem('设置', SIcons.setting),
                        ],
                        currentIndex: _nav,
                        onTap: (v) => setState(() => _nav = v),
                      ),
                    ],
                  ),
                  const _GallerySection(
                    title: '输入与搜索',
                    children: [
                      STextField(hint: '输入内容'),
                      SSearchBar(),
                    ],
                  ),
                  _GallerySection(
                    title: '对话框、菜单与提示',
                    children: [
                      SDialog(
                        title: '对话框',
                        body: const Text('正文与操作栏跟随当前主题。'),
                        actions: [
                          SDialogButton('取消', onTap: () {}),
                          SDialogButton('确定', primary: true, onTap: () {}),
                        ],
                      ),
                      SPopupMenu(
                        items: [
                          SMenuItem('收藏', icon: SIcons.star, onTap: () {}),
                          SMenuItem('搜索', icon: SIcons.search, onTap: () {}),
                        ],
                      ),
                      const Center(child: SToast('网络异常，请稍后重试')),
                      SButton(
                        '显示对话框',
                        kind: SButtonKind.sheet,
                        onPressed: () => showSDialog<void>(
                          context,
                          title: '提示',
                          body: const Text('这是 Smartisan 对话框。'),
                          actions: const [
                            SDialogAction('取消'),
                            SDialogAction('确定', primary: true),
                          ],
                        ),
                      ),
                      SButton(
                        '显示简单对话框',
                        kind: SButtonKind.sheet,
                        onPressed: () =>
                            showSSimpleDialog(context, '点击遮罩关闭对话框。'),
                      ),
                      SButton(
                        '显示 Toast',
                        kind: SButtonKind.sheet,
                        onPressed: () => showSToast(context, '已完成'),
                      ),
                      SButton(
                        '显示底部弹窗',
                        kind: SButtonKind.sheet,
                        onPressed: () => showSBottomSheet<void>(
                          context,
                          title: '选择操作',
                          options: const [
                            SDialogAction('收藏'),
                            SDialogAction('取消'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _GallerySection(
                    title: '底部弹窗与滚轮',
                    children: [
                      SSheetHeader(
                        title: '选择时间',
                        onClose: () {},
                        onConfirm: () {},
                      ),
                      SWheelPicker(
                        columns: const [
                          ['今天', '明天', '后天'],
                          ['上午', '下午', '晚上'],
                        ],
                        selected: _wheel,
                        onChanged: (c, i) => setState(() => _wheel[c] = i),
                      ),
                    ],
                  ),
                  _GallerySection(
                    title: '交互：右滑删除、多选、空状态、转场',
                    children: [
                      SListGroup(
                        children: [
                          for (final a in _alarms)
                            SSwipeRow(
                              key: ValueKey(a),
                              actions: SRoundEditButton.remove(
                                onTap: () => setState(() => _alarms.remove(a)),
                              ),
                              child: SListTile(
                                title: a,
                                subtitle: '向右滑动可删除',
                                trailing: SSwitch(
                                  value: true,
                                  onChanged: (_) {},
                                ),
                              ),
                            ),
                        ],
                      ),
                      SListGroup(
                        children: [
                          for (var i = 0; i < 3; i++)
                            SListTile(
                              title: '多选行 ${i + 1}',
                              selected: _checked.contains(i),
                              leadingWidget: SCheck(
                                value: _checked.contains(i),
                                onChanged: (v) => setState(
                                  () =>
                                      v ? _checked.add(i) : _checked.remove(i),
                                ),
                              ),
                              onTap: () => setState(
                                () => _checked.contains(i)
                                    ? _checked.remove(i)
                                    : _checked.add(i),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SButton(
                              '横推',
                              kind: SButtonKind.sheet,
                              onPressed: () => Navigator.of(context).push(
                                SPageRoute(
                                  builder: (_) => Scaffold(
                                    appBar: SAppBar(
                                      title: '详情',
                                      shadow: true,
                                      onBack: () => Navigator.of(context).pop(),
                                    ),
                                    body: const SEmptyState(
                                      title: '还没有内容',
                                      description: '新页面先空白滑入，内容在最后 40% 淡入',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SButton(
                              '全屏页上推',
                              kind: SButtonKind.sheet,
                              onPressed: () => Navigator.of(context).push(
                                SModalPageRoute(
                                  builder: (ctx) => Scaffold(
                                    appBar: SAppBar(
                                      title: '新建',
                                      onBack: () => Navigator.of(ctx).pop(),
                                    ),
                                    body: const SEmptyState(
                                      title: '从底部升起 300ms',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SButton(
                        '清除全部记录',
                        kind: SButtonKind.danger,
                        onPressed: () => showSBottomSheet<int>(
                          context,
                          title: '清除后无法恢复',
                          options: const [
                            SDialogAction(
                              '清除全部记录',
                              value: 1,
                              destructive: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _GallerySection(
                    title: '基础表面与按压',
                    children: [
                      SPage(
                        textured: true,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            '纹理页面',
                            style: TextStyle(color: context.sp.title),
                          ),
                        ),
                      ),
                      SPressable(
                        onTap: () {},
                        builder: (context, pressed) => ColoredBox(
                          color: pressed
                              ? context.sp.cardPressed
                              : context.sp.card,
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('按住查看表面颜色'),
                          ),
                        ),
                      ),
                      const SDivider(indent: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: SText.sectionHeader.copyWith(color: context.sp.subtitle),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          children[i],
        ],
      ],
    ),
  );
}
