resource "aws_iam_user" "lb" {
  for_each = toset(["tim", "adam", "brad", "ann"])
  name = each.value
}

resource "aws_iam_group" "developers" {
  name = "groupset"
  
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    for i in aws_iam_user.lb  : i.name 
  ]

  group = aws_iam_group.developers.name
}

