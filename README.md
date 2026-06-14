# godot-phigros

Phigros 谱面自动播放 + 视频渲染器，基于 Godot 4.6.3 开发。

## 功能

- 支持 ZIP 导入或手动选择谱面、曲绘、音乐
- 自动判定全部 note（autoplay），显示分数、Combo、进度条
- Dual Kawase Blur 曲绘模糊背景
- 打击特效（逐帧动画 + easeOutQuart 粒子）
- 多押高亮、Hold 缩短等视觉细节

## 渲染模式（⚠️ 暂不可用）

由于 ffmpeg 命令行长度限制，打击音效合成在大量 note 时会溢出。渲染功能已暂时废弃，待未来用预混合音轨方案修复。播放模式完全正常可用。

## 运行

1. 用 Godot 4.6.3 打开项目
2. `F5` 运行
3. 导入谱面 ZIP 或手动选 JSON / 曲绘 / 音乐
4. 点击「播放」开始

支持格式：Phigros chart JSON（formatVersion 1 / 3 / 其他）。

## 文件结构

```
.
├── import_screen/    # 主界面，选择谱面/曲绘/音乐
├── world.gd          # 游戏核心（判定线、音符、分数）
├── lines/            # 判定线脚本
├── notes/            # 音符节点（tap / hold / drag / flick）
├── hit_effect/       # 打击特效
├── globals/          # 全局自动加载单例
├── render_manager/   # 渲染管理器（废弃中）
└── note_resource/    # 音符纹理、音效
```

## 已知问题

- 低帧率下 note 移动有细微抖动（帧时序偏差）
- 渲染模式暂时不可用（音效过多导致 ffmpeg 命令行溢出）
