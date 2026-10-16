# 交互、动效与系统规范（Smartisan OS 框架层）

Figma Kit 只画了静态组件。这份文档补上**系统层面**的东西：按压时序、转场、手势、手感，以及框架里的官方间距、字号和文字色。
网页实现在 `assets/smartisan.css` 的 "framework layer" 一节和 `assets/smartisan.js`，Flutter 实现在 `assets/flutter/smartisan_motion.dart` 和 `smartisan_interaction.dart`。

## 来源

| 标记 | 来源 |
|---|---|
| **[FW]** | Smartisan OS 8 框架资源包 `smartisanos_11.apk`（资源表里的 anim / interpolator / dimen / color）和 `smartisanos.jar` 里的类名。取自社区项目 [People-11/SmartisanOS_APP_Port](https://github.com/People-11/SmartisanOS_APP_Port) 附带的文件，用 Android SDK 的 `aapt2 dump` 读出 |
| **[Music]** | [Mangi-11/SmartisanMusic-Revived](https://github.com/Mangi-11/SmartisanMusic-Revived)：锤子音乐 8.1.0 的 Compose 1:1 重写，作者对照原版 APK 和便签 7.3.1 校准过 |
| **[Weather]** | [Mangi-11/SmartisanWeather-Revived](https://github.com/Mangi-11/SmartisanWeather-Revived)：锤子天气 8.1.3 的重写 |
| **[Clock]** | [Mangi-11/SmartisanClock-Revived](https://github.com/Mangi-11/SmartisanClock-Revived)：坚果 R2 原厂时钟 7.1.1 的重写 |
| **[R2]** | 本 skill 在真机 Smartisan R2（OS 8.5.3）上的截图和 60fps 录屏，见 `device-behavior.md` |

这里只摘录数值和行为描述，没有复制这些项目的代码或位图。几个来源不一致时，以 [R2] 真机为准，其次是 [FW]。

## 1. 官方尺寸体系 [FW]

### 6dp 网格
框架的间距几乎都是 6 的倍数，名字也是按用途起的：

| dp | 框架资源名 | 用途 |
|---|---|---|
| 6 | `small_space_height`、`bar_margin_edge` | 标题栏图标离屏幕边、按钮组间隙 |
| 12 | `medium_space_height`、`list_item_left_right_margin`、`title_bar_margin_view` | 卡片左右边距、标题栏图标之间 |
| 18 | `semi_large_space_height`、`menu_dialog_horizontal_distance`、`flexible_space` | 底部菜单左右边距和按钮间距、对话框正文左右 |
| 24 | `large_space_or_checkbox_height`、`menu_dialog_btn_margin_edge` | 底部菜单按钮到底边、勾选框 |
| 30 | `small_btn_or_section_titlebar_height`、`list_section_title_height` | 小按钮、分区标题条 |
| 36 | `avatar_or_large_icon_height`、`standard_icon_size` | 头像、标题栏图标的触摸区 |
| 48 | `titlebar_height`、`secondary_bar_height`、`samrtisan_button_fixed_height` | 标题栏、二级栏、底部菜单按钮 |
| 54 | `smartisan_bottom_bar_height`、`large_btn_or_tab_height` | 底部导航、大按钮 |
| 60 | `list_item_height` | 列表行 |

"alt" 档：8 / 10 / 16 / 26（`small_space_alt_height` 等），用在需要微调的地方。
CSS 变量：`--s-space-1`（6）…`--s-space-10`（60）。

其它常用值：`list_item_vertical_gap` 14（卡片之间，和 [R2] 实测一致）· `title_bar_shadow_height` 14 · `bottom_bar_shadow_height` 11 ·
`menu_list_height` 44 · `popup_list_menu_default_width` 220 · `popup_list_menu_item_height` 44 · `dialog_min_height` 192 / `max` 480 ·
`bottom_sheet_max_height` 360 · `toast_y_offset` 64（Toast 离底边）· `letters_bar_width` 40 · `chips_normal_height` 30 / `large` 36 ·
`list_item_bg_corner` 10 · `title_bar_center_limite` 114（两侧按钮太宽时标题让位）。

### 字号（sp）与字体缩放
`large` 20 · `semi_large` 17 · `medium` 16 · `standard_reading` 15 · `semi_small` 13.5 · `small` 12 · `extra_small` 10 · `ultra_small` 8。

[R2] 的系统字体缩放是 **0.91**（`settings get system font_scale`）。Kit 的 px 字号基本就是框架 sp × 0.91：
标题栏 20 → 18（Kit 对话框标题 18）、17 → 15.5（Kit 栏标题 16）、15 → 13.7（Kit 14）、13.5 → 12.3（Kit 12）。
所以网页直接用 Kit 的 px 就对；在 Android 原生里用 sp 时记得这层缩放。

### 文字色是"带透明度的黑"
| 框架资源 | 值 | 在白底上等于 | 用途 |
|---|---|---|---|
| `primary_text_color` | `#cc000000` | `#333` | 正文、列表标题 |
| `title_or_btn_text_color` | `#99000000` | `#666` | 标题栏标题、按钮字、底部菜单标题 |
| `setting_item_summary_text_color` | `#80000000` | `#7f7f7f` | 副标题、说明 |
| `secondary_text_color` | `#62000000` | `#9d9d9d` | 次要信息 |
| `input_hint` / `list_section_title_text_color` | `#4c000000` | `#b3b3b3` | 占位符、分区标题 |
| `disabled_text_color` | `#26000000` | `#d9d9d9` | 禁用、空状态大标题 |
| `list_divider_color` | `#14000000` | `#ebebeb` | 列表分隔线 |

Kit 的灰阶正是这些透明黑叠在白底上的结果。放在条纹底、浅蓝选中行这类非白底上时，用透明黑（`--s-text-primary` 等）颜色才对。

其它框架色：链接 `#5079d9` · 警告 / 失败 `#d44d44` · 成功 `#79ad31` · 绿色按钮 `#97cc4e` · 收藏星 `#ffdd33` ·
列表按下 `#5e88eb`（`list_item_pressed`，Kit 写 `#5985eb`，两者差 1–2 级）· 多选行 `#e5eeff`[Music] · 分区条底 `#f5f5f5`。

## 2. 按压

| 规则 | 数值 | 来源 |
|---|---|---|
| 按下即变色，没有渐变动画，没有水波纹 | — | [R2] |
| 快速点击时，按下态至少保留 | **64ms**（`ViewConfiguration.getPressedStateDuration`） | [Music] |
| 列表行要等过了"点击超时"才显示按下 | **100ms**（tap timeout），手指一动开始滚动就立即取消 | Android ListView；[R2] "快速点击时蓝色只闪一两帧" |
| 列表行按下 | 整行 `#5e88eb`，文字、图标、`>` 全变白 | [FW] [R2] |
| 标题栏图标按下 | 图标变深（实测笔画最深处 `#7c` → `#58`），并**弹性放大到 1.33 倍**：约 120ms 冲到 1.39，再落回 1.33，全程约 220ms；松手约 130ms 缩到 0.95 再弹回原大。没有背景 | [FW] `setBarIconScaleTouchListener` / `playBarIconScaleAnim`；[R2] 录屏逐帧（44px → 61px → 59px） |
| 点击音 | 系统点击音（随系统设置） | [Music] `playSoundEffect(CLICK)` |

网页：`smartisan.js` 接管 `.is-pressed`（根元素加 `s-js`），列表行就不再用 `:active`，滚动时不会闪蓝。
Flutter：`SPressable(delayed: true)` 用于列表行；`SListTile` 已默认开启。

## 3. 转场

| 场景 | 动作 | 时长 / 曲线 | 来源 |
|---|---|---|---|
| 层级推入 | 新页从右侧滑入，先是空白页（页面底色 + 左缘淡阴影），内容在最后 40% 淡入；下面的页向左移约 1/3 并变暗 | 300ms，smooth `(1 − cos πt)/2` | [R2] [Music] |
| 层级返回 | 镜像 | ≈270ms，decelerate | [R2] |
| 固定标题栏（便签、音乐的二级页） | 标题栏不动：旧标题和图标 0–150ms 淡出，新标题 150–300ms 淡入；返回箭头延迟 100ms，150ms 淡入，同时 200ms 从右侧滑入（距离 = 图标宽 + 两侧边距）；返回时箭头 150ms 淡出、300ms 右移 | 见左 | [Music]（对照便签 7.3.1 `IActionBar.List2Detail`） |
| 全屏页（设置、编辑器、搜索、"新建"） | 从底部升起，下面的页不动；关闭时向下滑出到 109% | 300ms，decelerate cubic `1 − (1 − t)³` | [FW] `pop_up_in` / `slide_down_out` / `fake_anim`；[Weather] [Clock] |
| 居中对话框 | 遮罩加深到 60%；卡片从约 0.88 弹到原大并淡入，比遮罩快得多；关闭时卡片先淡出、遮罩随后褪去 | 卡片进 ≈120ms decelerate，遮罩 ≈200ms；卡片出 ≈100ms，遮罩 ≈200ms | [R2] 录屏（说明弹窗和"强行停止"确认框）；[Clock] 用 0.9 / 300ms，[Weather] 用"上移 8% + 淡入 220ms"，都比真机慢 |
| 底部菜单（MenuDialog / 底部弹窗） | 从底部滑入，遮罩独立淡入 | 进 300ms decelerate，出 250ms accelerate | [FW] `bhm_dialog_in`；[Clock] |
| 弹出菜单（popup） | 自下而上 + 透明度 0.5 → 1 | 进 150ms，出 100ms | [FW] `popup_enter` / `popup_exit` |
| 遮罩 | 0.6 黑（Kit 也是 60%）；复刻版用 0.54 | — | [R2] 两个对话框录屏都是 0.6；[Music] [Clock] |
| 底部 Tab 切换 | 页面之间没有共同主体时（应用商店、音乐）立即切换，没有过渡；有共同主体时（时钟）走"组件编排"，见第 5 节 | — | [R2] |
| 列表加载 | 网格逐项淡入（每项 300ms、间隔 40ms）；切回不重播 | — | [Music] |

框架自带的插值器只有这几类：`decelerate_quad/cubic/quint`、`accelerate_decelerate`，以及一整套 `smartisan_{quad,cubic,quart,quint,sine,circ,back}_{in,out,in_out}` [FW]。
CSS 变量：`--s-ease-smooth`、`--s-ease-decel`、`--s-ease-decel-cubic`、`--s-ease-accel`、`--s-ease-spring`；Flutter：`SMotion.*`。

## 4. 手势

### 开关（SwitchEx）[Music] [Clock]
- 点一下切换；也可以按住拇指拖动，松手时停在离得近的一侧。
- 判定：手指移动超过触摸阈值（8dp）**或**按住超过 300ms → 按拇指位置决定；否则当作点击，直接切换。
- 归位是**线性**的，不是缓动曲线。[R2] 录屏：满程（约 32dp）只用 4 帧，≈70ms；复刻版按 350dp/s 算是 84ms，略慢。
- 按下时拨钮和外框变成"按下"图，松手后按下阴影 200ms 淡出。
- 值改变时有一次轻触觉反馈（`VIRTUAL_KEY`）；禁用时整体 75% 不透明度。

### 列表行滑动删除 [Music] [Clock] [R2]
- **向右滑**：行向右移动，从左侧露出操作托盘（删除按钮）。不是 iOS 的向左滑。
- 位移跟手到托盘宽度为止，再往外走以 1/5 的速度（[Clock]，最远 360dp；[Music] 用 1/7）。
- 松手时滑过托盘宽度的 1/4 就展开，否则收回；展开 150ms、超过托盘后回弹 200ms、收回 200ms，曲线 smooth。
- 同一时间只有一行展开；点别处会先把它收起，**这次点击被吃掉**，不会触发别的操作。
- 删除：行继续滑出，然后高度在 200ms 内收拢。

### 回弹（橡皮筋）[Weather] [R2]
- 到顶 / 到底继续拉，露出底纹，没有 Android 的光晕或拉伸。
- 位移 `offset = max × (1 − 100^(−dragged / R))`，其中 `dragged` 是手指位移的一半，`max` 顶部 250dp、底部 150dp，`R` 取半屏和列表高度中较大的那个；位移永远不超过手指走的距离。
- 松手后 250ms 粘滞曲线（Android ViscousFluid）弹回。

### 滚轮选择器 [Clock] [FW]
- 一列显示 5 行，行是平的（不是 3D 滚筒），上下边缘各有 1/6 高度的渐隐。
- 越靠近中间的选中带，字号越大（16 → 18）、颜色越深（`#b3b3b5` → `#55585c`，[Clock] 闹钟用蓝 `#5079d9`），是连续插值，不是跳变。
- 每跨过一格响一下"嗒"并给一次 `CLOCK_TICK` 触觉。
- 松手吸附 200ms decelerate(1.5)；甩动按速度惯性滑行再吸附。时间框架常量：`time_picker_wheel_item_count` 3、`time_picker_text_size` 16 / 高亮 18。

### 字母索引条 QuickBar [Music] [FW]
- 长列表右侧一条 A–Z + # 的竖条，宽约 34–40dp，字母 10dp 粗体 `#9a9a9a`。
- 平时只有字母；手指按上去才出现浅色底和左侧阴影，所在字母变强调色，并在左侧显示一个大的字母气泡。
- 按下和滑动都会立即跳转；向左拖可以拉出一个 3 列的字母网格（200ms smooth），本 skill 只实现了竖条。

### 其它
- 按钮 / 标题栏图标的点击区至少 36dp（`standard_icon_size`）。
- 秒表、计时器这类"机械"控件还有按键位移、指针回弹、刻度阻尼等专属手感，见 [Clock] 的 `docs/clock-7.1.1-baseline.md`；做拟物控件时可以参考，但它们不是通用组件。

## 5. 组件编排：主体不动，部件分层过渡

这是锤子美学里最有辨识度的一条：**切换的是页面，视觉主体却留在原地，变化由它自己的部件完成**，每个部件的动作符合它的物理身份。
不做整页滑动、整页淡入淡出，也不让主体"消失再出现"。

### 实测：锤子时钟 7.1.1 切换底部 Tab（[R2] 录屏，2026-10-17）

| 切换 | 过程 |
|---|---|
| 世界时钟 → 闹钟 | 表盘不动。0–260ms：三根指针**顺着原来的方向**加速转走并淡出，下方文字淡出。约 400ms 起：指针从当前时间**之前**追上来，时针、分针、秒针各自用 0.7 / 0.9 / 1.0s 就位（越细的针越晚停）；两只铃耳从斜后方滑回并淡入（700ms 减速）；"无闹钟"淡入 |
| 闹钟 → 世界时钟 | 铃耳收回淡出，指针转走；随后指针追回，"本地时间"淡入 |
| 世界时钟 → 秒表 | 指针转走后，深色表盘**原地**渐变成白色秒表盘（大小、位置不变）；顶部旋钮先弹出，两侧按键晚约 120ms 弹出，都带一点过冲；红色计时数字淡入 |

[Clock] 复刻版从原版代码里读出的常量与此一致：指针入场 700 / 900 / 1000ms，起点分别是目标前 2 小时 / 15 分钟 / 20 秒；离场 300ms，继续顺转 1 小时 / 10 分钟 / 15 秒；
铃耳 700ms `DecelerateInterpolator`，从对角偏移处归位；秒表中键延迟 130ms、400ms 过冲，两侧延迟 250ms、430 / 450ms 过冲。
同一主体也用来反馈状态：新增闹钟改变"下一个闹钟"时，闹钟指针用 400ms 走最短路径到新位置；秒针每秒先越过目标约 0.15 秒，再 50–100ms 回正。

### 规则（推广到任何界面）

1. **找出页面之间共同的视觉主体**（表盘、仪表、封面、卡片、头像、进度环），切换时它不动，只换"部件层"。
2. **离场快、入场慢**：旧部件约 300ms 加速离开，而且**顺着自己原来的运动方向**离开（指针继续往前转、列表项继续往外走），不要倒放。
3. **入场分层错开**：每个部件有自己的时长和延迟，越轻、越细的部件越晚停（0.7 / 0.9 / 1.0s；按键 130 / 250ms 延迟）；总时长控制在 1s 左右，主体和文字在前 400ms 内已经可读。
4. **动作符合部件的物理身份**：指针只会往前追，不会倒转；附属件（铃耳、按键）从被遮挡的位置滑出或弹出，带轻微过冲；面板换皮肤用原地渐变，不缩放。
5. **状态变化也用同一个主体反馈**：数值变了就让指针、进度环、数字自己走过去（几百毫秒、最短路径），不要整块重绘或闪一下。
6. **随时可打断**：新的切换开始时，从当前状态继续，不跳回起点。

实现：网页用 `.s-swap` + `.s-swap__panel` + `[data-s-part]`（`smartisan.js` 的 `data-s-show` / `Smartisan.show()`），部件上用 `--from-x / --from-y / --from-r / --from-s`、`--to-r`、`--d`、`--delay` 描述各自的动作，`data-s-part="pop"` 带过冲；
Flutter 用 `SPartSwitcher`（旧部件层 300ms 离场，可带 `exitTurns` 继续旋转）包住部件层，部件用 `SPartEntrance(duration:, delay:, fromTurns:, fromOffset:, fromScale:)`，主体放在 `SPartSwitcher` 外面。示例见 `demo.html` 的 Interaction 板（时钟三页）。

## 6. 版式与元素选取

- **标题栏**：左右两组按钮各自贴边（边距 6dp），图标槽 36dp、间隔 12dp；标题按两侧较宽一组**对称**居中，两侧太宽时标题直接隐藏（`title_bar_center_limite` 114dp）。标题粗体 `#99000000`，框架用的是"假粗体"（`Paint.setFakeBoldText`），所以笔画比真粗体略细。栏下方是 14dp 淡阴影，没有细线。
- **底部菜单（MenuDialog）**：标题条 48dp（13.5sp 粗体 `#99000000`，最多两行，右侧 × 关闭；有确认操作时左 ×、右 ✓），下面 1px `#e2e2e2`；正文 `#f5f5f5`，左右 18、上 18、下 24；按钮 48dp、17sp 粗体、间距 18；危险操作用红色长按钮、白字。CSS：`.s-sheet` + `.s-btn--sheet.s-btn--danger`。
- **编辑型对话框**（[Clock] `SmartisanModalDialog`）：标题 48dp、18sp 粗体；内容白底；底部两个 48dp 按钮，取消 `#898989`、确认 `#5c89f2`（按下 `#3d70ef`），1px `#e8e8e8` 分隔；打开 300ms 后自动弹出键盘。
- **空状态**：120dp 的浅灰大图形（常见是一个粗圆环）+ 粗体浅灰标题 + 更浅的一行说明，左右各留 60dp；需要时下面放一个圆形或长按钮。CSS `.s-empty`，Flutter `SEmptyState`。
- **分区标题条**：30dp 高、`#f5f5f5` 底、左 12dp、小号灰字；用在通栏列表（联系人、文件）里，不和卡片式分组混用。CSS `.s-section-title`，Flutter `SSectionTitle`。
- **多选**：进入编辑态后，行首出现圆形勾选（关：细灰圈；开：蓝色实心圆 + 白勾；删除场景用红色），选中行整行浅蓝 `#e5eeff`，文字颜色不变。普通点击**不**留下常驻选中态。CSS `.s-check`、`.s-list-item[aria-selected=true]`；Flutter `SCheck`、`SListTile(selected:)`。
- **增删按钮**：编辑列表里的绿色圆形 + 和红色圆形 −（世界时钟、快捷开关编辑）。CSS `.s-round-add` / `.s-round-remove`；Flutter `SRoundEditButton`。
- **一屏一个主操作**：系统应用里蓝色长按钮或红色危险按钮一屏通常只出现一个；其它操作是白色按钮或列表行。
- **暗色**：Smartisan OS 8 没有暗色模式。社区重写版的暗色板（页面 `#25282d`、标题栏 `#292c31`、卡片 `#34373c`）是作者自己设计的，可以参考，但要向用户说明不是官方的 [Music] [Weather]。

## 7. 真机核对记录（[R2]，2026-10-17）

用 adb 在 Smartisan R2（OS 8.5.3）上录屏、逐帧测量，结果和上面的表一致的就不再重复：

| 项目 | 做法 | 结果 |
|---|---|---|
| 标题栏图标 | 设置页按住搜索图标 | 44px → 峰值 61px（1.39）→ 稳定 59px（1.34）；松手 → 42px（0.95）→ 44px |
| 开关 | 拨动"定位服务"再拨回（已恢复原状态） | 拇指满程 4 帧（≈67ms），两个方向都一样 |
| 说明弹窗 | 点"飞行模式"旁的 ⓘ（Kit 的 Simple Dialog） | 卡片首帧已是 0.987 倍、约 80ms 到原大；遮罩约 200ms 到 0.6 |
| 确认对话框 | 应用信息页"强行停止"，然后点"取消" | 卡片首帧 0.886 倍，约 2–3 帧到原大；遮罩约 220ms 到 0.6；取消后卡片约 80ms 淡出，遮罩约 250ms 褪去 |
| 底部导航 | 锤子时钟 | 选中项是深灰图标 + 深灰粗体字，不是品牌色（和 Kit 一致；应用商店、音乐这类内容应用才用品牌色） |
| Tab 切换 | 锤子时钟四个 Tab 来回切 | 表盘不动、部件分层过渡，见第 5 节 |

没有核对的：右滑删除（手机上没有闹钟和世界时钟城市，没有新建数据）、滚轮和字母索引条，这几项仍以复刻版的数值为准。
