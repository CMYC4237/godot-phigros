extends Node2D
# ============================================================
# notes.gd — 通用音符节点脚本
# 一个场景文件（notes.tscn），四种音符共用：
#   - Tap(1) / Drag(2) / Flick(4)：切换 $normal_note 的贴图即可
#   - Hold(3)：移除 $normal_note，动态实例化 hold.tscn 作为子节点
# 通过 set_type() 方法设置音符类型和是否多押高亮
# ============================================================

var note_type: int        # 当前音符类型：tap 1 / drag 2 / hold 3 / flick 4

# ============================================================
# 纹理资源预加载
# 普通版 + 多押高亮版（_mh = multi-highlight）
# preload 在脚本加载时执行一次，后续切换贴图零开销
# ============================================================
var tap_tex = preload("res://note_resource/click.png")
var hold_tex = preload("res://note_resource/hold.png")
var drag_tex = preload("res://note_resource/drag.png")
var flick_tex = preload("res://note_resource/flick.png")

var tap_mh_tex = preload("res://note_resource/click_mh.png")
var hold_mh_tex = preload("res://note_resource/hold_mh.png")
var drag_mh_tex = preload("res://note_resource/drag_mh.png")
var flick_mh_tex = preload("res://note_resource/flick_mh.png")

# Hold 场景预加载（Hold 结构较复杂，独立为一个场景）
var hold_scene = preload("res://notes/hold.tscn")
var hold           # 实例化后的 Hold 节点引用

var data          #存储音符数据

# ============================================================
# set_type — 设置音符类型
# set_note_type: "tap"/"drag"/"hold"/"flick"
# mh: 是否多押高亮（Multi-Highlight），true = 使用 _mh 纹理
# ============================================================
func set_type(set_note_type: int, mh: bool):
	note_type = set_note_type
	match set_note_type:
		1:
			$normal_note.texture = tap_mh_tex if mh else tap_tex
		2:
			$normal_note.texture = drag_mh_tex if mh else drag_tex
		4:
			$normal_note.texture = flick_mh_tex if mh else flick_tex
		3:
			# Hold 特殊处理：移除普通方块，换为 hold.tscn 实例
			$normal_note.queue_free()
			var h = hold_scene.instantiate()
			h.mh = mh
			add_child(h)
			hold = h


func _ready() -> void:
	scale = Vector2(0.12, 0.12)     # 注意：缩放到合适大小


func _process(delta: float) -> void:
	pass
