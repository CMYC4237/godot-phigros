extends Node2D


var window_size = Vector2(960,540)

var notes = []         #存放notes的实例化对象
var notes_scene = preload("res://notes/notes.tscn")

var data

#定义用来引用各个列表的变量
var notes_above
var notes_below
var bpm
var speed_events
var move_events
var rotate_events
var alpha_events

var floor_position = 0 #累计的floor_position，用于计算note位置

var sec_per_Tick #每个tick的秒数

var pix_per_X = window_size.x * 0.05625
var pix_per_Y = window_size.y * 0.6

var event_index = {
	"speed": 0,
	"move": 0,
	"rotate": 0,
	"alpha": 0
}

const ABOVE = -1
const BELOW = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#初始化线的形状
	$shape.size = Vector2(window_size.x*3, 4.1)
	$shape.position = (Vector2(0,0) - $shape.size) / 2
	
	bpm = data.bpm
	sec_per_Tick = 1.875 / bpm
	
	#引用该线的note列表
	notes_above = data.notesAbove
	notes_below = data.notesBelow
	
	#引用该线的各个事件列表
	speed_events = data.speedEvents
	move_events = data.judgeLineMoveEvents
	rotate_events = data.judgeLineRotateEvents
	alpha_events = data.judgeLineDisappearEvents
	
	#遍历所有note列表，添加到全局的all_notes列表中，用于判断多押
	for i in notes_above:
		i.above = ABOVE
		i.multihit = false
		Globals.all_notes.append(i)
	for i in notes_below:
		i.above = BELOW
		i.multihit = false
		Globals.all_notes.append(i)
	

	#为每个speed_event计算一个累计值floor_position
	var event_fp = 0
	for event in speed_events:
		event.floorPosition = event_fp
		event_fp += event.value * (event.endTime - event.startTime) * 1.875 / bpm

	pass




func update_events():		#更新所有事件
	#更新坐标
	var t
	var start_time
	var end_time
	var start_value
	var end_value


	# ============移动事件============

	#推进事件索引
	start_time = move_events[event_index["move"]].startTime * sec_per_Tick
	end_time = move_events[event_index["move"]].endTime * sec_per_Tick

	while event_index["move"] < move_events.size()-1 and Globals.current_time > end_time:
		event_index["move"] += 1
		start_time = move_events[event_index["move"]].startTime * sec_per_Tick
		end_time = move_events[event_index["move"]].endTime * sec_per_Tick
		

	#处理兼容不同版本的坐标数据格式
	var ver = Globals.chart.formatVersion
	if ver == 1:
		var s = move_events[event_index["move"]].start
		var e = move_events[event_index["move"]].end
		start_value = Vector2(int(s) / 1000.0 / 880.0 * window_size.x, window_size.y - (int(s) % 1000) / 520.0 * window_size.y)
		end_value   = Vector2(int(e) / 1000.0 / 880.0 * window_size.x, window_size.y - (int(e) % 1000) / 520.0 * window_size.y)
	elif ver == 3:
		var ev = move_events[event_index["move"]]
		start_value = Vector2(ev.start * window_size.x, (1.0 - ev.start2) * window_size.y)
		end_value   = Vector2(ev.end   * window_size.x, (1.0 - ev.end2)   * window_size.y)
	else:
		var ev = move_events[event_index["move"]]
		var unit = window_size.y * 0.1
		start_value = Vector2(window_size.x / 2.0 + ev.start * unit, window_size.y / 2.0 - ev.start2 * unit)
		end_value   = Vector2(window_size.x / 2.0 + ev.end   * unit, window_size.y / 2.0 - ev.end2   * unit)


	#计算进度t并处理除零错误
	if end_time != start_time:
		t = (Globals.current_time - start_time) / (end_time - start_time)
	else:
		t = 1.0
	#插值
	self.position = lerp(start_value, end_value, t)



	# ============旋转事件============

	#推进事件索引
	start_time = rotate_events[event_index["rotate"]].startTime * sec_per_Tick
	end_time = rotate_events[event_index["rotate"]].endTime * sec_per_Tick

	while event_index["rotate"] < rotate_events.size()-1 and Globals.current_time > end_time:
		event_index["rotate"] += 1
		start_time = rotate_events[event_index["rotate"]].startTime * sec_per_Tick
		end_time = rotate_events[event_index["rotate"]].endTime * sec_per_Tick

	start_value = rotate_events[event_index["rotate"]].start
	end_value = rotate_events[event_index["rotate"]].end


	#计算进度t并处理除零错误
	if end_time != start_time:
		t = (Globals.current_time - start_time) / (end_time - start_time)
	else:
		t = 1.0
	#插值
	self.rotation = deg2rad(lerp(start_value, end_value, t))



	# ============透明度事件============

	#推进事件索引
	start_time = alpha_events[event_index["alpha"]].startTime * sec_per_Tick
	end_time = alpha_events[event_index["alpha"]].endTime * sec_per_Tick

	while event_index["alpha"] < alpha_events.size()-1 and Globals.current_time > end_time:
		event_index["alpha"] += 1
		start_time = alpha_events[event_index["alpha"]].startTime * sec_per_Tick
		end_time = alpha_events[event_index["alpha"]].endTime * sec_per_Tick

	start_value = alpha_events[event_index["alpha"]].start
	end_value = alpha_events[event_index["alpha"]].end


	#计算进度t并处理除零错误
	if end_time != start_time:
		t = (Globals.current_time - start_time) / (end_time - start_time)
	else:
		t = 1.0
	#插值
	$shape.modulate.a = lerp(start_value, end_value, t)



	# ============速度事件============

	#推进事件索引
	start_time = speed_events[event_index["speed"]].startTime * sec_per_Tick
	end_time = speed_events[event_index["speed"]].endTime * sec_per_Tick

	while event_index["speed"] < speed_events.size()-1 and Globals.current_time > end_time:
		event_index["speed"] += 1
		start_time = speed_events[event_index["speed"]].startTime * sec_per_Tick
		end_time = speed_events[event_index["speed"]].endTime * sec_per_Tick

	start_value = speed_events[event_index["speed"]].value
	end_value = speed_events[event_index["speed"]].value

	

	#计算进度t并处理除零错误
	if end_time != start_time:
		t = (Globals.current_time - start_time) / (end_time - start_time)
	else:
		t = 1.0
		
	#计算floor_position
	floor_position = (
		(start_value + lerp(start_value, end_value, t))
		* (Globals.current_time - start_time) / 2     #积分该事件的速度，本质是算梯形面积
		+ speed_events[event_index["speed"]].floorPosition  #加上该事件之前的floor_position
	)




