terraform {

}

variable "str" {
	type = string
	default = ""
}
variable "items" {
	type = list
	default = [null,null,"","last"]
}

variable "stuff" {
	type = map
	default = {
		"hello" = "world",
		"goodbye" = "moon"
	}
}

output "now" {
  value = timestamp()
}
output "upper" {
  value = upper(var.str)
}

output "formatted_date" {
  value = formatdate("YYYY-MM-DD", timestamp())
}
output "join_items" {
  value = join("-", var.items)
}
output "lookup_stuff" {
  value = lookup(var.stuff, "hello", "default_value")
}
output "coalesce_items" {
  value = coalesce(var.items...)
}
output "coalesce_stuff" {
  value = coalesce(var.stuff["hello"], var.stuff["goodbye"], "default_value")
}
output "coalesce_empty" {
  value = coalesce("", null, "default_value")
}
output "coalesce_empty_list" {
  value = coalesce([], null, ["default_value"])
}
output "coalesce_empty_map" {
  value = coalesce({}, null, {"default_key" = "default_value"})
}
output "coalesce_empty_string" {
  value = coalesce("", null, "default_value")
}
output "coalesce_empty_string_list" {
  value = coalesce([""], null, ["default_value"])
}
output "coalesce_empty_string_map" {
  value = coalesce({"key" = ""}, null, {"default_key" = "default_value"})
}
output "coalesce_empty_string_map_with_default" {
  value = coalesce({"key" = ""}, null, {"default_key" = "default_value"}, "fallback_value")
}
output "coalesce_empty_string_map_with_default_list" {
  value = coalesce({"key" = ""}, null, {"default_key" = "default_value"}, ["fallback_value"])
}
output "coalesce_empty_string_map_with_default_map" {
  value = coalesce({"key" = ""}, null, {"default_key" = "default_value"}, {"fallback_key" = "fallback_value"})
}
output "coalesce_empty_string_map_with_default_map_and_list" {
  value = coalesce({"key" = ""}, null, {"default_key" = "default_value"}, {"fallback_key" = "fallback_value"}, ["fallback_value"])
}

