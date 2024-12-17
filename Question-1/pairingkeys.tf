# Creating a New Key
resource "aws_key_pair" "pairkeys" {

  # Name of the Key
  key_name   = "pairing keys"

  # Adding the SSH authorized key !
  public_key = file("~/.ssh/authorized_keys")
  
 }