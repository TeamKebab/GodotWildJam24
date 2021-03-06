extends Node


onready var hp_label : Label = find_node("HP")
onready var hearts = find_node("Hearts")

onready var time_of_day: Label = find_node("TimeOfDay")
onready var age_progress: TextureProgress = find_node("AgeProgress")

onready var text_label : RichTextLabel = find_node("Narrator")
onready var narrator_box : Control = find_node("NarratorBox")
onready var buttons: Container = find_node("Buttons")

onready var tooltip_box : PanelContainer = find_node("BabyTooltips")
onready var tooltip_text : RichTextLabel = find_node("BabyTooltipsText")

onready var animation_player : AnimationPlayer = find_node("AnimationPlayer")

func _ready():
	Game.connect("time_passes", self, "_on_time_passes")
	Game.connect("day_ended", self, "_on_day_ended")
	
	Game.connect("player_hp_changed", self, "_on_player_hp_changed")
	
	Narrator.gui = self
	
	narrator_box.hide()
	tooltip_box.hide()
	
	hearts.value = Game.hp
	hp_label.text = str(Game.hp)
	
	time_of_day.text = str(Game.time_of_day)
	age_progress.max_value = Game.END_OF_DAY
	age_progress.value = Game.time_of_day


func close_dialog():
	narrator_box.hide()		
	tooltip_box.hide()


func show_dialog(text, actions, tooltip = null):
	text_label.text = text
	
	for i in buttons.get_children():
		i.queue_free()
		
	for i in actions:
		var label = Label.new()
		label.text = i
		buttons.add_child(label)
	
	# resize for text (WTF)
	narrator_box.show()
	narrator_box.hide()
		
	narrator_box.show()	
	
	if tooltip != null:
		tooltip_text.bbcode_text = tooltip
		tooltip_box.show()
		tooltip_box.hide()
		
		tooltip_box.show()	
		

func _on_time_passes(time):
	time_of_day.text = str(time)
	age_progress.value = time


func _on_day_ended():
	animation_player.play("Night")
	yield(animation_player, "animation_finished")	
	
	yield(Game.prepare_day(), "completed")
		
	get_tree().paused = true	
	
	time_of_day.text = str(0)	
	age_progress.value = 0
	
	animation_player.play("Day")
	yield(animation_player, "animation_finished")
		
	get_tree().paused = false
	
	Game.start_day()


func _on_player_hp_changed(hp):
	hp_label.text = str(hp)
	hearts.value = hp
