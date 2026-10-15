# Figma 节点清单（完整）

文件：[Smartisan OS UI Kit (Unofficial)](https://www.figma.com/community/file/1419385240874679870)，作者 Paix Chan，CC BY 4.0。
17 个页面里的每个组件 / 变体都列在这里，并对应到 CSS 类、示例页锚点、截图和素材文件。要回 Figma 核对：先把社区文件 Duplicate 到自己的草稿，再用副本的 file key 加这里的节点 ID 调 Figma MCP 的 `get_design_context`（复制后节点 ID 不变）。

截图：`references/screenshots/NN-*.png`（每页一张，1:1）。示例：`assets/demo.html#<锚点>`。

---

## 00 Cover（`15:283`）· 截图 `00-cover.png` · 示例 `#cover`
| 节点 | 名称 | 尺寸 | 说明 |
|---|---|---|---|
| `331:420` | Cover | 1920×1080 | 背景横向渐变 `#222325 → #3b3c3f(49%) → #222325` |
| `331:461` | Subtract（锤子 T 标） | 60×60 | `assets/brand/smartisan-t-logo.svg` |
| `331:1769` | Smartisan OS UI Kit（字标） | 767×63 | `assets/brand/wordmark-smartisan-os-ui-kit.svg` |
| `334:1019` | unofficial（徽标） | 77×28 | `assets/brand/badge-unofficial.svg` |
| `334:1158` | 文案 "Based on Smartisan OS 8 on Smartisan R2" | — | Inter Medium 20px `#b8b8b8` |
| `331:897` | Showcase | 920×1132 | 组件拼盘，底 `#f5f5f5` |

## 01 Icons（`253:872`）· `01-icons.png` · `#icons`
| 节点 | 名称 | 尺寸 | 文件 |
|---|---|---|---|
| `66:343` | icon-redcheck | 24 | `icons/redcheck.svg`（彩色） |
| `40:867` | icon-setting | 20 | `icons/setting.svg` |
| `66:463` | icon-unselected | 24 | `icons/unselected.svg` |
| `64:165` | icon-check | 24 | `icons/check.svg`（蓝） |
| `147:223` | icon-back | 20 | `icons/back.svg` |
| `147:234` | icon-mute | 24 | `icons/mute.svg`（`#666→#999`） |
| `67:473` | icon-search | 16 | `icons/search.svg` |
| `67:602` | icon-close（白底圆叉） | 18 | `icons/clear.svg` |
| `173:1504` | icon-add | 17.5×18 | `icons/add.svg` |
| `68:128` | icon-close2（实心粗叉） | 24 | `icons/close.svg` |
| `147:251` | icon-volume | 24 | `icons/volume.svg` |
| `173:1545` | icon-delete | 26 | `icons/delete.svg`（彩色） |
| `76:219` | icon-down（direction=up `76:211` / down `76:220`） | 10 | `icons/chevron-up.svg` / `chevron-down.svg`（原稿两个变体名字反了，已按实际形状命名） |
| `147:309` | icon-confirm | 24 | `icons/confirm.svg` |
| `147:321` | icon-close2（2px 细线叉） | 24 | `icons/close-thin.svg` |
| `72:180` | icon-more | 20 | `icons/more.svg` |
| `204:972` | icon-playlist | 20 | `icons/playlist.svg` |
| `71:270` | icon-playing | 20 | `icons/playing.svg` |
| `175:1589` | icon-star | 24 | `icons/star.svg` |
| `253:1687` | Icon-right | 24 | `icons/chevron-right.svg` |
| `253:2413` | Icon-Play | 24 | `icons/play.svg` |
| `343:983` | icon-like-outlined（底部导航页） | 24 | `icons/like-outlined.svg` |
| `343:994` | icon-star-fill（底部导航页） | 24 | `icons/star-fill.svg` |
| `343:1006` | icon-list（底部导航页） | 24 | `icons/list.svg` |
| `343:1011` | icon-game-filled（底部导航页） | 24 | `icons/game-filled.svg` |
| `40:1026` | ri:menu-add-fill（Icon Button 内） | 18 | `icons/menu-add.svg`（含按钮底） |
| `171:313` / `171:399` | Radio Button | 22 | `icons/radio-on.svg` / `radio-off.svg` |

各组件里的上色版本在 `icons/variants/`（白色 App Bar 图标、Chip 五种颜色的星标和箭头、列表按下/禁用态图标、底部导航选中/未选中图标）。

## 02 App Bar（`253:179`）· `02-app-bar.png` · `#app-bar`
| 节点 | 名称 | 尺寸 | CSS |
|---|---|---|---|
| `40:887` | App Bar 组件集 | — | |
| `40:869` | Color=White | 432×48 | `.s-appbar` |
| `40:888` | Color=Red | 432×48 | `.s-appbar.s-appbar--red` |
| `343:861` | 示例 "Settings"（右侧图标按钮） | 432×48 | `.s-appbar` + `.s-btn-icon` |
| `343:879` | 示例 "App Store"（红，只有返回） | 432×48 | `.s-appbar--red` |
| `343:858` | Label "Examples" | 89×27 | `.s-kit-label` |
组件属性：`showBack`、`show1stIcon`、`show2ndIcon`、`title`，图标槽可替换。

## 03 Button（`245:806`）· `03-button.png` · `#button`
| 节点 | 名称 | 尺寸 | CSS |
|---|---|---|---|
| `18:6` / `18:4` / `18:5` | Elevated Button normal / pressed / disabled | 408×60 | `.s-btn` / `.is-pressed` / `:disabled` |
| `147:412` / `147:411` / `147:410` | Small Elevated Button Enabled / Pressed / Disabled | 62×30 | `.s-btn.s-btn--sm` |
| `26:39` / `27:139` | BottomSheet Button Default / pressed | 392×48 | `.s-btn.s-btn--sheet` |
| `26:83` | Segmented Button（4 段条） | 410×60 | `.s-segmented` |
| `208:1262` / `208:1264` | Segmented 单项（命名反了：`Selected=False` 才是蓝块） | 100×60 | `button[aria-pressed]` |
| `147:270` | Text Button | 49×12 | `.s-btn.s-btn--text` |
| `26:13` | Outlined Button | 94×30 | `.s-btn.s-btn--outline` |
| `40:1028` | Icon Button | 38×30 | `.s-btn-icon` |
| `19:30` / `20:6` | Rounded Button large normal / pressed | 80 | `.s-round-btn` |
| `24:58` / `24:60` | Rounded Button small normal / pressed | 28 | `.s-round-btn.s-round-btn--sm` |
原始渲染：`assets/kit-renders/rounded-button-*.svg`。

## 04 Bottom Navigation Bar（`249:1227`）· `04-bottom-navigation-bar.png` · `#bottom-nav`
| 节点 | 名称 | 尺寸 | CSS |
|---|---|---|---|
| `203:2020` | Bottom Navigation Bar（Play List / Playing / More） | 432×54 | `.s-bottom-nav` |
| `71:272` / `71:286` | Bottom Navigation Bar Item Selected=False / True | 38×40 | `[aria-current="page"]` |
| `343:943` | 示例（Recommend / Hot / Classify / Game） | 432×54 | `.s-bottom-nav` |
| `343:960` | Label "Examples" | — | `.s-kit-label` |

## 05 Bottom Sheet（`253:838`）· `05-bottom-sheet.png` · `#bottom-sheet`
| 节点 | 名称 | 尺寸 | CSS |
|---|---|---|---|
| `27:121` | BottomSheet（标题 + 右 × + 两个白按钮） | 432×226 | `.s-sheet` |
| `204:1173` | Bottom Sheet Header（左 × / 标题 / 右 ✓） | 432×48 | `.s-sheet__header` |

## 06 Chip（`253:128`）· `06-chip.png` · `#chip`
组件集 `253:2478`，40 个变体 = 颜色 {White, Yellow, Blue, Red, Grey} × 状态 {Enabled, Pressed} × 样式 {All, Leading, Trailing, None}（Grey 只有 Enabled；原稿第 5 行 "White, Pressed" 和 "Yellow, Pressed" 是重复示例）。
CSS：`.s-chip` + 颜色 `--yellow/--blue/--red/--grey` + 样式 `--all/--leading/--trailing` + `.is-pressed`。
节点 ID：White `41:1077 259:375 259:870 259:874 259:980 259:983 259:501 259:505`；Yellow `259:316 259:393 259:878 259:894 259:986 259:998 259:509 259:525`；Blue `259:322 259:381 259:898 259:882 259:1001 259:989 259:529 259:513`；Red `259:334 259:405 259:902 259:886 259:1004 259:992 259:533 259:517`；Grey `259:351 259:906 259:1007 259:537`。

## 07 Date Time Picker（`253:852`）· `07-date-time-picker.png` · `#picker`
| `147:276` | DatePicker（2024-08-01 Wed，年/月/日三列） | 432×274 | `.s-picker` |
|---|---|---|---|
| `147:390` | TimePicker（时/分/上午下午） | 432×274 | `.s-picker` |

## 08 Dialog（`248:871`）· `08-dialog.png` · `#dialog`
| 节点 | 名称 | 尺寸 | CSS |
|---|---|---|---|
| `8:249` / `11:163` | Dialog state=Default / pressed（带遮罩） | 433×408 / 432 | `.s-overlay` + `.s-dialog`（`.is-pressed`） |
| `40:1064` | Simple Dialog | 432×360 | `.s-dialog--simple` |
| `195:1210` | List Dialog（4 个单选 + 1 个操作） | 432×463 | `.s-dialog__body--flush` + `.s-radio-item` |
| `195:1211` | TextField Dialog | 432×262 | `.s-dialog__body--field` + `.s-textfield` |
| `171:272` | Dialog Header | 368×48 | `.s-dialog__header` |
| `253:1208` / `253:1209` / `253:1207` | Dialog Action Group Count=1 / 2 / 3 | 368×54 | `.s-dialog__actions` |
| `253:1047` / `253:1050` | Dialog Action Button Primary Enabled / Pressed | 368×54 | `button[data-primary]` |
| `253:1197` / `253:1199` | Dialog Action Button 次要 Enabled / Pressed | 368×54 | `button` |
| `171:313` / `171:399` | Radio Button Selected=True / False | 22 | `.s-radio` |
| `171:369` | Radio List Item | 368×48.8 | `.s-radio-item` |
| `172:455` | Text Field Size=Narrow（"Be used in dialog"） | 332×34 | `.s-textfield` |

## 09 Divider（`253:210`）· `09-divider.png` · `#divider`
| `173:1303` | Divider | 368×0.8 | `.s-divider` |
|---|---|---|---|
| `208:1274` | Divider-Short | 0.8×12 | `.s-divider--short` |
| `197:1228` | Vertical Divider | 1×54 | `.s-divider--v` |

## 10 List（`248:872`）· `10-list.png` · `#list`
| 节点 | 名称 | 尺寸 | CSS |
|---|---|---|---|
| `203:1548` | List（分组标题 + 卡片 + 说明） | 413×223 | `.s-list-group` |
| `253:1286` / `253:1342` / `253:2383` | List Tile Enabled / Pressed / Disabled | 412×60.8 | `.s-list-item`（`.is-pressed` / `aria-disabled`） |
| `253:2000` | List Tile 2 | 412×60.8 | `.s-list-item--simple` |
| `211:1303` | List Tile 3 | 412×60.5 | `.s-list-item--plain` |
| `211:1357` | Slidable List Tile | 432×60 | `.s-swipe` |
| `173:894` / `253:1361` | List Item Detail Enabled / Pressed | 68×24 | `.s-list-item__detail` |

## 11 Popup Menu（`249:1126`）· `11-popup-menu.png` · `#popup-menu`
| `175:1583` | Popup Menu Item | 220×43 | `.s-menu > button` |
|---|---|---|---|
| `253:2463` | Popup Menu（3 项） | 220×129 | `.s-menu` |

## 12 Search Bar（`249:1242`）· `12-search-bar.png` · `#search`
| `68:140` | Search Field | 380×30 | `.s-search-field` |
|---|---|---|---|
| `68:142` | Search Bar | 432×48 | `.s-search` |
| `70:1103` | Search Result Item | 432×60 | `.s-result` |
| `181:530` | Search Result List | 432×240 | `.s-result` × n |
| `185:3469` | Search Bar With Result | 432×288 | `.s-search-with-result` |

## 13 Slide Bar（`253:165`）· `13-slide-bar.png` · `#slide-bar`
| `204:1217` | Slide Bar - Contained | 408×60 | `.s-slider-card` |
|---|---|---|---|
| `29:112` | Slide Bar | 372×24 | `.s-slider-row` |

## 14 Switch（`248:873`）· `14-switch.png` · `#switch`
| `42:1332` / `42:1334` | Switch Button selected=true / false | 52×24 | `.s-switch` |
|---|---|---|---|

## 15 Tab Bar（`249:1212`）· `15-tab-bar.png` · `#tab-bar`
| `179:3017` | Tabs（3 项） | 180×28.8 | `.s-tabs` |
|---|---|---|---|
| `203:1865` / `203:1863` | Tab Selected=False / True | 60×28 | `button[aria-selected]` |
注意：这一页的展示板底色是白色，其余页面是 `#f5f5f5`。

## 16 Toast（`253:113`）· `16-toast.png` · `#toast`
| `40:1076` | Toast | 218×41 | `.s-toast` |
|---|---|---|---|

## 文档外框（每页都有）
| `248:874` | Header（各页顶部深色标题栏） | 宽×220 | `.s-kit-header` |
|---|---|---|---|
| `261:442` | Label | — | `.s-kit-label` |
| — | 展示板：底 `#f5f5f5`（Tab Bar 页为白），圆角 40，外层画布 `#dddddd` | | `.s-kit-board` / `.s-kit-canvas` |
| — | 组件集虚线框：1px `#9a9a9a`，dash 10 5，圆角 5（Chip、List 页用 Figma 默认紫色虚线） | | `.s-kit-set` |