#更新note的位置
#调用hold是notes[num].hold.xxx
#set_length(300),set_hide_start(true)
var notes_start_pos = 0 #开始渲染的note位置，手动更新，结束位置即为开始位置加对角线，这样即使在最极限的情况也能全部显示应该显示的
						#暂时先不做这个优化，待写完基础


#一次性生成所有notes，将来优化集成到update_note_position()中
func spawn_notes():
	for i in (notes_above + notes_below):
		var n = notes_scene.instantiate()
		n.data = i
		notes.append(n)
		$notes_container.add_child(n)

		n.position.x = i.positionX * pix_per_X
		n.set_type(i.type, i.multihit)
		
		#反向note要翻转
		if i.above == BELOW:
			n.rotation = deg2rad(180)
		
		if i.type == 3:
			var hold_len = i.holdTime * (1.875 / bpm) * i.speed * pix_per_Y / 0.12 #注意：hold的缩放是0.12，所以长度要除以0.12才能正确显示
			n.hold.set_length(hold_len)
	pass


func update_notes():
	for i in notes:
		#更新位置
		i.position.y = (
			(i.data.floorPosition - floor_position)
			* i.data.above 
			* (i.data.speed if i.data.type != 3 else 1)    #hold的speed含义不同，滤掉
			* pix_per_Y
		)

		if i.data.type ==3:
			#清掉已判定的note
			if Globals.current_time > (i.data.time + i.data.holdTime) * sec_per_Tick:
				i.visible = false
				$"../..".on_note_judged()
				notes.erase(i)
				i.queue_free()

			if Globals.current_time > i.data.time * sec_per_Tick:
				i.hold.set_hide_start(true)
				i.position.y = 0
				i.hold.set_length(
					(i.data.time + i.data.holdTime - Globals.current_time / sec_per_Tick)
					* (1.875 / bpm) * i.data.speed * pix_per_Y / 0.12
				)
				if Globals.current_time > i.hold.last_hitfx_tick * sec_per_Tick + 30 / bpm:
					$"../..".spawn_hit_effect(i.global_position)
					i.hold.last_hitfx_tick = Globals.current_time / sec_per_Tick

			
		else:
			#清掉已判定的note
			if Globals.current_time > i.data.time * sec_per_Tick:
				i.visible = false
				#生成打击特效
				i.position.y = 0
				$"../..".spawn_hit_effect(i.global_position)
				$"../..".on_note_judged()
				notes.erase(i)
				i.queue_free()

		#hold缩短

		
	pass





# ============================================================
# 角度转弧度 — Phigros → Godot
# Phigros: 角度正值 = 逆时针，Godot: rotation 正值 = 顺时针
# 因此需要取负再转弧度：godot_radians = deg_to_rad(-angle_degrees)
# ============================================================
func deg2rad(angle: float) -> float:
	return deg_to_rad(-angle)
