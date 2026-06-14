extends Node2D
# ============================================================
# hit_effect.gd — 打击特效脚本
# 音符到达判定线时生成，0.5 秒后自动销毁
# 由两部分组成：
#   1. sprite（Sprite2D）：灰度图逐帧动画，用 self_modulate 染金黄色
#   2. 方块粒子（ColorRect × N）：从中心爆散飞出，缓动减速 + 逐帧淡出
# 时间基于 Globals.current_time（而非 wall-clock delta），
# 确保播放模式与渲染模式下动画速度一致
#
# 节点结构（hit_effect.tscn）：
#   hit_effect (Node2D)
#     ├── sprite (Sprite2D)   — 30 帧逐帧动画
#     └── particles (Node2D)  — 方块粒子容器
# ============================================================

var elapsed = 0.0              # 从开始到现在的逻辑时间（秒）= Globals.current_time - start_time
var start_time = 0.0           # 特效生成时的 Globals.current_time

# 动画贴图参数
var frame_count = 30           # 6 列 × 5 行 = 30 帧
var cols = 5                   # 列数
var rows = 6                   # 行数
var frame_width = 0.0          # 单帧宽度（像素）
var frame_height = 0.0         # 单帧高度（像素）
var current_frame = 0          # 当前播放到的帧序号（0~29）

# 方块粒子列表
# 每颗粒子存储：{ "node": ColorRect, "start_pos": Vector2, "end_pos": Vector2 }
var particles = []


func _ready():
	# 记录开始时间（逻辑时间），后续用 Globals.current_time - start_time 算进度
	start_time = Globals.current_time

	# --- 动画贴图加载 ---
	var tex = preload("res://note_resource/hit_fx.png")
	$sprite.texture = tex
	$sprite.region_enabled = true
	frame_width = tex.get_width() / cols
	frame_height = tex.get_height() / rows

	# 颜色：ARGB e1ffec9f → RGBA ffec9fe1（灰度图叠加后呈金黄色）
	# hit_fx.png 本身是灰度图（白色=亮部，黑色=暗部），modulate 只会改变亮部颜色
	$sprite.self_modulate = Color("ffec9fff")

	# --- 生成方块粒子 ---
	create_particles()


# ============================================================
# create_particles — 创建 4 颗方块粒子
# 每颗从中心向随机方向飞出，终点 = 起点 + 方向 × 速度 × 0.2（爆发距离因子）
# ============================================================
func create_particles():
	for i in range(3):
		var end_distance = randf_range(140, 165)   # 随机初速度（像素/秒）
		var size = 20                          # 方块边长（像素）
		var color = Color("ffec9fff")          # 初始颜色（RGBA 金黄）ffec9fe1

		var angle = randf_range(0, 359)       # 随机飞行角度
		var c = ColorRect.new()               # 用 ColorRect 代替粒子系统
		c.size = Vector2(size, size)
		c.color = color
		var start_pos = -Vector2(size / 2.0, size / 2.0)  # 居中于原点
		c.position = start_pos
		$particles.add_child(c)

		# 计算终点：从起点沿方向飞出 speed * 0.2 的距离
		var dir = Vector2.RIGHT.rotated(deg_to_rad(angle))
		particles.append({
			"node": c,
			"start_pos": start_pos,
			"end_pos": start_pos + dir * end_distance
		})


# ============================================================
# ease_out_quart — 缓出四次方函数
# t: 0→1 的线性进度
# 返回: 0→1 缓动后进度（先快后慢，quart = 四次方）
# 公式: 1 - (1 - t)^3 — 比 expo 温和，比 linear 有力
# ============================================================
func ease_out_quart(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)

func ease_out_exp(t:float):
	return (1.0 - exp(-6.000000 * t)) / (1.0 - exp(-6.000000 * 0.5))

func ease_in_exp(t: float) -> float:
	return 1 - ease_out_exp(1-t)

func _process(delta):
	# 用逻辑时间算进度（而非 wall-clock delta），保证播放/渲染一致
	elapsed = Globals.current_time - start_time

	# 更新动画帧
	update_animation()

	# 更新粒子
	update_particles()

	# 0.5 秒后自动销毁
	if elapsed >= 0.5:
		queue_free()


# ============================================================
# update_animation — 逐帧推进 sprite 动画
# 30 帧均匀分布在 0.5 秒内（每帧 ~16.67ms，60fps 对齐）
# region_rect 从贴图中裁剪当前帧：
#   col = 当前帧 % 5（列索引 0~4）
#   row = 当前帧 / 5（行索引 0~5，整除）
#   x = col × 单帧宽,  y = row × 单帧高
# ============================================================
func update_animation():
	var frame_duration = 0.5 / frame_count
	var new_frame = int(elapsed / frame_duration)
	if new_frame >= frame_count:
		new_frame = frame_count - 1       # 最后一帧保持

	if new_frame != current_frame:
		current_frame = new_frame
		var col = current_frame % cols
		var row = current_frame / cols
		$sprite.region_rect = Rect2(
			col * frame_width,
			row * frame_height,
			frame_width,
			frame_height
		)


# ============================================================
# update_particles — 每帧更新粒子位置和透明度
# 位置：start_pos → end_pos，用 ease_out_quart 缓动（爆发后急停）
# 透明度：从完全不透明线性衰减到完全透明（同步于特效总时长 0.5s）
# ============================================================
func update_particles():
	var t = clamp(elapsed / 0.5, 0.0, 1.0)   # 0→1 线性进度
	var et = ease_out_exp(t)                 # 缓动后进度
	for p in particles:
		# 位置：在 start 和 end 之间按缓动曲线插值
		p.node.position = p.start_pos.lerp(p.end_pos, et)

		# 透明度：从 1 线性降到 0
		var c = p.node.color
		c.a = 1.0 - t
		p.node.color = c
