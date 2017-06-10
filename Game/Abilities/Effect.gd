extends Node

export(int) var effectTurns = 1
export(int, "Damage","Heal","Status") var effectType = "Damage"
export(float) var effectValue = 0
export(String, "None","CanBeAttacked","CanAttack") var effectStatus = "None"