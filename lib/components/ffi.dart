import 'dart:math';

bool ffiTest() {

  //Generate random number between 1 and 10
  var rng = new Random();
  var rand = rng.nextInt(10);
  print(rand);

  //Use the modulus of the random number to generate a random bool
  var preStatus = rand % 2;
  print(preStatus);

  //Return the bool
  if(preStatus == 1) {
    return true;
  } else {
    return false;
  }
}