class ReGex{
  static Pattern emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(gmail\.com|yahoo\.com|outlook\.com)$';

  static Pattern namePattern = r'^[a-zA-Z\s]*$';

  static Pattern phonePattern = r'^(\+88)?01[0-9]{9}$';
}