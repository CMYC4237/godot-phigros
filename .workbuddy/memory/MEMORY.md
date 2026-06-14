# 项目约定 & 关键技术点

## 坐标系统
- **positionX**：1X = 0.05625W（W=画面宽度）
- **floorPosition**：1Y = 0.6H（H=画面高度）
- **时间**：1T = 1.875/BPM 秒
- **设计分辨率**：960×540（canvas_items 拉伸模式）

## Note 数据字段
- `type`(int) / `time`(int, T) / `positionX`(float, X) / `holdTime`(int, T) / `speed`(float) / `floorPosition`(float, Y)
- `speed` 双重含义：普通 note=视觉倍率，Hold=判定时线速度

## 架构决策
- 判定线事件用指针迭代（event_index dict），while 推进跳过过期事件
- 透明度事件用 `$shape.modulate.a` 而非 `self.modulate.a`（防止影响子 note）
- `notes_above`/`notes_below` 原始数据引用不应混入 `notes[]` 实例数组
- `spawn_notes()` 中 `set_length()` 必须放在 `add_child()` 之后（hold._ready() 需要先跑）

## 编码风格
- 一行为一个 Tab 缩进
- 不过度封装，逻辑内联到使用处
- 类级变量尽量写死不依赖运行时

## Speed 事件
- `event.floorPosition` 为累计值，`_ready()` 中预计算
- `floor_position` 当前帧累计值 = 梯形积分 + 该事件 floorPosition

## 渲染模式
- 帧序列存 `output_dir/frames/`，每次渲染前清空
- `update_simulation()` 不覆盖 Globals.current_time（由 render_manager 设）
