extends Node

export(int) var Power = 1 #power will be multiplied by the PSU
export(int) var RamUsage 
export(int, "Damage","Heal","ApplyEffect") var AbilityType = "Damage"
export(String) var Effect = null #Only if it has Apply Effect
