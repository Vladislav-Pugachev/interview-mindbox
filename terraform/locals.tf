# locals {
#   region_list = flatten([
#     for r in toset(["ru-central1-a","ru-central1-b","ru-central1-c"]) : [
#       for i in toset([ 1, 2, 3, 4, 5]): {
#         se_region = r
#         unique_key = "${r}-${i}"
#       }
#     ]
#   ])

#   region_list_formatted = {
#     for each in local.region_list : each.unique_key => { se_region = each.se_region }
#   }
# }