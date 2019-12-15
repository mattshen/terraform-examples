resource "aws_dynamodb_table" "codingtips-dynamodb-table" {
  name           = "CodingTips"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Author"
  range_key      = "Date"

  attribute {
    name = "Author"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "N"
  }
}
